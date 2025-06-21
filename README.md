# Virtual Environment Manager

A comprehensive Bash script for managing Python virtual environments with ease and efficiency.

## 🚀 Features

- **Interactive Menu System**: User-friendly interface for all operations
- **Command Line Interface**: Support for non-interactive automation
- **Python Version Selection**: Choose from available Python versions (3.8-3.12)
- **Organized Storage**: All environments stored in a dedicated `./venvs` directory
- **Environment Management**: Create, list, activate, remove, and inspect environments
- **Requirements Handling**: Install from requirements files and export current packages
- **Colored Output**: Enhanced readability with color-coded messages
- **Robust Error Handling**: Comprehensive validation and error reporting
- **Automatic Pip Upgrades**: Ensures latest pip version in new environments

## 📋 Prerequisites

- **Python 3.x** installed on your system
- **Bash shell** (Linux/macOS/WSL)
- Basic command line knowledge

## 🛠️ Installation

1. **Download the script:**
   ```bash
   curl -O https://raw.githubusercontent.com/jeffkingsley12/venv-manager/main/venv_manager.sh
   # or
   wget https://raw.githubusercontent.com/jeffkingsley12/venv-manager/main/venv_manager.sh
   ```

2. **Make it executable:**
   ```bash
   chmod +x venv_manager.sh
   ```

3. **Run the script:**
   ```bash
   ./venv_manager.sh
   ```

## 📖 Usage

### Interactive Mode (Default)

Simply run the script without arguments to enter interactive mode:

```bash
./venv_manager.sh
```

You'll see a menu with options:
1. Create new virtual environment
2. List virtual environments
3. Activate virtual environment
4. Install requirements
5. Remove virtual environment
6. Show virtual environment info
7. Export requirements
8. Exit

### Command Line Interface

For automation and scripting, use command line arguments:

```bash
# Show help
./venv_manager.sh --help

# List all virtual environments
./venv_manager.sh --list

# Create a new environment
./venv_manager.sh --create myproject

# Show environment information
./venv_manager.sh --info myproject

# Remove an environment
./venv_manager.sh --remove myproject

# Export requirements from active environment
./venv_manager.sh --export requirements-dev.txt
```

## 🔧 Configuration

The script uses these default configurations:

- **Default Directory**: `./venvs` (all virtual environments stored here)
- **Supported Python Versions**: python3, python3.8, python3.9, python3.10, python3.11, python3.12
- **Default Requirements File**: `requirements.txt`

You can modify these settings by editing the configuration section at the top of the script:

```bash
# Configuration
DEFAULT_VENV_DIR="./venvs"
PYTHON_VERSIONS=("python3" "python3.8" "python3.9" "python3.10" "python3.11" "python3.12")
```

## 📁 Directory Structure

After running the script, your project structure will look like:

```
your-project/
├── venvs/
│   ├── myproject1/
│   │   ├── bin/
│   │   ├── lib/
│   │   └── ...
│   ├── myproject2/
│   │   ├── bin/
│   │   ├── lib/
│   │   └── ...
│   └── ...
├── requirements.txt
└── venv_manager.sh
```

## 🎯 Examples

### Creating a Development Environment

```bash
# Interactive mode
./venv_manager.sh
# Choose option 1, enter "webdev", select Python 3.11
# Optionally install from requirements.txt

# Command line mode
./venv_manager.sh --create webdev
```

### Managing Multiple Projects

```bash
# Create environments for different projects
./venv_manager.sh --create frontend
./venv_manager.sh --create backend
./venv_manager.sh --create data-analysis

# List all environments
./venv_manager.sh --list
```

### Working with Requirements

```bash
# Create environment and install requirements
./venv_manager.sh --create myproject
# Then use interactive mode to install requirements

# Export current environment packages
# (after activating an environment)
./venv_manager.sh --export my-requirements.txt
```

## 🔍 Troubleshooting

### Common Issues

**Script not executable:**
```bash
chmod +x venv_manager.sh
```

**Python version not found:**
- Ensure the desired Python version is installed
- Check available versions with: `python3 --version`, `python3.11 --version`, etc.

**Permission denied:**
- Make sure you have write permissions in the current directory
- Try running with appropriate permissions

**Virtual environment creation fails:**
- Verify Python installation: `python3 -m venv --help`
- Check disk space availability
- Ensure no conflicting virtual environments exist

### Debug Mode

For debugging, you can add verbose output by modifying the script or running with bash debug mode:

```bash
bash -x ./venv_manager.sh
```

## 🚦 Error Handling

The script includes comprehensive error handling for:
- Invalid virtual environment names
- Missing Python versions
- Failed environment creation
- Missing requirements files
- Permission issues
- Invalid user input

All errors are displayed with colored output for easy identification.

## 🔄 Migration from Basic Script

If you're upgrading from a basic virtual environment script:

1. **Backup existing environments:**
   ```bash
   mkdir backup_venvs
   mv your_old_venv backup_venvs/
   ```

2. **Use the new script to recreate environments:**
   ```bash
   ./venv_manager.sh --create your_old_venv
   ```

3. **Reinstall packages:**
   ```bash
   # If you have a requirements.txt
   ./venv_manager.sh # Then use option 4 to install requirements
   ```

## 🤝 Contributing

We welcome contributions! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch:**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Make your changes**
4. **Add tests if applicable**
5. **Commit your changes:**
   ```bash
   git commit -m 'Add amazing feature'
   ```
6. **Push to the branch:**
   ```bash
   git push origin feature/amazing-feature
   ```
7. **Open a Pull Request**

### Development Guidelines

- Follow existing code style and conventions
- Add comments for complex logic
- Test on multiple Python versions
- Update documentation for new features
- Use meaningful commit messages

## 📝 Changelog

### Version 2.0.0 (Current)
- ✅ Added interactive menu system
- ✅ Command line interface support
- ✅ Python version selection
- ✅ Organized virtual environment storage
- ✅ Environment management (list, remove, info)
- ✅ Requirements export functionality
- ✅ Colored output and better error handling
- ✅ Automatic pip upgrades

### Version 1.0.0 (Original)
- ✅ Basic virtual environment creation
- ✅ Environment activation
- ✅ Requirements installation

## 🐛 Known Issues

- Colors may not display correctly in some terminal emulators
- Script requires Bash 4.0+ for associative arrays (if using advanced features)

## 📋 TODO / Future Improvements

- [ ] Support for conda environments
- [ ] Integration with poetry/pipenv
- [ ] Environment cloning functionality
- [ ] Automatic environment activation on directory change
- [ ] Configuration file support (.venvrc)
- [ ] Docker integration
- [ ] Environment templates
- [ ] Backup and restore functionality

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Virtual Environment Manager

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 🙏 Acknowledgments

- Thanks to the Python community for the excellent `venv` module
- Inspired by various virtual environment management tools
- Contributors and users who provide feedback and suggestions

## 📞 Support

- **Issues**: Report bugs and request features via [GitHub Issues](https://github.com/yourusername/venv-manager/issues)
- **Discussions**: Join conversations in [GitHub Discussions](https://github.com/yourusername/venv-manager/discussions)
- **Documentation**: Check the [Wiki](https://github.com/yourusername/venv-manager/wiki) for detailed guides

---

**Made with ❤️ for Python developers**
