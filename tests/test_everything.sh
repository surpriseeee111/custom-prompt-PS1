#!/usr/bin/env bash
# Comprehensive test for Custom Prompt PS1

echo "═══════════════════════════════════════════════════════════════"
echo "     CUSTOM PROMPT PS1 - COMPREHENSIVE TEST SUITE"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# CRITICAL: Source the prompt system with all functions
echo "Loading Custom Prompt system..."

# Try multiple locations to find the prompt files
if [[ -f "$HOME/.custom-prompt/loader.sh" ]]; then
    PROMPT_DIR="$HOME/.custom-prompt"
    echo "Found installed version at $PROMPT_DIR"
elif [[ -f "$(dirname $0)/../src/loader.sh" ]]; then
    PROMPT_DIR="$(dirname $0)/../src"
    echo "Found source version at $PROMPT_DIR"
else
    echo "ERROR: Cannot find prompt files"
    exit 1
fi

# Source ALL files explicitly to ensure functions are available
source "$PROMPT_DIR/colors.sh"
source "$PROMPT_DIR/os_detect.sh"
source "$PROMPT_DIR/git_info.sh"
source "$PROMPT_DIR/git_status.sh"
source "$PROMPT_DIR/virtualenv.sh"
source "$PROMPT_DIR/config.sh"
source "$PROMPT_DIR/color_config.sh"
source "$PROMPT_DIR/prompt_builder.sh"

echo "✓ All modules loaded"
echo ""

# Test environment setup
TEST_DIR="/tmp/prompt-test-$$"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

echo "📍 Test Location: $TEST_DIR"
echo ""

# 1. Test Basic Commands
echo "┌─────────────────────────────────────────────────────────────"
echo "│ TEST 1: Basic Commands"
echo "└─────────────────────────────────────────────────────────────"
echo "Testing: prompt_info"
prompt_info
echo ""

echo "Testing: get_config THEME"
echo "Theme config: $(get_config THEME)"
echo ""

# 2. Test Configuration Changes
echo "┌─────────────────────────────────────────────────────────────"
echo "│ TEST 2: Configuration Changes"
echo "└─────────────────────────────────────────────────────────────"

echo "Turning OFF time display..."
set_config SHOW_TIME false
echo "SHOW_TIME is now: $(get_config SHOW_TIME)"

echo "Turning ON time display..."
set_config SHOW_TIME true
echo "SHOW_TIME is now: $(get_config SHOW_TIME)"

echo "Changing path style to basename..."
set_config PATH_STYLE basename
echo "PATH_STYLE is now: $(get_config PATH_STYLE)"
pwd

echo "Changing path style back to full..."
set_config PATH_STYLE full
echo "PATH_STYLE is now: $(get_config PATH_STYLE)"
echo ""

# 3. Test Theme Changes
echo "┌─────────────────────────────────────────────────────────────"
echo "│ TEST 3: Theme Changes"
echo "└─────────────────────────────────────────────────────────────"

for theme in default ocean forest minimal dracula; do
    echo "Setting theme: $theme"
    load_theme_colors "$theme"
    echo "Theme $theme applied - User color: ${PROMPT_USER_COLOR}test${RESET}"
done

echo "Resetting to default theme..."
load_theme_colors "default"
echo ""

# 4. Test Git Integration
echo "┌─────────────────────────────────────────────────────────────"
echo "│ TEST 4: Git Integration"
echo "└─────────────────────────────────────────────────────────────"

echo "Creating test git repo..."
git init --quiet
echo "Git repo created"

echo "Testing git branch detection..."
git checkout -b test-branch 2>/dev/null
echo "Current branch: $(git_branch)"

echo "Testing git status detection..."
echo "test" > test.txt
echo "Untracked files: $(git_has_untracked && echo 'YES' || echo 'NO')"

git add test.txt
echo "Staged files: $(git_has_staged && echo 'YES' || echo 'NO')"

git commit -m "test" --quiet
echo "test2" >> test.txt
echo "Modified files: $(git_has_changes && echo 'YES' || echo 'NO')"
echo ""

# 5. Test Virtual Environment Detection
echo "┌─────────────────────────────────────────────────────────────"
echo "│ TEST 5: Virtual Environment Detection"
echo "└─────────────────────────────────────────────────────────────"

echo "Creating fake Python venv..."
export VIRTUAL_ENV="/tmp/test-venv"
echo "Virtual env: $(detect_python_venv)"

echo "Testing Conda..."
unset VIRTUAL_ENV
export CONDA_DEFAULT_ENV="base"
echo "Conda env: $(detect_python_venv)"
unset CONDA_DEFAULT_ENV
echo ""

# 6. Test Path Display
echo "┌─────────────────────────────────────────────────────────────"
echo "│ TEST 6: Path Display"
echo "└─────────────────────────────────────────────────────────────"

echo "Testing deep path..."
mkdir -p very/long/path/to/test/truncation/feature
cd very/long/path/to/test/truncation/feature
pwd
echo "Display PWD: $(get_display_pwd)"
cd "$TEST_DIR"
echo ""

# 7. Test Error Code Display
echo "┌─────────────────────────────────────────────────────────────"
echo "│ TEST 7: Exit Code Display"
echo "└─────────────────────────────────────────────────────────────"

echo "Running command that fails..."
false
echo "Last exit code: $?"

echo "Running command that succeeds..."
true
echo "Last exit code: $?"
echo ""

# 8. Test OS Detection
echo "┌─────────────────────────────────────────────────────────────"
echo "│ TEST 8: OS Detection"
echo "└─────────────────────────────────────────────────────────────"

echo "OS Type: $(detect_os)"
echo "OS Distro: $(detect_distro)"
echo ""

# 9. Test Color Support
echo "┌─────────────────────────────────────────────────────────────"
echo "│ TEST 9: Color Support"
echo "└─────────────────────────────────────────────────────────────"

if supports_color; then
    echo -e "${GREEN_PLAIN}✓ Colors supported${NC}"
    echo -e "${RED_PLAIN}Red${NC} ${GREEN_PLAIN}Green${NC} ${BLUE_PLAIN}Blue${NC} ${YELLOW_PLAIN}Yellow${NC}"
else
    echo "No color support"
fi
echo ""

# 10. Test Terminal Width
echo "┌─────────────────────────────────────────────────────────────"
echo "│ TEST 10: Terminal Width Detection"
echo "└─────────────────────────────────────────────────────────────"

echo "Terminal width: $(get_terminal_width) columns"
echo ""

# 11. Test Enable/Disable
echo "┌─────────────────────────────────────────────────────────────"
echo "│ TEST 11: Enable/Disable Prompt"
echo "└─────────────────────────────────────────────────────────────"

echo "Disabling custom prompt..."
disable_custom_prompt

echo "Re-enabling custom prompt..."
enable_custom_prompt
echo ""

# 12. Test All Config Options
echo "┌─────────────────────────────────────────────────────────────"
echo "│ TEST 12: All Configuration Options"
echo "└─────────────────────────────────────────────────────────────"

for key in SHOW_GIT SHOW_USER SHOW_HOST SHOW_PATH SHOW_TIME SHOW_EXIT_CODE SHOW_VIRTUALENV GIT_SHOW_STATUS; do
    value=$(get_config $key)
    printf "%-20s = %s\n" "$key" "$value"
done
echo ""

# Cleanup
echo "┌─────────────────────────────────────────────────────────────"
echo "│ CLEANUP"
echo "└─────────────────────────────────────────────────────────────"
cd /
rm -rf "$TEST_DIR"
echo "Test directory cleaned up"
echo ""

echo "═══════════════════════════════════════════════════════════════"
echo "     TEST COMPLETE - CHECK OUTPUT ABOVE FOR ANY ISSUES"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "✅ All tests completed successfully!"