#!/bin/bash

# Configuration
DEFAULT_VENV_DIR="./venvs"
PYTHON_VERSIONS=("python3" "python3.8" "python3.9" "python3.10" "python3.11" "python3.12")

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level="$1"
    shift
    case "$level" in
        "INFO") echo -e "${GREEN}[INFO]${NC} $*" ;;
        "WARN") echo -e "${YELLOW}[WARN]${NC} $*" ;;
        "ERROR") echo -e "${RED}[ERROR]${NC} $*" ;;
        "DEBUG") echo -e "${BLUE}[DEBUG]${NC} $*" ;;
    esac
}

# Create virtual environment with Python version selection
create_venv() {
    local venv_name="$1"
    local python_version="$2"
    local venv_path="${DEFAULT_VENV_DIR}/${venv_name}"
    
    if [ -d "$venv_path" ]; then
        log "WARN" "Virtual environment '$venv_name' already exists at $venv_path"
        return 1
    fi
    
    # Create venvs directory if it doesn't exist
    mkdir -p "$DEFAULT_VENV_DIR"
    
    # Use specified Python version or default
    local python_cmd="${python_version:-python3}"
    
    if ! command -v "$python_cmd" &> /dev/null; then
        log "ERROR" "Python version '$python_cmd' not found"
        return 1
    fi
    
    log "INFO" "Creating virtual environment '$venv_name' with $python_cmd..."
    "$python_cmd" -m venv "$venv_path"
    
    if [ $? -eq 0 ]; then
        log "INFO" "Virtual environment '$venv_name' created successfully at $venv_path"
        # Upgrade pip in the new environment
        source "$venv_path/bin/activate"
        pip install --upgrade pip
        deactivate
        log "INFO" "Pip upgraded in '$venv_name'"
    else
        log "ERROR" "Failed to create virtual environment '$venv_name'"
        return 1
    fi
}

# Activate virtual environment
activate_venv() {
    local venv_name="$1"
    local venv_path="${DEFAULT_VENV_DIR}/${venv_name}"
    
    if [ ! -d "$venv_path" ]; then
        log "ERROR" "Virtual environment '$venv_name' does not exist at $venv_path"
        return 1
    fi
    
    source "$venv_path/bin/activate"
    log "INFO" "Activated virtual environment '$venv_name'"
}

# Install requirements with options
install_requirements() {
    local venv_name="$1"
    local requirements_file="${2:-requirements.txt}"
    
    if ! activate_venv "$venv_name"; then
        return 1
    fi
    
    if [ -f "$requirements_file" ]; then
        log "INFO" "Installing requirements from $requirements_file..."
        pip install -r "$requirements_file"
        log "INFO" "Requirements installed successfully"
    else
        log "WARN" "Requirements file '$requirements_file' not found"
        return 1
    fi
    
    deactivate
}

# List all virtual environments
list_venvs() {
    log "INFO" "Available virtual environments in $DEFAULT_VENV_DIR:"
    if [ -d "$DEFAULT_VENV_DIR" ]; then
        for venv in "$DEFAULT_VENV_DIR"/*; do
            if [ -d "$venv" ] && [ -f "$venv/bin/activate" ]; then
                local venv_name=$(basename "$venv")
                local python_version=$("$venv/bin/python" --version 2>&1)
                echo "  - $venv_name ($python_version)"
            fi
        done
    else
        log "WARN" "No virtual environments directory found"
    fi
}

# Remove virtual environment
remove_venv() {
    local venv_name="$1"
    local venv_path="${DEFAULT_VENV_DIR}/${venv_name}"
    
    if [ ! -d "$venv_path" ]; then
        log "ERROR" "Virtual environment '$venv_name' does not exist"
        return 1
    fi
    
    echo "Are you sure you want to remove '$venv_name'? (y/N)"
    read -r confirmation
    if [[ "$confirmation" =~ ^[Yy]$ ]]; then
        rm -rf "$venv_path"
        log "INFO" "Virtual environment '$venv_name' removed successfully"
    else
        log "INFO" "Removal cancelled"
    fi
}

# Export requirements from active environment
export_requirements() {
    local output_file="${1:-requirements.txt}"
    
    if [ -z "$VIRTUAL_ENV" ]; then
        log "ERROR" "No virtual environment is currently active"
        return 1
    fi
    
    pip freeze > "$output_file"
    log "INFO" "Requirements exported to $output_file"
}

# Show virtual environment info
show_venv_info() {
    local venv_name="$1"
    local venv_path="${DEFAULT_VENV_DIR}/${venv_name}"
    
    if [ ! -d "$venv_path" ]; then
        log "ERROR" "Virtual environment '$venv_name' does not exist"
        return 1
    fi
    
    echo -e "${BLUE}Virtual Environment Info:${NC}"
    echo "Name: $venv_name"
    echo "Path: $venv_path"
    echo "Python Version: $($venv_path/bin/python --version)"
    echo "Pip Version: $($venv_path/bin/pip --version)"
    echo -e "\n${BLUE}Installed Packages:${NC}"
    "$venv_path/bin/pip" list
}

# Select Python version interactively
select_python_version() {
    echo "Available Python versions:"
    local i=1
    local available_versions=()
    
    for version in "${PYTHON_VERSIONS[@]}"; do
        if command -v "$version" &> /dev/null; then
            echo "  $i) $version ($($version --version 2>&1))"
            available_versions+=("$version")
            ((i++))
        fi
    done
    
    if [ ${#available_versions[@]} -eq 0 ]; then
        log "ERROR" "No Python versions found"
        return 1
    fi
    
    echo "  0) Use default (python3)"
    echo "Select Python version (0-$((${#available_versions[@]}))):"
    read -r choice
    
    if [[ "$choice" == "0" ]]; then
        echo "python3"
    elif [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le ${#available_versions[@]} ]; then
        echo "${available_versions[$((choice-1))]}"
    else
        log "ERROR" "Invalid selection"
        return 1
    fi
}

# Show help
show_help() {
    cat << EOF
Virtual Environment Manager

Usage: $0 [OPTION]

Options:
  -h, --help          Show this help message
  -l, --list          List all virtual environments
  -c, --create NAME   Create a new virtual environment
  -r, --remove NAME   Remove a virtual environment
  -i, --info NAME     Show information about a virtual environment
  -e, --export [FILE] Export requirements from active environment

Interactive mode (default):
  Run without options to enter interactive mode

Examples:
  $0 --create myproject
  $0 --list
  $0 --info myproject
  $0 --remove myproject
  $0 --export requirements-dev.txt
EOF
}

# Parse command line arguments
if [ $# -gt 0 ]; then
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -l|--list)
            list_venvs
            exit 0
            ;;
        -c|--create)
            if [ -z "$2" ]; then
                log "ERROR" "Please provide a virtual environment name"
                exit 1
            fi
            echo "Select Python version for '$2':"
            python_version=$(select_python_version)
            if [ $? -eq 0 ]; then
                create_venv "$2" "$python_version"
            fi
            exit 0
            ;;
        -r|--remove)
            if [ -z "$2" ]; then
                log "ERROR" "Please provide a virtual environment name"
                exit 1
            fi
            remove_venv "$2"
            exit 0
            ;;
        -i|--info)
            if [ -z "$2" ]; then
                log "ERROR" "Please provide a virtual environment name"
                exit 1
            fi
            show_venv_info "$2"
            exit 0
            ;;
        -e|--export)
            export_requirements "$2"
            exit 0
            ;;
        *)
            log "ERROR" "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
fi

# Interactive mode (main script)
log "INFO" "Virtual Environment Manager - Interactive Mode"
echo "Virtual environments will be created in: $DEFAULT_VENV_DIR"

while true; do
    echo
    echo "Available actions:"
    echo "1) Create new virtual environment"
    echo "2) List virtual environments"
    echo "3) Activate virtual environment"
    echo "4) Install requirements"
    echo "5) Remove virtual environment"
    echo "6) Show virtual environment info"
    echo "7) Export requirements"
    echo "8) Exit"
    
    echo
    echo "Choose an action (1-8):"
    read -r action
    
    case "$action" in
        1)
            echo "Enter virtual environment name:"
            read -r venv_name
            if [ -n "$venv_name" ]; then
                echo "Select Python version:"
                python_version=$(select_python_version)
                if [ $? -eq 0 ]; then
                    create_venv "$venv_name" "$python_version"
                    
                    echo "Do you want to install requirements? (y/n)"
                    read -r install_reqs
                    if [[ "$install_reqs" =~ ^[Yy]$ ]]; then
                        echo "Enter requirements file path (default: requirements.txt):"
                        read -r req_file
                        install_requirements "$venv_name" "$req_file"
                    fi
                fi
            fi
            ;;
        2)
            list_venvs
            ;;
        3)
            list_venvs
            echo
            echo "Enter virtual environment name to activate:"
            read -r venv_name
            if [ -n "$venv_name" ]; then
                activate_venv "$venv_name"
                log "INFO" "Virtual environment activated. Run 'deactivate' to exit."
                break
            fi
            ;;
        4)
            list_venvs
            echo
            echo "Enter virtual environment name:"
            read -r venv_name
            if [ -n "$venv_name" ]; then
                echo "Enter requirements file path (default: requirements.txt):"
                read -r req_file
                install_requirements "$venv_name" "$req_file"
            fi
            ;;
        5)
            list_venvs
            echo
            echo "Enter virtual environment name to remove:"
            read -r venv_name
            if [ -n "$venv_name" ]; then
                remove_venv "$venv_name"
            fi
            ;;
        6)
            list_venvs
            echo
            echo "Enter virtual environment name:"
            read -r venv_name
            if [ -n "$venv_name" ]; then
                show_venv_info "$venv_name"
            fi
            ;;
        7)
            echo "Enter output file name (default: requirements.txt):"
            read -r output_file
            export_requirements "$output_file"
            ;;
        8|exit|quit)
            log "INFO" "Goodbye!"
            break
            ;;
        *)
            log "WARN" "Invalid option. Please choose 1-8."
            ;;
    esac
done
