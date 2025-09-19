#!/usr/bin/env bash
# Test suite for Custom Prompt PS1

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
    echo "  Expected: $2"
    echo "  Got: $3"
    ((TESTS_FAILED++))
}

# Source the prompt files
echo "Loading prompt components..."
source ../src/colors.sh
source ../src/os_detect.sh
source ../src/git_info.sh
source ../src/git_status.sh
source ../src/virtualenv.sh
source ../src/config.sh
source ../src/color_config.sh

# Test OS Detection
echo -e "\n${YELLOW}Testing OS Detection...${NC}"
OS_RESULT=$(detect_os)
if [[ "$OS_RESULT" == "Linux" ]] || [[ "$OS_RESULT" == "Mac" ]]; then
    pass "OS detection works: $OS_RESULT"
else
    fail "OS detection" "Linux or Mac" "$OS_RESULT"
fi

# Test Color Support
echo -e "\n${YELLOW}Testing Color Support...${NC}"
if supports_color; then
    pass "Terminal supports colors"
    if [[ -n "$RED" ]] && [[ -n "$GREEN" ]]; then
        pass "Color variables loaded"
    else
        fail "Color variables" "Non-empty" "Empty"
    fi
else
    pass "Color support detection works (no colors)"
fi

# Test Git Detection
echo -e "\n${YELLOW}Testing Git Functions...${NC}"
cd /tmp
mkdir -p test-git-repo
cd test-git-repo
git init --quiet

if is_git_repo; then
    pass "Git repository detection works"
else
    fail "Git repository detection" "true" "false"
fi

git checkout -b test-branch --quiet 2>/dev/null
BRANCH=$(git_branch)
if [[ "$BRANCH" == "test-branch" ]]; then
    pass "Git branch detection works"
else
    fail "Git branch detection" "test-branch" "$BRANCH"
fi

# Test configuration
echo -e "\n${YELLOW}Testing Configuration...${NC}"
export PROMPT_CONFIG_DIR="/tmp/test-config"
export PROMPT_CONFIG_FILE="$PROMPT_CONFIG_DIR/config"
init_config >/dev/null 2>&1

if [[ -f "$PROMPT_CONFIG_FILE" ]]; then
    pass "Config file created"
else
    fail "Config file creation" "File exists" "File not found"
fi

set_config TEST_KEY test_value
TEST_VAL=$(get_config TEST_KEY)
if [[ "$TEST_VAL" == "test_value" ]]; then
    pass "Config get/set works"
else
    fail "Config get/set" "test_value" "$TEST_VAL"
fi

# Test theme loading
echo -e "\n${YELLOW}Testing Themes...${NC}"
load_theme_colors "ocean"
if [[ -n "$PROMPT_USER_COLOR" ]]; then
    pass "Theme loading works"
else
    fail "Theme loading" "Non-empty color" "Empty"
fi

# Test virtualenv detection
echo -e "\n${YELLOW}Testing Virtual Environment Detection...${NC}"
export VIRTUAL_ENV="/tmp/test-venv"
VENV_RESULT=$(detect_python_venv)
if [[ "$VENV_RESULT" == "(test-venv)" ]]; then
    pass "Python virtualenv detection works"
else
    fail "Virtualenv detection" "(test-venv)" "$VENV_RESULT"
fi
unset VIRTUAL_ENV

# Cleanup
cd /
rm -rf /tmp/test-git-repo
rm -rf /tmp/test-config

# Summary
echo -e "\n${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Test Results:"
echo -e "  ${GREEN}Passed: $TESTS_PASSED${NC}"
echo -e "  ${RED}Failed: $TESTS_FAILED${NC}"

if [[ $TESTS_FAILED -eq 0 ]]; then
    echo -e "\n${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "\n${RED}Some tests failed.${NC}"
    exit 1
fi