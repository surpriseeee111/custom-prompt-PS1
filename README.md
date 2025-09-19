# Custom Prompt PS1 - Advanced Terminal Prompt 🚀

A highly customizable, feature-rich terminal prompt for Bash that transforms your command-line experience. Get git status, virtual environments, exit codes, and beautiful themes all in a dynamic two-line prompt.

![Bash](https://img.shields.io/badge/bash-v3.2+-green.svg)
![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey.svg)

## ✨ Features

- **Two-Line Design**: Clean separation between info and input
- **Git Integration**: Shows branch, file counts for staged/modified/untracked
- **Virtual Environment Detection**: Python, Node.js, Ruby, Docker support
- **8 Beautiful Themes**: From minimalist to vibrant color schemes
- **Dynamic Line Width**: Auto-adjusts to terminal size
- **Exit Code Display**: Visual feedback for command failures
- **Customizable Elements**: Toggle any component on/off
- **Path Truncation**: Smart handling of long directory paths
- **Cross-Platform**: Works on macOS and all major Linux distributions
- **CLI Tool**: Manage everything with simple commands

## 🎨 Preview

```
┌─(venv)─(14:30:25)─(git branch: main | ↑2 ±1 ?3)──────(~/projects/my-app)──
└─(username@hostname)$ 
```

## 🚀 Quick Start

### One-Line Installation

```bash
# Clone and install
git clone https://github.com/TheDevOpsBlueprint/custom-prompt-PS1.git && cd custom-prompt-PS1 && ./install.sh
```

### Detailed Installation

#### macOS

```bash
# Install git if needed
xcode-select --install

# Clone the repository
git clone https://github.com/TheDevOpsBlueprint/custom-prompt-PS1.git
cd custom-prompt-PS1

# Run installer
./install.sh

# Reload your terminal
source ~/.bash_profile
```

#### Linux (Ubuntu/Debian)

```bash
# Install git
sudo apt update
sudo apt install git

# Clone the repository
git clone https://github.com/TheDevOpsBlueprint/custom-prompt-PS1.git
cd custom-prompt-PS1

# Run installer
./install.sh

# Reload your terminal
source ~/.bashrc
```

#### Linux (Fedora/RHEL/CentOS)

```bash
# Install git
sudo dnf install git  # or yum on older systems

# Clone the repository
git clone https://github.com/TheDevOpsBlueprint/custom-prompt-PS1.git
cd custom-prompt-PS1

# Run installer
./install.sh

# Reload your terminal
source ~/.bashrc
```

#### Arch Linux

```bash
# Install git
sudo pacman -S git

# Clone and install (same as Ubuntu)
git clone https://github.com/TheDevOpsBlueprint/custom-prompt-PS1.git
cd custom-prompt-PS1
./install.sh
source ~/.bashrc
```

## 📖 Usage Guide

### Basic Commands

After installation, your prompt is automatically enabled. Use these commands to customize it:

#### Theme Management

```bash
# List all available themes
prompt-cli theme list

# Set a theme
prompt-cli theme set ocean    # Blue/cyan theme
prompt-cli theme set forest   # Green nature theme (default)
prompt-cli theme set dracula  # Purple dark theme
prompt-cli theme set minimal  # Monochrome
prompt-cli theme set sunset   # Warm red/yellow
prompt-cli theme set matrix   # All green
prompt-cli theme set nord     # Nordic blue

# Preview a theme without applying
prompt-cli theme preview ocean

# Show current theme
prompt-cli theme show
```

#### Configuration

```bash
# View all settings
prompt-cli config list

# Toggle components on/off
prompt-cli config set SHOW_TIME true       # Show time
prompt-cli config set SHOW_GIT false       # Hide git info
prompt-cli config set SHOW_VIRTUALENV true # Show virtual environments
prompt-cli config set SHOW_EXIT_CODE true  # Show exit codes

# Change path display
prompt-cli config set PATH_STYLE full      # Full path
prompt-cli config set PATH_STYLE basename  # Just current folder
prompt-cli config set PATH_STYLE short     # Abbreviated path

# View specific setting
prompt-cli config get SHOW_TIME

# Reset to defaults
prompt-cli config reset
```

#### Prompt Control

```bash
# Check status
prompt-cli status

# Temporarily disable custom prompt
prompt-cli disable

# Re-enable custom prompt
prompt-cli enable

# Reload configuration
prompt-cli reload
```

### Direct Function Commands

For instant changes without CLI:

```bash
# Change theme immediately
load_theme_colors ocean && set_config THEME ocean

# Toggle features
set_config SHOW_TIME true
set_config SHOW_GIT false

# Reload prompt
reload_prompt

# Show prompt info
prompt_info
```

## 🎨 Available Themes

| Theme | Description | Best For |
|-------|-------------|----------|
| **forest** | Green nature theme (default) | Dark terminals |
| **ocean** | Blue/cyan maritime colors | Light backgrounds |
| **classic** | Traditional terminal colors | Standard look |
| **minimal** | Monochrome/simple | Distraction-free |
| **dracula** | Purple dark theme | Dark mode lovers |
| **sunset** | Warm red/yellow tones | Vibrant displays |
| **matrix** | All green theme | Hacker aesthetic |
| **nord** | Nordic blue palette | Modern IDEs |

## ⚙️ Configuration Options

| Option | Values | Description |
|--------|--------|-------------|
| `SHOW_GIT` | true/false | Display git branch and status |
| `SHOW_USER` | true/false | Display username |
| `SHOW_HOST` | true/false | Display hostname |
| `SHOW_PATH` | true/false | Display current directory |
| `SHOW_TIME` | true/false | Display current time |
| `SHOW_EXIT_CODE` | true/false | Display exit code on error |
| `SHOW_VIRTUALENV` | true/false | Display virtual environments |
| `GIT_SHOW_STATUS` | true/false | Display git file counts |
| `PATH_STYLE` | full/short/basename | Path display format |
| `THEME` | theme name | Color theme to use |

## 📁 File Locations

```
~/.custom-prompt/          # Installation directory
├── *.sh                   # Prompt components
└── cli/                   # CLI tool

~/.config/custom-prompt/
└── config                 # User configuration

~/.local/bin/
└── prompt-cli            # CLI command symlink
```

## 🔧 Advanced Usage

### Custom Configurations

#### Minimal Setup
```bash
# Just essentials
prompt-cli config set SHOW_USER false
prompt-cli config set SHOW_HOST false
prompt-cli config set SHOW_TIME false
prompt-cli theme set minimal
```

#### Full Information Display
```bash
# Everything enabled
prompt-cli config set SHOW_TIME true
prompt-cli config set SHOW_VIRTUALENV true
prompt-cli config set SHOW_EXIT_CODE true
prompt-cli config set GIT_SHOW_STATUS true
prompt-cli theme set ocean
```

#### Server/Production Setup
```bash
# Focus on important info
prompt-cli config set SHOW_USER true
prompt-cli config set SHOW_HOST true
prompt-cli config set SHOW_TIME true
prompt-cli config set SHOW_GIT false
prompt-cli theme set classic
```

### Shell Aliases

Add to your `~/.bashrc` or `~/.bash_profile`:

```bash
# Quick theme switching
alias theme-ocean='load_theme_colors ocean && set_config THEME ocean'
alias theme-forest='load_theme_colors forest && set_config THEME forest'
alias theme-minimal='load_theme_colors minimal && set_config THEME minimal'

# Quick toggles
alias prompt-time='set_config SHOW_TIME true'
alias prompt-notime='set_config SHOW_TIME false'
alias prompt-git='set_config SHOW_GIT true'
alias prompt-nogit='set_config SHOW_GIT false'
```

## 🔍 Prompt Components Explained

```
┌─(venv)─(14:30:25)─(git branch: main | ↑2 ±1 ?3)──────(~/projects)──
└─(user@host)$ 

Components:
• (venv)         - Virtual environment name
• (14:30:25)     - Current time (HH:MM:SS)
• (git branch: main) - Current git branch
• ↑2             - 2 files staged for commit
• ±1             - 1 file modified
• ?3             - 3 untracked files
• ~/projects     - Current directory
• user@host      - Username and hostname
• $              - Prompt symbol (# for root)
```

## 🧪 Testing

```bash
# Run comprehensive test suite
cd custom-prompt-PS1
./tests/test_everything.sh

# Test specific components
./tests/test_prompt.sh
./tests/test_cli.sh
```

## 🐛 Troubleshooting

### Common Issues

**Prompt not showing after installation**
```bash
# Reload your shell configuration
source ~/.bash_profile  # macOS
source ~/.bashrc        # Linux

# Or open a new terminal window
```

**Command `prompt-cli` not found**
```bash
# Add to PATH manually
export PATH="$PATH:$HOME/.local/bin"

# Or use full path
~/.local/bin/prompt-cli theme list
```

**Colors not displaying correctly**
```bash
# Check terminal supports colors
tput colors  # Should output 256 or higher

# Set terminal type
export TERM=xterm-256color
```

**Theme changes not applying**
```bash
# After changing theme, press Enter or run any command
# The new theme applies to the next prompt line

# Or reload prompt
reload_prompt
```

**Git information not showing**
```bash
# Ensure you're in a git repository
git status

# Check git detection is enabled
prompt-cli config get SHOW_GIT
```

### macOS Specific

**Using with iTerm2**
- Go to Preferences → Profiles → Terminal
- Set "Report Terminal Type" to `xterm-256color`

**Using with Terminal.app**
- Preferences → Profiles → Advanced
- Ensure "Set locale environment variables on startup" is checked

### Linux Specific

**Using with GNOME Terminal**
- Edit → Preferences → Profiles
- Ensure color palette is set to "Tango" or "Custom"

**Using with Konsole**
- Settings → Edit Current Profile → Appearance
- Choose a color scheme that supports 256 colors

## 💻 Uninstallation

```bash
# Using CLI tool
prompt-cli uninstall

# Or manually
rm -rf ~/.custom-prompt
rm -f ~/.local/bin/prompt-cli

# Remove from shell config
# Edit ~/.bashrc or ~/.bash_profile and remove the Custom Prompt PS1 section
```

## 🤝 Contributing

We follow a small PR approach (max 80 lines per PR):

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/amazing-feature`)
3. Make small, focused changes
4. Test your changes
5. Commit (`git commit -m 'feat: add amazing feature'`)
6. Push (`git push origin feat/amazing-feature`)
7. Create Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## 📝 Examples

### Daily Development Workflow

```bash
# Morning setup
prompt-cli theme set forest
prompt-cli config set SHOW_TIME true

# Working on a project (shows git info)
cd ~/projects/my-app
git checkout -b feature/new-feature
# Prompt shows: (git branch: feature/new-feature)

# Python development (shows virtual env)
python -m venv venv
source venv/bin/activate
# Prompt shows: (venv) at the beginning

# After making changes
git add .
# Prompt shows: (git branch: feature/new-feature | ↑5)

# Command fails
false
# Prompt shows: (Err 1) on next line
```

### Server Administration

```bash
# SSH to server - see hostname clearly
prompt-cli config set SHOW_HOST true
prompt-cli config set SHOW_USER true
prompt-cli theme set minimal

# Working as root - prompt shows # instead of $
sudo su
# Prompt symbol changes to #
```

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🙏 Credits

Built with Bash and love by The DevOps Blueprint team.

Special thanks to:
- Git for version control integration
- The Bash community for shell scripting resources
- All contributors and users

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/TheDevOpsBlueprint/custom-prompt-PS1/issues)
- **Discussions**: [GitHub Discussions](https://github.com/TheDevOpsBlueprint/custom-prompt-PS1/discussions)

---

**Made with 💚 by [The DevOps Blueprint](https://github.com/TheDevOpsBlueprint)**

*Transform your terminal, transform your workflow*