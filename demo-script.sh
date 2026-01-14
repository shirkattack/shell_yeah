#!/bin/zsh
set -e  # Exit on error

# Color constants
readonly COLOR_CYAN="36"
readonly COLOR_YELLOW="33"
readonly COLOR_GREEN="32"
readonly COLOR_MAGENTA="35"
readonly COLOR_BLUE="34"
readonly COLOR_PINK="13"

# Check if required commands exist
check_dependencies() {
    local missing_deps=()

    # Universal commands
    for cmd in curl lsd df; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    # Platform-specific commands
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux requires 'free' for memory info
        if ! command -v free &> /dev/null; then
            missing_deps+=("free")
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS uses vm_stat for memory info (built-in, no check needed)
        :
    fi

    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo "Error: Missing required commands: ${missing_deps[*]}"
        echo "Please install them before running this script."
        exit 1
    fi
}

# Check dependencies before proceeding
check_dependencies

# Source zsh configuration
if [[ -f ~/.zshrc ]]; then
    source ~/.zshrc
else
    echo "Warning: ~/.zshrc not found, some functions may not be available"
fi

# Function to add some delay between commands for better readability
function demo_delay() {
    sleep 1.5
}

# Function to print colorful text
print_color() {
    local color=$1
    local text=$2
    echo -e "\e[${color}m${text}\e[0m"
}

# Clear the screen and show welcome message
clear
print_color "$COLOR_CYAN" "🚀 Shell yeah! Let's explore our terminal! 🚀"
demo_delay

# Show ASCII art
print_color "$COLOR_YELLOW" "\n🎨 Check out this cool ASCII art:"
if command -v show_ascii_art &> /dev/null; then
    show_ascii_art
else
    echo "ASCII art function not available"
fi
demo_delay

# Weather information
print_color "$COLOR_YELLOW" "\n📅 Let's check the weather:"
curl "https://v2.wttr.in/83263"
demo_delay

# IP information
print_color "$COLOR_GREEN" "\n🌐 Your current IP address:"
curl -s https://api.ipify.org?format=json
echo
demo_delay

# Show directory structure with lsd
print_color "$COLOR_MAGENTA" "\n📂 Here's a beautiful directory tree (in reverse order):"
lsd --tree --reverse
demo_delay

# Show system information
print_color "$COLOR_BLUE" "\n💻 System Information:"
echo "Memory Usage:"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    free -h
elif [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS alternative - show memory statistics
    vm_stat | perl -ne '/page size of (\d+)/ and $size=$1; /Pages\s+([^:]+)[^\d]+(\d+)/ and printf("%-16s % 16.2f Mi\n", "$1:", $2 * $size / 1048576);'
else
    echo "Memory information not available on this platform"
fi
demo_delay

print_color "$COLOR_CYAN" "\n💾 Disk Usage:"
df -h
demo_delay

# Show some helpful git aliases
print_color "$COLOR_YELLOW" "\n🔧 Available Git Aliases:"
echo "gs  -> git status"
echo "ga  -> git add"
echo "gc  -> git commit"
echo "gp  -> git push"
echo "gl  -> git pull"
demo_delay

# Show some docker aliases
print_color "$COLOR_MAGENTA" "\n🐳 Docker Aliases:"
echo "d   -> docker"
echo "dc  -> docker-compose"
echo "dps -> docker ps"
echo "di  -> docker images"
demo_delay

# Show data preview feature
print_color "$COLOR_PINK" "\n📊 Data Preview Feature:"
echo "Use 'preview <file>' to get a beautiful summary of CSV or JSON files"
if command -v preview &> /dev/null; then
    preview scripts/sample_movies.json
else
    echo "Preview command not available. Make sure to install the data_preview.py script."
fi
demo_delay

# Final message
print_color "$COLOR_GREEN" "\n🌮 🤘 Demo completed! Enjoy your enhanced terminal! 🤘 🌮"
