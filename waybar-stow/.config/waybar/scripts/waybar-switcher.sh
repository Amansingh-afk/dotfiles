#!/bin/bash

# Waybar Theme Switcher Script
# Usage: waybar-switcher.sh [theme_name] or waybar-switcher.sh (interactive)

WAYBAR_CONFIG_DIR="$HOME/.config/waybar"
CONFIGS_DIR="$WAYBAR_CONFIG_DIR/configs"
CURRENT_CONFIG="$WAYBAR_CONFIG_DIR/config"
CURRENT_STYLE="$WAYBAR_CONFIG_DIR/style.css"

# Available themes
THEMES=("glass" "blur" "mechabar")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_theme() {
    echo -e "${CYAN}[THEME]${NC} $1"
}

# Function to check if waybar is running
is_waybar_running() {
    pgrep -x waybar > /dev/null
}

# Function to kill waybar
kill_waybar() {
    if is_waybar_running; then
        print_status "Stopping waybar..."
        pkill -x waybar
        sleep 1
    fi
}

# Function to start waybar
start_waybar() {
    print_status "Starting waybar with $1 theme..."
    waybar &
    sleep 1
    if is_waybar_running; then
        print_status "Waybar started successfully!"
    else
        print_error "Failed to start waybar!"
        exit 1
    fi
}

# Function to switch theme
switch_theme() {
    local theme=$1
    local theme_config="$CONFIGS_DIR/$theme/config"
    local theme_style="$CONFIGS_DIR/$theme/style.css"
    
    # Check if theme exists
    if [[ ! -d "$CONFIGS_DIR/$theme" ]]; then
        print_error "Theme '$theme' not found in $CONFIGS_DIR"
        return 1
    fi
    
    if [[ ! -f "$theme_config" ]]; then
        print_error "Config file not found for theme '$theme'"
        return 1
    fi
    
    if [[ ! -f "$theme_style" ]]; then
        print_error "Style file not found for theme '$theme'"
        return 1
    fi
    
    # Backup current config if it exists and is not a symlink
    if [[ -f "$CURRENT_CONFIG" && ! -L "$CURRENT_CONFIG" ]]; then
        print_status "Backing up current config..."
        cp "$CURRENT_CONFIG" "$CURRENT_CONFIG.backup.$(date +%s)"
    fi
    
    # Backup current style if it exists and is not a symlink
    if [[ -f "$CURRENT_STYLE" && ! -L "$CURRENT_STYLE" ]]; then
        print_status "Backing up current style..."
        cp "$CURRENT_STYLE" "$CURRENT_STYLE.backup.$(date +%s)"
    fi
    
    # Create symlinks to theme files
    print_status "Switching to $theme theme..."
    ln -sf "$theme_config" "$CURRENT_CONFIG"
    ln -sf "$theme_style" "$CURRENT_STYLE"
    
    # Restart waybar
    kill_waybar
    start_waybar "$theme"
    
    print_theme "Successfully switched to $theme theme!"
    
    # Show theme info
    show_theme_info "$theme"
}

# Function to show theme information
show_theme_info() {
    local theme=$1
    echo
    echo -e "${PURPLE}═══════════════════════════════════════${NC}"
    echo -e "${PURPLE}           WAYBAR THEME INFO            ${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════${NC}"
    echo -e "${CYAN}Current Theme:${NC} $theme"
    echo -e "${CYAN}Config File:${NC} $CONFIGS_DIR/$theme/config"
    echo -e "${CYAN}Style File:${NC} $CONFIGS_DIR/$theme/style.css"
    echo -e "${PURPLE}═══════════════════════════════════════${NC}"
    echo
}

# Function to list available themes
list_themes() {
    echo -e "${BLUE}Available Waybar Themes:${NC}"
    echo
    for theme in "${THEMES[@]}"; do
        if [[ -d "$CONFIGS_DIR/$theme" ]]; then
            echo -e "  ${GREEN}✓${NC} $theme"
        else
            echo -e "  ${RED}✗${NC} $theme (not found)"
        fi
    done
    echo
}

# Function to show current theme
show_current_theme() {
    if [[ -L "$CURRENT_CONFIG" ]]; then
        local current_theme=$(basename $(readlink "$CURRENT_CONFIG" | sed 's|/config$||'))
        print_theme "Current theme: $current_theme"
        show_theme_info "$current_theme"
    else
        print_warning "No theme is currently active (using default config)"
    fi
}

# Function for interactive theme selection
interactive_selection() {
    echo -e "${BLUE}Waybar Theme Switcher${NC}"
    echo -e "${BLUE}═════════════════════${NC}"
    echo
    
    list_themes
    
    echo -e "${YELLOW}Select a theme:${NC}"
    for i in "${!THEMES[@]}"; do
        echo -e "  $((i+1)). ${THEMES[i]}"
    done
    echo -e "  0. Show current theme"
    echo -e "  q. Quit"
    echo
    
    read -p "Enter your choice: " choice
    
    case $choice in
        0)
            show_current_theme
            ;;
        [1-9]*)
            if [[ $choice -ge 1 && $choice -le ${#THEMES[@]} ]]; then
                local selected_theme="${THEMES[$((choice-1))]}"
                switch_theme "$selected_theme"
            else
                print_error "Invalid choice!"
                exit 1
            fi
            ;;
        q|Q)
            print_status "Exiting..."
            exit 0
            ;;
        *)
            print_error "Invalid choice!"
            exit 1
            ;;
    esac
}

# Function to show help
show_help() {
    echo -e "${BLUE}Waybar Theme Switcher${NC}"
    echo -e "${BLUE}═════════════════════${NC}"
    echo
    echo -e "${CYAN}Usage:${NC}"
    echo -e "  $0 [theme_name]     # Switch to specific theme"
    echo -e "  $0                  # Interactive mode"
    echo -e "  $0 --list           # List available themes"
    echo -e "  $0 --current        # Show current theme"
    echo -e "  $0 --help           # Show this help"
    echo
    echo -e "${CYAN}Available themes:${NC} ${THEMES[*]}"
    echo
    echo -e "${CYAN}Examples:${NC}"
    echo -e "  $0 glass            # Switch to glass theme"
    echo -e "  $0 blur             # Switch to blur theme"
    echo -e "  $0 mechabar         # Switch to mechabar theme"
    echo
}

# Main script logic
main() {
    case "${1:-}" in
        --help|-h)
            show_help
            ;;
        --list|-l)
            list_themes
            ;;
        --current|-c)
            show_current_theme
            ;;
        "")
            interactive_selection
            ;;
        *)
            # Check if the argument is a valid theme
            if [[ " ${THEMES[*]} " =~ " $1 " ]]; then
                switch_theme "$1"
            else
                print_error "Unknown theme: $1"
                echo
                show_help
                exit 1
            fi
            ;;
    esac
}

# Run main function with all arguments
main "$@"
