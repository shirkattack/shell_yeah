#!/bin/zsh

# Source zsh configuration
source ~/.zshrc

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
print_color "36" "🚀 Shell yeah! Let's explore our terminal! 🚀"
demo_delay

# Show ASCII art
print_color "33" "\n🎨 Check out this cool ASCII art:"
show_ascii_art
demo_delay

# Weather information
print_color "33" "\n📅 Let's check the weather:"
curl "https://v2.wttr.in/83263"
demo_delay

# IP information
print_color "32" "\n🌐 Your current IP address:"
curl -s https://api.ipify.org\?format\=json
echo
demo_delay

# Show directory structure with lsd
print_color "35" "\n📂 Here's a beautiful directory tree (in reverse order):"
lsd --tree --reverse
demo_delay

# Show system information
print_color "34" "\n💻 System Information:"
echo "Memory Usage:"
free -h
demo_delay

print_color "36" "\n💾 Disk Usage:"
df -h
demo_delay

# Show some helpful git aliases
print_color "33" "\n🔧 Available Git Aliases:"
echo "gs  -> git status"
echo "ga  -> git add"
echo "gc  -> git commit"
echo "gp  -> git push"
echo "gl  -> git pull"
demo_delay

# Show some docker aliases
print_color "35" "\n🐳 Docker Aliases:"
echo "d   -> docker"
echo "dc  -> docker-compose"
echo "dps -> docker ps"
echo "di  -> docker images"
demo_delay

# Show data preview feature
print_color "13" "\n📊 Data Preview Feature:"
echo "Use 'preview <file>' to get a beautiful summary of CSV or JSON files"
preview scripts/sample_movies.json
demo_delay

# Final message
print_color "32" "\n🌮 🤘 Demo completed! Enjoy your enhanced terminal! 🤘 🌮"
