#!/usr/bin/env bash
# OS Detection and platform-specific settings

# Function to detect operating system
function detect_os() {
    local os_type="Unknown"

    case "$(uname -s)" in
        Linux*)
            os_type="Linux"
            ;;
        Darwin*)
            os_type="Mac"
            ;;
        CYGWIN*|MINGW*|MSYS*)
            os_type="Windows"
            ;;
        FreeBSD*)
            os_type="FreeBSD"
            ;;
        *)
            os_type="Unknown"
            ;;
    esac

    echo "$os_type"
}

# Function to detect Linux distribution
function detect_distro() {
    local distro="Unknown"

    if [[ "$OS_TYPE" == "Linux" ]]; then
        if [[ -f /etc/os-release ]]; then
            source /etc/os-release
            distro="$NAME"
        elif [[ -f /etc/debian_version ]]; then
            distro="Debian"
        elif [[ -f /etc/redhat-release ]]; then
            distro="RedHat"
        fi
    fi

    echo "$distro"
}

# Export detected OS
export OS_TYPE=$(detect_os)
export OS_DISTRO=$(detect_distro)

# Platform-specific settings
if [[ "$OS_TYPE" == "Mac" ]]; then
    export DATE_CMD="gdate"
else
    export DATE_CMD="date"
fi