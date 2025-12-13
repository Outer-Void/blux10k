#!/usr/bin/env zsh
# BLUX10K Starship Helper Functions

# Function to toggle Starship modules
function starship-toggle() {
    case "$1" in
        minimal)
            export STARSHIP_CONFIG=~/.config/starship/minimal.toml
            echo "Starship: Minimal mode activated"
            ;;
        blux10k)
            export STARSHIP_CONFIG=~/.config/starship/starship.toml
            echo "Starship: BLUX10K mode activated"
            ;;
        detailed)
            export STARSHIP_CONFIG=~/.config/starship/detailed.toml
            echo "Starship: Detailed mode activated"
            ;;
        help|--help|-h)
            echo "Starship Mode Switcher:"
            echo "  starship-toggle minimal   - Minimal prompt"
            echo "  starship-toggle blux10k   - BLUX10K style (default)"
            echo "  starship-toggle detailed  - Detailed prompt"
            echo "  starship-toggle help      - Show this help"
            ;;
        *)
            echo "Current Starship config: $STARSHIP_CONFIG"
            ;;
    esac
}

# Function to reload Starship configuration
function starship-reload() {
    export STARSHIP_CONFIG=~/.config/starship/starship.toml
    echo "Starship configuration reloaded"
}

# Function to show current Starship configuration
function starship-config() {
    if [[ -n "$STARSHIP_CONFIG" ]]; then
        echo "Current config: $STARSHIP_CONFIG"
        cat "$STARSHIP_CONFIG" | head -20
    else
        echo "Using default Starship configuration"
    fi
}

# Function to edit Starship configuration
function starship-edit() {
    ${EDITOR:-nvim} ~/.config/starship/starship.toml
}

# Add Starship help to b10k system
function b10k() {
    case "$1" in
        starship)
            echo ""
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║                     STARSHIP COMMANDS                          ║"
            echo "║                    BLUX10K Integration                         ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ CONFIGURATION ▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  starship-toggle <mode>     - Switch prompt modes"
            echo "  starship-reload            - Reload configuration"
            echo "  starship-config            - Show current config"
            echo "  starship-edit              - Edit configuration"
            echo ""
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ MODES ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  minimal                    - Clean, minimal prompt"
            echo "  blux10k                    - BLUX10K professional style"
            echo "  detailed                   - Feature-rich detailed prompt"
            echo ""
            echo "▬▬▬▬▬▬▬▬▬▬▬▬▬▬▤ FEATURES ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬"
            echo "  • Git integration with detailed status"
            echo "  • Programming language versions"
            echo "  • Kubernetes and Docker context"
            echo "  • System information"
            echo "  • Custom BLUX10K modules"
            echo "  • Performance optimized"
            echo ""
            echo "╔════════════════════════════════════════════════════════════════╗"
            echo "║        Run 'starship toggle blux10k' for BLUX10K style        ║"
            echo "║        Run 'b10k --help' for full BLUX10K reference           ║"
            echo "╚════════════════════════════════════════════════════════════════╝"
            echo ""
            ;;
        # ... rest of your existing b10k function
    esac
}

# Initialize Starship if available
if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
    export STARSHIP_CONFIG=~/.config/starship/starship.toml
fi