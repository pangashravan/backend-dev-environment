# ─────────────────────────────────────────────────────────────────────────────
# Python Backend Development Environment - Windows PowerShell Automation Scripts
# Source this in PowerShell: . .\scripts-windows.ps1
# ─────────────────────────────────────────────────────────────────────────────

# ── 1. Activate virtual environment ──────────────────────────────────────────
function Activate-Venv {
    if (Test-Path "venv\Scripts\Activate.ps1") {
        & "venv\Scripts\Activate.ps1"
        Write-Host "Virtual environment activated." -ForegroundColor Green
    }
    else {
        Write-Host "No venv found. Run: python -m venv venv" -ForegroundColor Red
    }
}

# ── 2. Clean Python cache files ───────────────────────────────────────────────
function Clean-Cache {
    Write-Host "Cleaning Python cache..." -ForegroundColor Yellow
    
    # Remove __pycache__ directories
    Get-ChildItem -Path . -Name "__pycache__" -Recurse -Directory | ForEach-Object {
        Remove-Item -Path $_ -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    # Remove .pyc files
    Get-ChildItem -Path . -Name "*.pyc" -Recurse -File | ForEach-Object {
        Remove-Item -Path $_ -Force -ErrorAction SilentlyContinue
    }
    
    # Remove .pyo files
    Get-ChildItem -Path . -Name "*.pyo" -Recurse -File | ForEach-Object {
        Remove-Item -Path $_ -Force -ErrorAction SilentlyContinue
    }
    
    Write-Host "Cache cleaned." -ForegroundColor Green
}

# ── 3. Check which port is in use ────────────────────────────────────────────
function Check-Port {
    param([int]$Port = 5000)
    Write-Host "Checking port $Port..." -ForegroundColor Yellow
    
    $process = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
    if ($process) {
        $proc = Get-Process -Id $process.OwningProcess -ErrorAction SilentlyContinue
        Write-Host "Port $Port is in use by process: $($proc.Name) (PID: $($proc.Id))" -ForegroundColor Red
    }
    else {
        Write-Host "Port $Port is free." -ForegroundColor Green
    }
}

# ── 4. Kill process on a port ────────────────────────────────────────────────
function Kill-Port {
    param([int]$Port = 5000)
    Write-Host "Attempting to kill process on port $Port..." -ForegroundColor Yellow
    
    $connection = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
    if ($connection) {
        $proc = Get-Process -Id $connection.OwningProcess -ErrorAction SilentlyContinue
        if ($proc) {
            Stop-Process -Id $proc.Id -Force -ErrorAction SilentlyContinue
            Write-Host "Killed process $($proc.Name) (PID: $($proc.Id)) on port $Port." -ForegroundColor Green
        }
    }
    else {
        Write-Host "No process running on port $Port." -ForegroundColor Green
    }
}

# ── 5. Create new Git feature branch ─────────────────────────────────────────
function New-Branch {
    param([string]$BranchName = "feature/new-feature")
    Write-Host "Creating and switching to branch: $BranchName" -ForegroundColor Yellow
    
    git checkout -b $BranchName
    Write-Host "Created and switched to branch: $BranchName" -ForegroundColor Green
}

# ── 6. Save and push current work ────────────────────────────────────────────
function Save-Work {
    param([string]$Message = "WIP: work in progress")
    Write-Host "Saving and pushing work..." -ForegroundColor Yellow
    
    git add .
    git commit -m $Message
    git push
    Write-Host "Work saved and pushed." -ForegroundColor Green
}

# ── 7. Show recent Git log ───────────────────────────────────────────────────
function Show-GitLog {
    param([int]$Count = 10)
    Write-Host "Git log (last $Count commits):" -ForegroundColor Yellow
    git log --oneline --graph --decorate -$Count
}

# ── 8. Check project structure ───────────────────────────────────────────────
function Show-Structure {
    Write-Host "Project structure:" -ForegroundColor Yellow
    
    $excludeDirs = @("venv", ".git", "__pycache__", ".vscode", ".idea", "node_modules")
    
    function Get-DirectoryTree {
        param([string]$Path = ".", [int]$Level = 0)
        
        $items = Get-ChildItem -Path $Path -ErrorAction SilentlyContinue | 
        Where-Object { $_.Name -notin $excludeDirs -and $_.Name -notmatch "\.pyc|\.pyo" }
        
        foreach ($item in $items | Sort-Object Name) {
            $indent = "  " * $Level
            if ($item.PSIsContainer) {
                Write-Host "$indent├── $($item.Name)/" -ForegroundColor Cyan
                Get-DirectoryTree -Path $item.FullName -Level ($Level + 1)
            }
            else {
                Write-Host "$indent├── $($item.Name)" -ForegroundColor White
            }
        }
    }
    
    Get-DirectoryTree
}

# ── 9. Install dependencies and freeze ───────────────────────────────────────
function Install-AndFreeze {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    
    if (Test-Path "requirements.txt") {
        pip install -r requirements.txt
        Write-Host "Updating requirements.txt..." -ForegroundColor Yellow
        pip freeze | Set-Content -Path "requirements.txt"
        Write-Host "Dependencies installed and requirements.txt updated." -ForegroundColor Green
    }
    else {
        Write-Host "No requirements.txt found." -ForegroundColor Red
    }
}

# ── 10. Run Flask app with environment loaded ────────────────────────────────
function Run-App {
    Write-Host "Starting Flask application..." -ForegroundColor Yellow
    
    if (Test-Path ".env") {
        Write-Host "Loading .env file..." -ForegroundColor Cyan
        Get-Content .env | Where-Object { $_ -notmatch "^#" -and $_ -ne "" } | ForEach-Object {
            $line = $_
            $key, $value = $line -split "=", 2
            [Environment]::SetEnvironmentVariable($key.Trim(), $value.Trim())
        }
    }
    
    python src/app.py
}

# ── Print available functions ────────────────────────────────────────────────
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Backend Development Scripts Loaded (PowerShell)" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Available functions:" -ForegroundColor Yellow
Write-Host "  Activate-Venv          - Activate virtual environment"
Write-Host "  Clean-Cache            - Remove __pycache__ and .pyc files"
Write-Host "  Check-Port [port]      - Check if a port is in use (default: 5000)"
Write-Host "  Kill-Port [port]       - Kill process on a port (default: 5000)"
Write-Host "  New-Branch [name]      - Create new Git branch"
Write-Host "  Save-Work [message]    - Stage, commit, and push changes"
Write-Host "  Show-GitLog [count]    - Show recent Git commits (default: 10)"
Write-Host "  Show-Structure         - Display project directory structure"
Write-Host "  Install-AndFreeze      - Install dependencies and update requirements.txt"
Write-Host "  Run-App                - Run Flask app with .env loaded"
Write-Host ""
Write-Host "Example usage:" -ForegroundColor Cyan
Write-Host "  Check-Port 8000"
Write-Host "  New-Branch feature/new-api"
Write-Host "  Save-Work 'Added API endpoint'"
Write-Host ""
