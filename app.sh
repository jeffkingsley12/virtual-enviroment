#!/bin/bash

function create_venv() {
  local venv_name="$1"

  if [ -d "$venv_name" ]; then
    echo "Virtual environment '$venv_name' already exists."
    return 1
  fi

  python3 -m venv "$venv_name"
  echo "Virtual environment '$venv_name' created successfully."
}

function activate_venv() {
  local venv_name="$1"

  if [ ! -d "$venv_name" ]; then
    echo "Virtual environment '$venv_name' does not exist."
    return 1
  fi

  source "$venv_name/bin/activate"
}

function install_requirements() {
  local venv_name="$1"

  activate_venv "$venv_name"
  if [ -f requirements.txt ]; then
    pip install -r requirements.txt
    echo "Installed requirements from requirements.txt"
  fi
  deactivate
}

# Main script
while true; do
  echo "Enter the desired virtual environment name (or 'exit' to quit):"
  read venv_name

  if [[ "$venv_name" == "exit" ]]; then
    break
  fi

  create_venv "$venv_name"
  activate_venv "$venv_name"

  echo "Do you want to install requirements from requirements.txt? (y/n)"
  read install_reqs

  if [[ "$install_reqs" == "y" || "$install_reqs" == "yes" ]]; then
    install_requirements "$venv_name"
  fi

  deactivate
done
