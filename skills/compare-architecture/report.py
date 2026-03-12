#!/usr/bin/env python3
"""Comparison report generator.

Takes a user's classification and ranked similar projects, generates
a markdown comparison report using a Jinja2 template.

Usage:
    from report import generate_report
    from catalog_loader import CatalogEntry, load_catalog
    from similarity import rank_similar

    user = CatalogEntry(...)
    catalog = load_catalog(repo_root)
    ranked = rank_similar(user, catalog, top_n=10)
    markdown = generate_report(user, ranked, catalog)
"""

import math
import os
import sys
from collections import Counter
from datetime import date

from catalog_loader import CatalogEntry

try:
    from jinja2 import Environment, FileSystemLoader
except ImportError:
    print(
        "Error: Jinja2 required. Install with: uv pip install jinja2",
        file=sys.stderr,
    )
    sys.exit(1)

from similarity import SimilarityScore, STYLE_WEIGHT, DOMAIN_WEIGHT, SCOPE_WEIGHT, QA_WEIGHT


def _compute_style_stats(
    primary_style: str,
    catalog: list[CatalogEntry],
) -> dict | None:
    """Compute frequency statistics for the user's primary style.

    Returns dict with count, total_production, percentage, rank.
    Only counts production entries.
    """
    if not primary_style:
        return None

    # Count production entries by primary style.
    production = [e for e in catalog if e.use_type == "production"]
    if not production:
        return None

    style_counts: Counter[str] = Counter()
    for e in production:
        for s in e.architecture_styles:
            style_counts[s] += 1

    count = style_counts.get(primary_style, 0)

    # Rank: position in frequency ranking (1-indexed).
    ranked_styles = style_counts.most_common()
    rank = 1
    for i, (s, _) in enumerate(ranked_styles, 1):
        if s == primary_style:
            rank = i
            break

    return {
        "count": count,
        "total_production": len(production),
        "percentage": (count / len(production)) * 100 if production else 0,
        "rank": rank,
    }


def _count_style_combo(
    styles: list[str],
    catalog: list[CatalogEntry],
) -> int:
    """Count how many catalog entries share the exact same style combination."""
    if not styles:
        return 0

    user_set = {s.lower() for s in styles}
    count = 0
    for e in catalog:
        entry_set = {s.lower() for s in e.architecture_styles}
        if entry_set == user_set:
            count += 1
    return count


def _compute_strengths_and_gaps(
    user: CatalogEntry,
    similar: list[SimilarityScore],
) -> tuple[list[str], list[dict]]:
    """Compare user's QAs against union of similar projects' QAs.

    Returns (strengths, gaps) where:
    - strengths: list of description strings
    - gaps: list of {attribute, projects} dicts
    """
    user_qa = {q.lower().strip() for q in user.quality_attributes}

    # Collect all QAs from similar projects with their sources.
    qa_sources: dict[str, list[str]] = {}
    for s in similar:
        if s.entry:
            for qa in s.entry.quality_attributes:
                qa_lower = qa.lower().strip()
                if qa_lower not in qa_sources:
                    qa_sources[qa_lower] = []
                qa_sources[qa_lower].append(s.project_name)

    # Strengths: user's QAs that appear in similar projects (validated).
    strengths = []
    for qa in user.quality_attributes:
        qa_lower = qa.lower().strip()
        matching_projects = qa_sources.get(qa_lower, [])
        if matching_projects:
            strengths.append(
                f"**{qa}** -- consistent with {len(matching_projects)} similar project(s): "
                f"{', '.join(matching_projects[:3])}"
                f"{'...' if len(matching_projects) > 3 else ''}"
            )
        else:
            strengths.append(
                f"**{qa}** -- distinctive; not commonly observed in similar projects"
            )

    # Gaps: QAs in similar projects but not in user's project.
    gaps = []
    for qa_lower, projects in sorted(qa_sources.items()):
        if qa_lower not in user_qa:
            # Use the original casing from the first project that has it.
            original_name = qa_lower.title()
            for s in similar:
                if s.entry:
                    for qa in s.entry.quality_attributes:
                        if qa.lower().strip() == qa_lower:
                            original_name = qa
                            break
                    else:
                        continue
                    break

            gaps.append(
                {
                    "attribute": original_name,
                    "projects": projects[:5],
                }
            )

    return strengths, gaps


def _generate_recommendations(
    user: CatalogEntry,
    similar: list[SimilarityScore],
    gaps: list[dict],
    style_stats: dict | None,
    catalog: list[CatalogEntry],
) -> list[str]:
    """Generate 3-5 actionable recommendations grounded in evidence.

    Each recommendation cites specific catalog entries.
    """
    recommendations = []

    # Recommendation 1: Study top match.
    if similar:
        top = similar[0]
        recommendations.append(
            f"**Study {top.project_name}** (similarity: {top.overall:.2f}) as a reference. "
            f"It shares your {', '.join(set(user.architecture_styles) & set(top.entry.architecture_styles if top.entry else []))} "
            f"style(s) and operates in a similar context."
            f"{' Source: ' + top.entry.source_url if top.entry and top.entry.source_url else ''}"
        )

    # Recommendation 2: Address top gap.
    if gaps:
        top_gap = gaps[0]
        recommendations.append(
            f"**Consider investing in {top_gap['attribute']}**. "
            f"Among your {len(similar)} most similar projects, "
            f"{', '.join(top_gap['projects'][:3])} demonstrate this quality attribute. "
            f"Review their implementations for patterns you could adopt."
        )

    # Recommendation 3: Style combination rarity/commonality.
    if style_stats and len(user.architecture_styles) >= 2:
        combo_count = _count_style_combo(user.architecture_styles, catalog)
        if combo_count <= 2:
            recommendations.append(
                f"**Your style combination ({', '.join(user.architecture_styles)}) is rare** "
                f"({combo_count} match{'es' if combo_count != 1 else ''} in the catalog). "
                f"This can be a strength (differentiation) or a risk (fewer reference points). "
                f"Review similar projects that use subsets of your styles for partial guidance."
            )
        else:
            recommendations.append(
                f"**Your style combination ({', '.join(user.architecture_styles)}) is well-represented** "
                f"({combo_count} matches in the catalog). "
                f"Leverage the reference base for architectural decisions and trade-off analysis."
            )

    # Recommendation 4: Scope-specific insight.
    scope_matches = [
        s for s in similar
        if s.entry and s.entry.scope == user.scope and s.overall >= 0.3
    ]
    if scope_matches and len(scope_matches) >= 2:
        scope_names = [s.project_name for s in scope_matches[:3]]
        recommendations.append(
            f"**Compare {user.scope}-scope peers**: {', '.join(scope_names)} "
            f"are the closest {user.scope}-scope projects in the catalog. "
            f"Their architectural decisions are most directly applicable to your context."
        )

    # Recommendation 5: Second gap or general advice.
    if len(gaps) >= 2:
        second_gap = gaps[1]
        recommendations.append(
            f"**Evaluate {second_gap['attribute']}** as a potential improvement area. "
            f"Projects like {', '.join(second_gap['projects'][:2])} in your similarity cohort "
            f"invest in this attribute."
        )
    elif not gaps and user.quality_attributes:
        recommendations.append(
            f"**Your quality attribute coverage is strong** relative to similar projects. "
            f"Consider whether your architecture supports additional attributes "
            f"(Performance, Security, Testability) that are not visible in source code analysis."
        )

    return recommendations[:5]


def generate_report(
    user: CatalogEntry,
    similar: list[SimilarityScore],
    catalog: list[CatalogEntry],
    generated_date: str | None = None,
) -> str:
    """Generate a markdown comparison report.

    Args:
        user: The user's repo classification as a CatalogEntry.
        similar: Ranked list of SimilarityScore objects from rank_similar().
        catalog: Full catalog for statistical context.
        generated_date: Override date string (default: today).

    Returns:
        Rendered markdown string.
    """
    if generated_date is None:
        generated_date = str(date.today())

    # Compute statistical context.
    primary_style = user.architecture_styles[0] if user.architecture_styles else ""
    style_stats = _compute_style_stats(primary_style, catalog)
    style_combo_count = _count_style_combo(user.architecture_styles, catalog)

    # Percentile note.
    percentile_note = ""
    if style_stats and style_stats["percentage"] > 0:
        pct = style_stats["percentage"]
        if pct >= 40:
            percentile_note = (
                f"Your primary style is among the most common in production systems."
            )
        elif pct >= 10:
            percentile_note = (
                f"Your primary style has moderate adoption in production systems."
            )
        else:
            percentile_note = (
                f"Your primary style is relatively uncommon in production systems "
                f"({style_stats['percentage']:.1f}% of production entries). "
                f"Fewer reference points may mean less community guidance but also less competition."
            )

    # Strengths and gaps.
    strengths, gaps = _compute_strengths_and_gaps(user, similar)

    # Recommendations.
    recommendations = _generate_recommendations(
        user, similar, gaps, style_stats, catalog
    )

    # Render template.
    template_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "references")
    env = Environment(
        loader=FileSystemLoader(template_dir),
        keep_trailing_newline=True,
    )
    template = env.get_template("comparison-report.template.j2")

    # Convert user to a dict-like object for template access.
    from dataclasses import asdict
    user_dict = asdict(user)

    rendered = template.render(
        generated_date=generated_date,
        total_catalog_entries=len(catalog),
        user=user_dict,
        similar=similar,
        style_weight=STYLE_WEIGHT,
        domain_weight=DOMAIN_WEIGHT,
        scope_weight=SCOPE_WEIGHT,
        qa_weight=QA_WEIGHT,
        primary_style_stats=style_stats,
        style_combo_count=style_combo_count,
        percentile_note=percentile_note,
        strengths=strengths,
        gaps=gaps,
        recommendations=recommendations,
    )

    return rendered


if __name__ == "__main__":
    import argparse

    from catalog_loader import load_catalog
    from similarity import rank_similar

    parser = argparse.ArgumentParser(description="Generate test comparison report")
    parser.add_argument(
        "--repo-root",
        default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."),
        help="Path to architecture-reference repo root",
    )
    parser.add_argument("--output", default=None, help="Output file (default: stdout)")
    args = parser.parse_args()

    # Load catalog.
    catalog = load_catalog(args.repo_root)
    print(f"Loaded {len(catalog)} catalog entries", file=sys.stderr)

    # Create a test user classification.
    test_user = CatalogEntry(
        project_name="test-ecommerce-app",
        architecture_styles=["Microservices", "Event-Driven"],
        domain="E-Commerce",
        scope="application",
        use_type="production",
        quality_attributes=["Deployability", "Scalability"],
        classification_confidence=0.85,
    )

    # Score and rank.
    ranked = rank_similar(test_user, catalog, top_n=10)

    # Generate report.
    report = generate_report(test_user, ranked, catalog)

    if args.output:
        with open(args.output, "w") as f:
            f.write(report)
        print(f"Report written to {args.output}", file=sys.stderr)
    else:
        print(report)
