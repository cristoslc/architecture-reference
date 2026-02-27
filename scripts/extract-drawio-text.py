#!/usr/bin/env python3
"""Extract text labels from .drawio files to markdown.

Handles both plain XML (<mxGraphModel> directly) and compressed
(base64 + raw deflate + URL-encoded) diagram content.
Multi-page diagrams produce one section per page.
"""

import base64
import re
import sys
import urllib.parse
import xml.etree.ElementTree as ET
import zlib
from html.parser import HTMLParser
from pathlib import Path


class HTMLTextExtractor(HTMLParser):
    """Strip HTML tags, keeping only text content."""

    def __init__(self):
        super().__init__()
        self.parts = []

    def handle_data(self, data):
        self.parts.append(data)

    def get_text(self):
        return "".join(self.parts).strip()


def strip_html(html_str: str) -> str:
    extractor = HTMLTextExtractor()
    extractor.feed(html_str)
    return extractor.get_text()


def decompress_diagram(data: str) -> str:
    """Decompress base64 + raw-deflate + URL-encoded diagram content."""
    decoded = base64.b64decode(data)
    inflated = zlib.decompress(decoded, -15)
    return urllib.parse.unquote(inflated.decode("utf-8"))


def extract_labels_from_xml(xml_str: str) -> list[str]:
    """Extract all non-empty value attributes from mxCell elements."""
    labels = []
    try:
        root = ET.fromstring(xml_str)
    except ET.ParseError:
        return labels

    for cell in root.iter("mxCell"):
        value = cell.get("value", "").strip()
        if value:
            text = strip_html(value)
            if text:
                labels.append(text)

    # Also check for UserObject elements (used for links/tooltips)
    for obj in root.iter("UserObject"):
        label = obj.get("label", "").strip()
        if label:
            text = strip_html(label)
            if text:
                labels.append(text)

    return labels


def process_drawio(filepath: Path) -> str:
    """Process a .drawio file and return markdown content."""
    content = filepath.read_text(encoding="utf-8", errors="replace")

    try:
        tree = ET.fromstring(content)
    except ET.ParseError:
        return f"# {filepath.stem}\n\n*Could not parse XML*\n"

    pages = []
    diagrams = tree.findall("diagram") if tree.tag == "mxfile" else []

    if not diagrams:
        # Might be a bare mxGraphModel
        labels = extract_labels_from_xml(content)
        if labels:
            pages.append(("Diagram", labels))
    else:
        for diagram in diagrams:
            page_name = diagram.get("name", "Untitled")
            inner_text = (diagram.text or "").strip()
            labels = []

            if inner_text:
                # Compressed content
                try:
                    xml_str = decompress_diagram(inner_text)
                    labels = extract_labels_from_xml(xml_str)
                except Exception:
                    labels = []

            # Check for inline mxGraphModel child
            graph_model = diagram.find("mxGraphModel")
            if graph_model is not None:
                xml_bytes = ET.tostring(graph_model, encoding="unicode")
                labels.extend(extract_labels_from_xml(xml_bytes))

            pages.append((page_name, labels))

    # Build markdown
    lines = [f"# {filepath.stem}", ""]
    lines.append(f"*Extracted text labels from `{filepath.name}`*")
    lines.append("")

    for page_name, labels in pages:
        if len(pages) > 1:
            lines.append(f"## {page_name}")
            lines.append("")

        if labels:
            for label in labels:
                # Multi-line labels: indent continuation lines
                label_lines = label.split("\n")
                lines.append(f"- {label_lines[0]}")
                for cont in label_lines[1:]:
                    if cont.strip():
                        lines.append(f"  {cont}")
        else:
            lines.append("*(no text labels extracted)*")

        lines.append("")

    return "\n".join(lines)


def main():
    if len(sys.argv) < 2:
        print("Usage: extract-drawio-text.py <file.drawio> [file2.drawio ...]")
        sys.exit(1)

    for arg in sys.argv[1:]:
        filepath = Path(arg)
        if not filepath.exists():
            print(f"SKIP: {filepath} does not exist", file=sys.stderr)
            continue

        md_content = process_drawio(filepath)
        out_path = filepath.with_suffix(".drawio.md")
        out_path.write_text(md_content, encoding="utf-8")
        print(f"OK: {out_path}")


if __name__ == "__main__":
    main()
