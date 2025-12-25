# Rule Engine Rule Configuration
domain_name   = "example.com"
rule_name     = "test-rule-engine"
rule_status   = "on"
rule_priority = 1
# Conditions in JSON format (as a string)
# You need to provide the JSON string directly, or use heredoc syntax for multi-line strings.
conditions    = <<-JSON
{
  "match": {
    "logic": "and",
    "criteria": [
      {
        "match_target_type": "path",
        "match_type": "contains",
        "match_pattern": ["/api/"],
        "negate": false,
        "case_sensitive": true
      }
    ]
  }
}
JSON
