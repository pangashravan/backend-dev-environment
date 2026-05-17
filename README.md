# Python Backend Development Environment

A production-style Python backend project scaffold — automated setup, Git workflow configuration, virtual environment isolation, Linux bash scripting, and modular project structure.

## What This Repo Demonstrates

- Automated environment setup via Bash scripting
- Git branching strategy (feature → develop → main)
- Virtual environment isolation with `venv`
- `.gitignore` best practices for Python projects
- `.env` based configuration management
- Modular project directory structure
- Linux terminal automation for backend tasks

## Tech Stack

- Python 3.x
- Bash / Linux Terminal
- Git & GitHub
- Flask (base app scaffold)
- python-dotenv

## Quick Start

```bash
# Clone the repo
git clone https://github.com/pangashravan/backend-dev-environment.git
cd backend-dev-environment

# Run automated setup (creates venv, structure, git init)
bash setup.sh my-project

# Activate virtual environment
cd my-project
source venv/bin/activate        # Mac/Linux
venv\Scripts\activate           # Windows

# Install dependencies
pip install -r requirements.txt

# Run the app
python src/app.py
```

## Project Structure Created by setup.sh

```
my-project/
├── src/
│   └── app.py              # Flask base application
├── tests/                  # Test files go here
├── scripts/                # Automation scripts
├── logs/                   # Log output directory
├── data/                   # Data files
├── venv/                   # Virtual environment (git-ignored)
├── requirements.txt        # Python dependencies
├── .env.example            # Environment variable template
└── .gitignore              # Python-standard gitignore
```

## Bash Utility Scripts

Load `scripts.sh` for 10 useful backend automation functions:

```bash
source scripts.sh

activate_venv       # Activate virtual environment
clean_cache         # Remove all __pycache__ and .pyc files
check_port 5000     # Check if port is in use
kill_port 5000      # Kill process on a port
new_branch feature/login   # Create Git feature branch
save_work "add login route" # Commit and push in one command
git_log             # Pretty Git history
show_structure      # Print project tree
install_and_freeze  # Install deps and update requirements.txt
run_app             # Load .env and run Flask app
```

## Git Branching Strategy

```
main        ← production-ready code only
develop     ← integration branch
feature/*   ← individual features (branch from develop)
```

```bash
# Workflow
git checkout -b feature/new-endpoint
# ... make changes ...
git add .
git commit -m "feat: add POST /api/products endpoint"
git push origin feature/new-endpoint
# → open Pull Request to develop
```

## Author

**Panga Shravan Yadav** — Python Developer | Backend Engineer  
[LinkedIn](https://www.linkedin.com/in/pangashravan) | [GitHub](https://github.com/pangashravan)
