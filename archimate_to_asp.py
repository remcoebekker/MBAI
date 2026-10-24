#!/usr/bin/env python3
"""Transform an ArchiMate Model Exchange XML export into ASP facts.

Compatible with Python 3.11 and the ArchiMate Model Exchange File Format
for the ArchiMate 3.1/3.2 modelling language.

Generated predicates:
    element(ID, Type).
    name(ID, Name).
    relationship(ID, Source, Target, Type).
    relationshipAttribute(ID, AttributeType, Value).

The four core relationship attributes are identifier, source, target, and
xsi:type. Every other XML attribute on a relationship is emitted as a
separate relationshipAttribute/3 fact.
"""

from __future__ import annotations

import argparse
import sys
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

XSI_NAMESPACE = "http://www.w3.org/2001/XMLSchema-instance"
XSI_TYPE = f"{{{XSI_NAMESPACE}}}type"
CORE_RELATIONSHIP_ATTRIBUTES = frozenset(
    {"identifier", "source", "target", "type"}
)


@dataclass(frozen=True)
class ConversionStatistics:
    elements: int = 0
    names: int = 0
    relationships: int = 0
    relationship_attributes: int = 0


def local_name(qualified_name: str) -> str:
    """Return the local name from an XML namespace-qualified name."""
    return qualified_name.rsplit("}", maxsplit=1)[-1]


def asp_string(value: str) -> str:
    """Encode a value as an escaped ASP string constant."""
    escaped = (
        value.replace("\\", "\\\\")
        .replace('"', '\\"')
        .replace("\n", "\\n")
        .replace("\r", "\\r")
        .replace("\t", "\\t")
    )
    return f'"{escaped}"'


def normalise_text(xml_element: ET.Element) -> str:
    """Return the element text with XML whitespace normalised."""
    return " ".join("".join(xml_element.itertext()).split())


def get_attribute(xml_element: ET.Element, attribute_name: str) -> str | None:
    """Get an XML attribute by local name, independent of its namespace."""
    for qualified_name, value in xml_element.attrib.items():
        if local_name(qualified_name) == attribute_name:
            return value
    return None


def get_xsi_type(xml_element: ET.Element) -> str | None:
    """Get xsi:type, allowing a non-namespaced type attribute as fallback."""
    return xml_element.attrib.get(XSI_TYPE) or get_attribute(xml_element, "type")


def direct_children(
    xml_element: ET.Element, child_name: str
) -> Iterable[ET.Element]:
    """Yield direct children whose local XML name equals child_name."""
    return (
        child
        for child in xml_element
        if local_name(child.tag) == child_name
    )


def validate_required_attributes(
    xml_element: ET.Element,
    required: dict[str, str | None],
    xml_kind: str,
) -> bool:
    """Warn and return False when a required attribute is missing."""
    missing = [name for name, value in required.items() if not value]
    if not missing:
        return True

    identifier = get_attribute(xml_element, "identifier") or "<unknown>"
    print(
        f"Warning: skipped {xml_kind} {identifier}; missing: "
        + ", ".join(missing),
        file=sys.stderr,
    )
    return False


def convert_archimate_to_asp(input_path: Path, output_path: Path) -> ConversionStatistics:
    """Read an ArchiMate XML export and write the requested ASP facts."""
    try:
        root = ET.parse(input_path).getroot()
    except ET.ParseError as error:
        raise ValueError(f"The input is not valid XML: {error}") from error

    asp_lines: list[str] = [
        "% Generated from an ArchiMate Model Exchange file.",
        f"% Source: {input_path.name}",
        "",
        "% Elements",
    ]

    element_count = 0
    name_count = 0
    relationship_nodes: list[ET.Element] = []

    # Only XML nodes named 'element' become element facts. Nodes used for
    # diagrams, such as 'node' and 'connection', are intentionally ignored.
    for xml_element in root.iter():
        tag = local_name(xml_element.tag)

        if tag == "element":
            identifier = get_attribute(xml_element, "identifier")
            element_type = get_xsi_type(xml_element)
            required = {"identifier": identifier, "xsi:type": element_type}

            if not validate_required_attributes(
                xml_element, required, "element"
            ):
                continue

            asp_lines.append(
                f"element({asp_string(identifier)}, {asp_string(element_type)})."
            )
            element_count += 1

            # Multiple direct <name> children are supported.
            for name_element in direct_children(xml_element, "name"):
                name = normalise_text(name_element)
                if name:
                    asp_lines.append(
                        f"name({asp_string(identifier)}, {asp_string(name)})."
                    )
                    name_count += 1

        elif tag == "relationship":
            relationship_nodes.append(xml_element)

    asp_lines.extend(["", "% Relationships"])
    relationship_count = 0
    relationship_attribute_count = 0

    for relationship_element in relationship_nodes:
        identifier = get_attribute(relationship_element, "identifier")
        source = get_attribute(relationship_element, "source")
        target = get_attribute(relationship_element, "target")
        relationship_type = get_xsi_type(relationship_element)

        required = {
            "identifier": identifier,
            "source": source,
            "target": target,
            "xsi:type": relationship_type,
        }
        if not validate_required_attributes(
            relationship_element, required, "relationship"
        ):
            continue

        # Keep the core relationship predicate at arity 4.
        asp_lines.append(
            "relationship("
            f"{asp_string(identifier)}, "
            f"{asp_string(source)}, "
            f"{asp_string(target)}, "
            f"{asp_string(relationship_type)}"
            ")."
        )
        relationship_count += 1

        # Emit every optional relationship attribute as its own arity-3 fact.
        for qualified_name, value in relationship_element.attrib.items():
            attribute_type = local_name(qualified_name)
            if attribute_type in CORE_RELATIONSHIP_ATTRIBUTES:
                continue

            asp_lines.append(
                "relationshipAttribute("
                f"{asp_string(identifier)}, "
                f"{asp_string(attribute_type)}, "
                f"{asp_string(value)}"
                ")."
            )
            relationship_attribute_count += 1

    try:
        output_path.write_text("\n".join(asp_lines) + "\n", encoding="utf-8")
    except OSError as error:
        raise OSError(f"Could not write output file {output_path}: {error}") from error

    return ConversionStatistics(
        elements=element_count,
        names=name_count,
        relationships=relationship_count,
        relationship_attributes=relationship_attribute_count,
    )


def parse_arguments() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description=(
            "Transform an ArchiMate Model Exchange XML export into ASP facts."
        )
    )
    parser.add_argument("input", type=Path, help="Path to the ArchiMate XML export")
    parser.add_argument(
        "output",
        nargs="?",
        type=Path,
        help="Output .lp file; defaults to the input filename with suffix .lp",
    )
    return parser.parse_args()


def main() -> int:
    arguments = parse_arguments()
    input_path: Path = arguments.input
    output_path: Path = arguments.output or input_path.with_suffix(".lp")

    if not input_path.is_file():
        print(f"Error: input file does not exist: {input_path}", file=sys.stderr)
        return 2

    try:
        statistics = convert_archimate_to_asp(input_path, output_path)
    except (OSError, ValueError) as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1

    print(f"Created: {output_path}")
    print(f"element/2 facts: {statistics.elements}")
    print(f"name/2 facts: {statistics.names}")
    print(f"relationship/4 facts: {statistics.relationships}")
    print(
        "relationshipAttribute/3 facts: "
        f"{statistics.relationship_attributes}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
