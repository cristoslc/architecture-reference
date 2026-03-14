"""Tests for constraint baseline schema validation."""

import json
import subprocess
import sys
from pathlib import Path

import pytest
import yaml

REPO_ROOT = Path(__file__).parent.parent
SCHEMA_PATH = REPO_ROOT / "skills/architecture-advisor/references/constraint-baseline.schema.json"
VALID_FIXTURE = REPO_ROOT / "tests/fixtures/baselines/layered-example.yaml"
INVALID_FIXTURE = REPO_ROOT / "tests/fixtures/baselines/invalid-missing-fields.yaml"
VALIDATE_SCRIPT = REPO_ROOT / "scripts/validate-baseline.py"


@pytest.fixture
def schema():
    return json.loads(SCHEMA_PATH.read_text())


@pytest.fixture
def valid_baseline():
    return yaml.safe_load(VALID_FIXTURE.read_text())


@pytest.fixture
def invalid_baseline():
    return yaml.safe_load(INVALID_FIXTURE.read_text())


class TestSchemaStructure:
    """Verify the JSON Schema itself is well-formed."""

    def test_schema_is_valid_json_schema(self, schema):
        from jsonschema import Draft202012Validator
        Draft202012Validator.check_schema(schema)

    def test_schema_requires_all_top_level_fields(self, schema):
        assert set(schema["required"]) == {
            "style", "style_slug", "schema_version",
            "structural_rules", "statistical_norms", "co_occurrence",
        }


class TestValidBaseline:
    """AC1: Valid baseline files pass validation."""

    def test_valid_fixture_passes(self, schema, valid_baseline):
        from jsonschema import validate
        validate(instance=valid_baseline, schema=schema)


class TestStructuralRules:
    """AC3: Each rule has description, severity, signal_type."""

    def test_rule_requires_description(self, schema, valid_baseline):
        from jsonschema import validate, ValidationError
        broken = valid_baseline.copy()
        broken["structural_rules"] = [{"id": "x-001", "severity": "violation", "signal_type": "module_boundary"}]
        with pytest.raises(ValidationError, match="description"):
            validate(instance=broken, schema=schema)

    def test_rule_requires_severity(self, schema, valid_baseline):
        from jsonschema import validate, ValidationError
        broken = valid_baseline.copy()
        broken["structural_rules"] = [{"id": "x-001", "description": "test", "signal_type": "module_boundary"}]
        with pytest.raises(ValidationError, match="severity"):
            validate(instance=broken, schema=schema)

    def test_severity_enum(self, schema, valid_baseline):
        from jsonschema import validate, ValidationError
        broken = valid_baseline.copy()
        broken["structural_rules"] = [{"id": "x-001", "description": "t", "severity": "critical", "signal_type": "module_boundary"}]
        with pytest.raises(ValidationError):
            validate(instance=broken, schema=schema)

    def test_signal_type_enum(self, schema, valid_baseline):
        from jsonschema import validate, ValidationError
        broken = valid_baseline.copy()
        broken["structural_rules"] = [{"id": "x-001", "description": "t", "severity": "violation", "signal_type": "invalid_signal"}]
        with pytest.raises(ValidationError):
            validate(instance=broken, schema=schema)


class TestStatisticalNorms:
    """AC4: Each norm has metric, central_tendency, spread, sample_size, anomaly_threshold."""

    def test_norm_requires_metric(self, schema, valid_baseline):
        from jsonschema import validate, ValidationError
        broken = valid_baseline.copy()
        broken["statistical_norms"] = [{
            "central_tendency": {"median": 3},
            "spread": {"p25": 2, "p75": 4},
            "sample_size": 78,
            "anomaly_threshold": {"high": 8},
            "confidence": "high",
        }]
        with pytest.raises(ValidationError, match="metric"):
            validate(instance=broken, schema=schema)

    def test_norm_requires_at_least_median_or_mode(self, schema, valid_baseline):
        from jsonschema import validate, ValidationError
        broken = valid_baseline.copy()
        broken["statistical_norms"] = [{
            "metric": "layer_count",
            "central_tendency": {},
            "spread": {},
            "sample_size": 78,
            "anomaly_threshold": {},
            "confidence": "high",
        }]
        with pytest.raises(ValidationError):
            validate(instance=broken, schema=schema)

    def test_confidence_enum(self, schema, valid_baseline):
        from jsonschema import validate, ValidationError
        broken = valid_baseline.copy()
        broken["statistical_norms"] = [{
            "metric": "layer_count",
            "central_tendency": {"median": 3},
            "spread": {},
            "sample_size": 2,
            "anomaly_threshold": {},
            "confidence": "very_high",
        }]
        with pytest.raises(ValidationError):
            validate(instance=broken, schema=schema)


class TestCoOccurrence:
    """Co-occurrence entries have required fields."""

    def test_common_requires_frequency_and_sample(self, schema, valid_baseline):
        from jsonschema import validate, ValidationError
        broken = valid_baseline.copy()
        broken["co_occurrence"] = {"common": [{"style": "Microkernel"}], "unusual": []}
        with pytest.raises(ValidationError):
            validate(instance=broken, schema=schema)


class TestStyleAgnostic:
    """AC2/AC5: Schema works for any style without extensions."""

    STYLES = [
        ("Layered", "layered"),
        ("Modular Monolith", "modular-monolith"),
        ("Pipeline", "pipeline"),
        ("Microkernel", "microkernel"),
        ("Service-Based", "service-based"),
        ("Event-Driven", "event-driven"),
        ("Space-Based", "space-based"),
        ("Microservices", "microservices"),
        ("Serverless", "serverless"),
        ("Multi-Agent", "multi-agent"),
    ]

    @pytest.mark.parametrize("style_name,style_slug", STYLES)
    def test_minimal_baseline_valid_for_each_style(self, schema, style_name, style_slug):
        from jsonschema import validate
        baseline = {
            "style": style_name,
            "style_slug": style_slug,
            "schema_version": "1.0.0",
            "structural_rules": [{
                "id": f"{style_slug}-001",
                "description": f"Example rule for {style_name}",
                "severity": "violation",
                "signal_type": "module_boundary",
            }],
            "statistical_norms": [],
            "co_occurrence": {"common": [], "unusual": []},
        }
        validate(instance=baseline, schema=schema)


class TestInvalidBaseline:
    """AC1 (negative): Invalid baselines are rejected."""

    def test_invalid_fixture_rejected(self, schema, invalid_baseline):
        from jsonschema import validate, ValidationError
        with pytest.raises(ValidationError):
            validate(instance=invalid_baseline, schema=schema)

    def test_extra_fields_rejected(self, schema, valid_baseline):
        from jsonschema import validate, ValidationError
        broken = valid_baseline.copy()
        broken["unexpected_field"] = "surprise"
        with pytest.raises(ValidationError, match="unexpected_field"):
            validate(instance=broken, schema=schema)


class TestValidateScript:
    """Validate the CLI script works end-to-end."""

    def test_valid_file_exits_zero(self):
        result = subprocess.run(
            [sys.executable, str(VALIDATE_SCRIPT), str(VALID_FIXTURE)],
            capture_output=True, text=True,
        )
        assert result.returncode == 0

    def test_invalid_file_exits_nonzero(self):
        result = subprocess.run(
            [sys.executable, str(VALIDATE_SCRIPT), str(INVALID_FIXTURE)],
            capture_output=True, text=True,
        )
        assert result.returncode == 1
