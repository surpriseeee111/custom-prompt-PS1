#!/usr/bin/env bash
# Test suite for CLI commands

# Colors for test output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# Test result functions
pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((TESTS_PASSED++))
}

fail() {
    echo -e "${RED}✗${NC} $1"
    echo "  Error: $2"
    ((TESTS_FAILED++))
}

# Test CLI exists
echo -e "${YELLOW}Testing CLI Tool...${NC}"

CLI_PATH="../cli/prompt-cli"

if [[ -f "$CLI_PATH" ]]; then
    pass "CLI tool exists"
else
    fail "CLI tool not found" "$CLI_PATH"
    exit 1
fi

if [[ -x "$CLI_PATH" ]]; then
    pass "CLI tool is executable"
else
    fail "CLI tool is not executable" "$CLI_PATH"
fi

# Test CLI commands
echo -e "\n${YELLOW}Testing CLI Commands...${NC}"

# Test help
OUTPUT=$($CLI_PATH help 2>&1)
if [[ $? -eq 0 ]] && [[ "$OUTPUT" =~ "Custom Prompt CLI" ]]; then
    pass "CLI help command works"
else
    fail "CLI help command" "Exit code non-zero or missing output"
fi

# Test version
OUTPUT=$($CLI_PATH version 2>&1)
if [[ $? -eq 0 ]] && [[ "$OUTPUT" =~ "1.0.0" ]]; then
    pass "CLI version command works"
else
    fail "CLI version command" "Missing version number"
fi

# Test theme commands exist
if [[ -f "../cli/commands/theme.sh" ]]; then
    pass "Theme command module exists"
else
    fail "Theme command module" "File not found"
fi

if [[ -f "../cli/commands/config.sh" ]]; then
    pass "Config command module exists"
else
    fail "Config command module" "File not found"
fi

# Summary
echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "CLI Test Results:"
echo -e "  ${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "  ${RED}Failed: $TESTS_FAILED${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "\n${GREEN}All CLI tests passed!${NC}"
    exit 0
else
    echo -e "\n${RED}Some CLI tests failed.${NC}"
    exit 1
fi