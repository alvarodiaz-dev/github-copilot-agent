---
name: publish-to-github
description: "Use when: publishing generated code to GitHub with automated repository creation, git initialization, and push using GitHub CLI"
---

# Publish to GitHub Skill

Automates the process of creating GitHub repositories and pushing generated code using GitHub CLI (gh).

## When to Use This Skill

- After generating microservice code, publish it to GitHub
- Create new GitHub repositories programmatically
- Initialize git and push code in one workflow
- Automate repository creation for multiple services
- Integrate GitHub publishing into code generation pipeline

## Prerequisites

### GitHub CLI Installation

**Windows (PowerShell):**
```powershell
# Via Scoop
scoop install gh

# Via Chocolatey
choco install gh

# Via Windows Package Manager
winget install GitHub.cli
```

### GitHub Authentication

**For Portable GitHub CLI** (`C:/tools/bin/gh.exe`):
```powershell
C:/tools/bin/gh.exe auth login
```

**For Standard Installation:**
```bash
gh auth login
```

Follow prompts:
1. Select GitHub.com
2. Select HTTPS as your preferred protocol
3. Paste a personal access token OR authorize interactively

Verify:
```powershell
C:/tools/bin/gh.exe auth status
```

## Workflow

### Step 1: Prepare Repository Directory
- Ensure you have a local directory with code to publish
- Directory structure should be ready for git (no .git folder yet)
- Files to include: source code, README.md, .gitignore, LICENSE (optional)

### Step 2: Initialize Local Git Repository
```bash
cd {service-directory}
git init
git add .
git commit -m "Initial commit: {ServiceName} microservice"
```

### Step 3: Create GitHub Repository (Automated)
Using GitHub CLI (Portable):
```powershell
C:/tools/bin/gh.exe repo create alvarodiaz-dev/{service-name} `
  --public `
  --source=. `
  --remote=origin `
  --push
```

Or with standard installation:
```bash
gh repo create alvarodiaz-dev/{service-name} \
  --public \
  --source=. \
  --remote=origin \
  --push
```

**Parameters explained:**
- `alvarodiaz-dev/` - GitHub organization/username
- `{service-name}` - Repository name (lowercase, hyphenated)
- `--public` - Public repository (change to `--private` if needed)
- `--source=.` - Use current directory as source
- `--remote=origin` - Set origin remote automatically
- `--push` - Push immediately after creation

### Step 4: Verify Publication
```powershell
# Check repository was created (Portable)
C:/tools/bin/gh.exe repo view alvarodiaz-dev/{service-name}

# View repository URL
C:/tools/bin/gh.exe repo view alvarodiaz-dev/{service-name} --json url

# List recent commits
git log --oneline
```

## Complete Script

Save as `publish.sh` (or `.ps1` for PowerShell):

**Bash Script:**
```bash
#!/bin/bash

SERVICE_NAME=$1
SERVICE_DIR=$2
GITHUB_ORG="alvarodiaz-dev"

if [ -z "$SERVICE_NAME" ] || [ -z "$SERVICE_DIR" ]; then
  echo "Usage: $0 <service-name> <service-dir>"
  echo "Example: $0 user-service ./src/UserService"
  exit 1
fi

# Convert to lowercase and add hyphens
REPO_NAME=$(echo "$SERVICE_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

cd "$SERVICE_DIR" || exit

echo "📦 Publishing $REPO_NAME to GitHub..."

# Initialize git if not already done
if [ ! -d ".git" ]; then
  git init
  git add .
  git commit -m "Initial commit: $SERVICE_NAME microservice"
  echo "✅ Local git repository initialized"
else
  echo "ℹ️ Git repository already initialized"
fi

# Create and push to GitHub
echo "🚀 Creating GitHub repository..."
# If portable: C:/tools/bin/gh.exe repo create ...
# If standard: gh repo create ...
gh repo create "$GITHUB_ORG/$REPO_NAME" \
  --public \
  --source=. \
  --remote=origin \
  --push

echo "✅ Repository created and code pushed!"
echo "🔗 GitHub URL: https://github.com/$GITHUB_ORG/$REPO_NAME"
echo "📚 Clone with: git clone https://github.com/$GITHUB_ORG/$REPO_NAME"
```

**PowerShell Script:**
```powershell
param(
    [Parameter(Mandatory=$true)]
    [string]$ServiceName,
    
    [Parameter(Mandatory=$true)]
    [string]$ServiceDir
)

$GITHUB_ORG = "alvarodiaz-dev"
$REPO_NAME = $ServiceName.ToLower() -replace ' ', '-'

Write-Host "📦 Publishing $REPO_NAME to GitHub..."

Set-Location $ServiceDir

# Initialize git
if (-not (Test-Path ".git")) {
    git init
    git add .
    git commit -m "Initial commit: $ServiceName microservice"
    Write-Host "✅ Local git repository initialized"
} else {
    Write-Host "ℹ️ Git repository already initialized"
}

# Create and push
Write-Host "🚀 Creating GitHub repository..."
# Using portable GitHub CLI
C:/tools/bin/gh.exe repo create "$GITHUB_ORG/$REPO_NAME" `
  --public `
  --source=. `
  --remote=origin `
  --push

Write-Host "✅ Repository created and code pushed!"
Write-Host "🔗 GitHub URL: https://github.com/$GITHUB_ORG/$REPO_NAME"
Write-Host "📚 Clone with: git clone https://github.com/$GITHUB_ORG/$REPO_NAME"
```

## Repository Naming Convention

Follow this pattern for consistency:

| Service Type | Example Name | GitHub Repo |
|--------------|--------------|-------------|
| User Service | UserService | `alvarodiaz-dev/user-service` |
| Order Service | OrderService | `alvarodiaz-dev/order-service` |
| Payment Service | PaymentService | `alvarodiaz-dev/payment-service` |
| Inventory Service | InventoryService | `alvarodiaz-dev/inventory-service` |

**Naming rules:**
- Convert PascalCase → lowercase-with-hyphens
- Use hyphens, not underscores
- Keep names under 30 characters
- Be descriptive but concise

## .gitignore Template

Create `.gitignore` before pushing:

```
# Build results
bin/
obj/
*.dll
*.exe

# Visual Studio
.vs/
*.sln.docstates
.vscode/

# NuGet
*.nupkg
.nuget/

# Entity Framework
Migrations/
*.db
*.db-shm
*.db-wal

# Environment
.env
.env.local
appsettings.*.json
secrets.json

# OS
.DS_Store
Thumbs.db

# IDE
*.user
*.suo
```

## Common Issues

### ❌ "gh not found"
```powershell
# For Portable: check path exists
Test-Path C:/tools/bin/gh.exe

# For Standard: Install GitHub CLI first
scoop install gh
```

### ❌ "Not authenticated"
```powershell
# Portable version
C:/tools/bin/gh.exe auth login

# Standard version
gh auth login
```

### ❌ "Repository already exists"
```powershell
# Use different repo name or delete existing repo first
C:/tools/bin/gh.exe repo delete alvarodiaz-dev/service-name
C:/tools/bin/gh.exe repo create alvarodiaz-dev/service-name --public --source=. --remote=origin --push
```

### ❌ "Failed to push"
```bash
# Check git is configured
git config --global user.name "Your Name"
git config --global user.email "your@email.com"

# Add remote manually
git remote add origin https://github.com/alvarodiaz-dev/service-name
git branch -M main
git push -u origin main
```

## Integration with Other Skills

This skill is typically used **after** generate-csharp:

```
requirements.md
    ↓
[extract-requirements skill]
    ↓
requirements.json
    ↓
[generate-csharp skill]
    ↓
Generated C# files
    ↓
[publish-to-github skill] ← You are here
    ↓
❌ Published to https://github.com/alvarodiaz-dev/{service-name}
```

## Invocation Triggers

The agent automatically loads this skill when you ask:
- "Publish this code to GitHub"
- "Push generated microservice to GitHub"
- "Create GitHub repository for this service"
- "Upload code to alvarodiaz-dev GitHub"
