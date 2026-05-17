# Python Backend Development Environment Setup (Windows PowerShell)
$PROJECT_NAME = 'my-backend-project'
$PYTHON = 'python'

Write-Host '================================================' -ForegroundColor Cyan
Write-Host '  Python Backend Dev Environment Setup' -ForegroundColor Cyan
Write-Host '================================================' -ForegroundColor Cyan
Write-Host "Project: $PROJECT_NAME"
Write-Host ''

# Step 1: Verify Python
Write-Host '[1/5] Checking Python installation...' -ForegroundColor Yellow
$pythonVersion = python --version 2>&1
Write-Host "      Found: $pythonVersion" -ForegroundColor Green

# Step 2: Create project structure
Write-Host '[2/5] Creating project structure...' -ForegroundColor Yellow
New-Item -ItemType Directory -Path "$PROJECT_NAME\src" -Force | Out-Null
New-Item -ItemType Directory -Path "$PROJECT_NAME\tests" -Force | Out-Null
New-Item -ItemType Directory -Path "$PROJECT_NAME\scripts" -Force | Out-Null
New-Item -ItemType Directory -Path "$PROJECT_NAME\logs" -Force | Out-Null
New-Item -ItemType Directory -Path "$PROJECT_NAME\data" -Force | Out-Null
Write-Host '      Created directories: src, tests, scripts, logs, data' -ForegroundColor Green

# Step 3: Create virtual environment
Write-Host '[3/5] Setting up virtual environment...' -ForegroundColor Yellow
Push-Location "$PROJECT_NAME"
python -m venv venv
Write-Host "      Virtual environment created at .\$PROJECT_NAME\venv" -ForegroundColor Green

# Step 4: Create base files
Write-Host '[4/5] Creating base files...' -ForegroundColor Yellow

# requirements.txt
@'
flask==3.0.3
requests==2.31.0
python-dotenv==1.0.0
'@ | Set-Content -Path 'requirements.txt'

# .env.example
@'
# Copy this to .env and fill in values
APP_ENV=development
APP_PORT=5000
DATABASE_URL=sqlite:///app.db
SECRET_KEY=your-secret-key-here
'@ | Set-Content -Path '.env.example'

# .gitignore
@'
# Virtual environment
venv/
env/
.env

# Python cache
__pycache__/
*.pyc
*.pyo
*.pyd

# Database files
*.db
*.sqlite3

# Logs
logs/*.log

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db
'@ | Set-Content -Path '.gitignore'

# Flask app
@'
from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def index():
    return jsonify({"message": "Backend running!", "status": "ok"})

if __name__ == '__main__':
    app.run(debug=True)
'@ | Set-Content -Path 'src\app.py'

Write-Host '      Created: requirements.txt, .env.example, .gitignore, src/app.py' -ForegroundColor Green

# Step 5: Git init
Write-Host '[5/5] Initialising Git repository...' -ForegroundColor Yellow
git init --quiet
git add .
git commit --quiet -m 'Initial project setup — Python backend environment configured'
Write-Host '      Git repository initialised with first commit' -ForegroundColor Green

Write-Host ''
Write-Host '================================================' -ForegroundColor Cyan
Write-Host '  Setup Complete!' -ForegroundColor Cyan
Write-Host '================================================' -ForegroundColor Cyan
Write-Host ''
Write-Host 'Next steps:' -ForegroundColor Yellow
Write-Host "  cd $PROJECT_NAME"
Write-Host '  venv\Scripts\activate                # Windows'
Write-Host '  pip install -r requirements.txt'
Write-Host '  python src/app.py'
Write-Host ''

Pop-Location
