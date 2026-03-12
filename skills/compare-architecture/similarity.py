#!/usr/bin/env python3
"""Multi-axis similarity scorer for architecture catalog comparison.

Scores similarity between a user's repo classification and catalog entries
across four axes: style overlap, domain match, scope/use-type alignment,
and quality attribute overlap. Applies confidence weighting.

Usage:
    from similarity import score_similarity, rank_similar
    from catalog_loader import CatalogEntry

    user = CatalogEntry(
        project_name="my-app",
        architecture_styles=["Microservices", "Event-Driven"],
        domain="E-Commerce",
        scope="application",
        quality_attributes=["Deployability", "Scalability"],
        classification_confidence=0.9,
    )
    ranked = rank_similar(user, catalog_entries, top_n=10)
"""

import math
from dataclasses import dataclass, field

from catalog_loader import CatalogEntry


# Domain category groups for categorical matching.
DOMAIN_GROUPS: dict[str, list[str]] = {
    "E-Commerce": ["E-Commerce", "Retail", "Shopping"],
    "Developer Tools": [
        "Developer Tools",
        "DevOps",
        "Build Systems",
        "IDE",
    ],
    "Communication": ["Communication", "Social Media", "Messaging"],
    "Content": [
        "CMS",
        "Content Management",
        "Knowledge Management",
        "Documentation",
    ],
    "Data": [
        "Data Processing",
        "Analytics",
        "Data Pipeline",
        "Database",
    ],
}

# Build reverse lookup: domain string -> group name.
_DOMAIN_TO_GROUP: dict[str, str] = {}
for group_name, members in DOMAIN_GROUPS.items():
    for member in members:
        _DOMAIN_TO_GROUP[member.lower()] = group_name


# Combined score weights.
STYLE_WEIGHT = 0.4
DOMAIN_WEIGHT = 0.25
SCOPE_WEIGHT = 0.15
QA_WEIGHT = 0.2


@dataclass
class SimilarityScore:
    """Detailed similarity score with per-axis breakdown."""

    project_name: str
    overall: float = 0.0
    style_score: float = 0.0
    domain_score: float = 0.0
    scope_score: float = 0.0
    qa_score: float = 0.0
    confidence_factor: float = 1.0
    entry: CatalogEntry | None = None


def _get_domain_group(domain: str) -> str | None:
    """Get the domain group for a domain string.

    Handles compound domains like "Knowledge Management / Collaborative Workspace"
    by checking each component.
    """
    # Try exact match first.
    group = _DOMAIN_TO_GROUP.get(domain.lower())
    if group:
        return group

    # Try each component of compound domains (split on / or ,).
    for sep in ["/", ","]:
        if sep in domain:
            for part in domain.split(sep):
                part = part.strip()
                group = _DOMAIN_TO_GROUP.get(part.lower())
                if group:
                    return group

    return None


def _style_similarity(styles_a: list[str], styles_b: list[str]) -> float:
    """Compute weighted Jaccard similarity on architecture styles.

    Primary style (first in list) is weighted 2x.
    Formula: weighted_intersection / weighted_union
    """
    if not styles_a and not styles_b:
        return 0.0
    if not styles_a or not styles_b:
        return 0.0

    def weighted_set(styles: list[str]) -> dict[str, float]:
        weights: dict[str, float] = {}
        for i, s in enumerate(styles):
            s_lower = s.lower().strip()
            weight = 2.0 if i == 0 else 1.0
            # If same style appears multiple times, take max weight.
            weights[s_lower] = max(weights.get(s_lower, 0.0), weight)
        return weights

    wa = weighted_set(styles_a)
    wb = weighted_set(styles_b)

    all_styles = set(wa.keys()) | set(wb.keys())
    intersection = 0.0
    union = 0.0

    for s in all_styles:
        a_w = wa.get(s, 0.0)
        b_w = wb.get(s, 0.0)
        intersection += min(a_w, b_w)
        union += max(a_w, b_w)

    if union == 0.0:
        return 0.0

    return intersection / union


def _domain_similarity(domain_a: str, domain_b: str) -> float:
    """Score domain similarity.

    Exact match = 1.0
    Categorical match (same domain group) = 0.7
    No match = 0.0
    """
    if not domain_a or not domain_b:
        return 0.0

    # Exact match (case-insensitive).
    if domain_a.lower().strip() == domain_b.lower().strip():
        return 1.0

    # Check if either domain contains the other (handles compound domains).
    a_lower = domain_a.lower().strip()
    b_lower = domain_b.lower().strip()
    if a_lower in b_lower or b_lower in a_lower:
        return 1.0

    # Categorical match via domain groups.
    group_a = _get_domain_group(domain_a)
    group_b = _get_domain_group(domain_b)

    if group_a and group_b and group_a == group_b:
        return 0.7

    return 0.0


def _scope_similarity(scope_a: str, scope_b: str) -> float:
    """Score scope alignment per ADR-001.

    Same scope = 1.0
    Different scope = 0.3
    """
    if scope_a.lower().strip() == scope_b.lower().strip():
        return 1.0
    return 0.3


def _qa_similarity(qa_a: list[str], qa_b: list[str]) -> float:
    """Compute Jaccard similarity on quality attributes.

    Both empty = 0.5 (neutral).
    """
    if not qa_a and not qa_b:
        return 0.5

    if not qa_a or not qa_b:
        return 0.0

    set_a = {q.lower().strip() for q in qa_a}
    set_b = {q.lower().strip() for q in qa_b}

    intersection = len(set_a & set_b)
    union = len(set_a | set_b)

    if union == 0:
        return 0.5

    return intersection / union


def score_similarity(
    user: CatalogEntry,
    candidate: CatalogEntry,
) -> SimilarityScore:
    """Score similarity between user's classification and a catalog entry.

    Returns a SimilarityScore with per-axis breakdown and confidence-weighted
    overall score.
    """
    style = _style_similarity(user.architecture_styles, candidate.architecture_styles)
    domain = _domain_similarity(user.domain, candidate.domain)
    scope = _scope_similarity(user.scope, candidate.scope)
    qa = _qa_similarity(user.quality_attributes, candidate.quality_attributes)

    # Confidence weighting: gently penalize low-confidence entries.
    conf_factor = math.sqrt(candidate.classification_confidence)

    # Combined weighted score.
    raw = (
        STYLE_WEIGHT * style
        + DOMAIN_WEIGHT * domain
        + SCOPE_WEIGHT * scope
        + QA_WEIGHT * qa
    )
    overall = raw * conf_factor

    return SimilarityScore(
        project_name=candidate.project_name,
        overall=round(overall, 4),
        style_score=round(style, 4),
        domain_score=round(domain, 4),
        scope_score=round(scope, 4),
        qa_score=round(qa, 4),
        confidence_factor=round(conf_factor, 4),
        entry=candidate,
    )


def rank_similar(
    user: CatalogEntry,
    catalog: list[CatalogEntry],
    top_n: int = 10,
) -> list[SimilarityScore]:
    """Score all catalog entries against user and return top N.

    Excludes the user's own project (by name match) from results.
    Returns sorted descending by overall score.
    """
    scores = []
    for entry in catalog:
        # Skip self-comparison.
        if entry.project_name.lower() == user.project_name.lower():
            continue
        scores.append(score_similarity(user, entry))

    scores.sort(key=lambda s: s.overall, reverse=True)
    return scores[:top_n]


if __name__ == "__main__":
    # Quick test: score a sample e-commerce microservices project.
    import argparse
    import os

    from catalog_loader import load_catalog

    parser = argparse.ArgumentParser(description="Test similarity scoring")
    parser.add_argument(
        "--repo-root",
        default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", ".."),
        help="Path to architecture-reference repo root",
    )
    args = parser.parse_args()

    catalog = load_catalog(args.repo_root)
    print(f"Loaded {len(catalog)} catalog entries")

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

    ranked = rank_similar(test_user, catalog, top_n=10)
    print(f"\nTop {len(ranked)} similar projects for: {test_user.project_name}")
    print(f"  Styles: {test_user.architecture_styles}")
    print(f"  Domain: {test_user.domain}")
    print()

    for i, s in enumerate(ranked, 1):
        print(
            f"  {i:2d}. {s.project_name:<35s} "
            f"score={s.overall:.3f}  "
            f"style={s.style_score:.2f}  "
            f"domain={s.domain_score:.2f}  "
            f"scope={s.scope_score:.2f}  "
            f"qa={s.qa_score:.2f}  "
            f"conf={s.confidence_factor:.2f}"
        )
