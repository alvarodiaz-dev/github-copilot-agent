# Publish to GitHub Setup Guide

## Quick Start (5 minutes)

### 1. GitHub CLI Setup

**Option A: Portable Installation** (Recommended if admin access is restricted)
```powershell
# Verify portable installation
Test-Path C:/tools/bin/gh.exe

# If installed:
C:/tools/bin/gh.exe auth login
```

**Option B: Standard Installation**
```powershell
# Windows PowerShell
winget install GitHub.cli
# OR
scoop install gh
# OR
choco install gh
```

### 2. Authenticate (One-time)
```powershell
# Use whichever path applies:
C:/tools/bin/gh.exe auth login
# OR
gh auth login

# Follow prompts to authenticate with GitHub
```

### 3. Verify
```powershell
# Portable
C:/tools/bin/gh.exe auth status
# OR Standard
gh auth status
```

### 4. Publish Your Code
```powershell
cd your-service-directory
C:/tools/bin/gh.exe repo create alvarodiaz-dev/your-service-name `
  --public `
  --source=. `
  --remote=origin `
  --push
```

Done! ✅ Visit: https://github.com/alvarodiaz-dev/your-service-name

## Full Setup Instructions

### Prerequisites Check
Run this to verify everything is ready:

```powershell
# Check GitHub CLI (Portable)
C:/tools/bin/gh.exe --version

# Or Standard installation
gh --version

# Check git
git --version

# Check GitHub auth (Portable)
C:/tools/bin/gh.exe auth status
gh auth status

# Check git config
git config --list
```

### Step-by-Step Setup

#### Step A: Install GitHub CLI

**Windows (PowerShell):**
```powershell
# Via Windows Package Manager (recommended)
winget install GitHub.cli

# Via Scoop
scoop install gh

# Via Chocolatey
choco install gh
```

**macOS:**
```bash
brew install gh
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install gh
# OR
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

#### Step B: Configure Git (if needed)
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Verify
git config --list
```

#### Step C: Authenticate with GitHub

**Option 1: Interactive (Recommended)**
```bash
gh auth login

# Questions:
# 1. Which git service? → GitHub.com
# 2. Protocol? → HTTPS
# 3. Authenticate? → Select based on preference
```

**Option 2: Token-based**
1. Go to https://github.com/settings/tokens/new
2. Create Personal Access Token (Classic)
3. Select scopes: `repo`, `read:org`
4. Copy token
5. Run:
   ```bash
   gh auth login --with-token
   # Paste your token
   ```

#### Step D: Verify Authentication
```bash
gh auth status
```

Expected output:
```
  github.com
    ✓ Logged in to github.com as YourUsername
    → Token: ghu_...
    → Git operations using https protocol
```

## Publishing Workflow

### Automated (Recommended)

**Option 1: One Command (Portable)**
```powershell
cd your-service-directory
C:/tools/bin/gh.exe repo create alvarodiaz-dev/service-name --public --source=. --remote=origin --push
```

**Option 1: One Command (Standard)**
```bash
cd your-service-directory
gh repo create alvarodiaz-dev/service-name --public --source=. --remote=origin --push
```

**Option 2: Step by Step (Portable)**
```powershell
# Go to your service
cd your-service-directory

# Initialize git
git init

# Stage files
git add .

# Commit
git commit -m "Initial commit: ServiceName microservice"

# Create repo on GitHub
C:/tools/bin/gh.exe repo create alvarodiaz-dev/service-name --public --source=. --remote=origin

# Push
git push -u origin main
```

### Manual (Advanced)

```bash
cd your-service-directory

# Initialize
git init
git add .
git commit -m "Initial commit"

# Create empty repo on GitHub via web, then:
git remote add origin https://github.com/alvarodiaz-dev/service-name.git
git branch -M main
git push -u origin main
```

## File Organization

Before publishing, ensure your directory structure:

```
your-service-name/
├── src/
│   ├── YourService.Api/
│   │   ├── Controllers/
│   │   ├── Program.cs
│   │   └── YourService.Api.csproj
│   ├── YourService.Models/
│   └── YourService.Core/
├── .gitignore          ← Important!
├── README.md           ← Required!
├── LICENSE             ← Optional but recommended
└── YourService.sln
```

## Naming Your Repository

Follow GitHub naming conventions:

✅ **Good names:**
- `user-service`
- `order-processing-service`
- `payment-gateway`
- `auth-service`

❌ **Avoid:**
- `UserService` (use lowercase)
- `user_service` (use hyphen)
- `Service123` (avoid numbers)
- `s` (too short)

## Post-Publication

### After Pushing to GitHub

1. **Verify on GitHub (Portable):**
   ```powershell
   C:/tools/bin/gh.exe repo view alvarodiaz-dev/your-service-name
   ```
   
   Or Standard:
   ```bash
   gh repo view alvarodiaz-dev/your-service-name
   ```

2. **Add collaborators** (optional, Portable):
   ```powershell
   C:/tools/bin/gh.exe repo collaborators add alvarodiaz-dev/your-service-name username
   ```

3. **Add to GitHub Project** (optional):
   ```bash
   gh project view --owner alvarodiaz-dev
   ```

4. **Enable branch protection** (optional via web UI):
   - Go to Settings → Branches
   - Add rule for `main`
   - Require pull request reviews

### Cloning Your Repository

```bash
git clone https://github.com/alvarodiaz-dev/your-service-name
cd your-service-name
dotnet build
dotnet run
```

## Troubleshooting

See [SKILL.md](./SKILL.md#common-issues) for common issues and solutions.
