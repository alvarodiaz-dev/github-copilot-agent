# Publishing to GitHub: Examples

## Example 1: Simple Service

### Input
Generated C# microservice in local directory

### Command
```powershell
cd ./generated/UserService
C:/tools/bin/gh.exe repo create alvarodiaz-dev/user-service `
  --public `
  --source=. `
  --remote=origin `
  --push
```

### Result
```
✅ Created repository alvarodiaz-dev/user-service on GitHub
✅ Files pushed to https://github.com/alvarodiaz-dev/user-service
```

## Example 2: Multiple Services

### Scenario
Generated multiple microservices, need to publish each

### Script (PowerShell)
```powershell
# GitHub CLI portable path
$ghPath = "C:/tools/bin/gh.exe"

$services = @(
    @{Name="UserService"; Dir="./generated/UserService"},
    @{Name="OrderService"; Dir="./generated/OrderService"},
    @{Name="PaymentService"; Dir="./generated/PaymentService"}
)

foreach ($service in $services) {
    $repoName = $service.Name.ToLower() -replace "service$", "-service"
    
    Write-Host "Publishing $($service.Name)..."
    Push-Location $service.Dir
    
    & $ghPath repo create "alvarodiaz-dev/$repoName" `
      --public `
      --source=. `
      --remote=origin `
      --push
    
    Pop-Location
    Write-Host "✅ Published to https://github.com/alvarodiaz-dev/$repoName`n"
}
```

## Example 3: Private Repository

For private repositories:

```powershell
$ghPath = "C:/tools/bin/gh.exe"
cd ./generated/MyService
& $ghPath repo create alvarodiaz-dev/my-service `
  --private `
  --source=. `
  --remote=origin `
  --push
```

## Example 4: With Custom Description

GitHub CLI doesn't embed description, but you can add via:

```powershell
# After publishing (portable)
$ghPath = "C:/tools/bin/gh.exe"
& $ghPath repo edit alvarodiaz-dev/user-service `
  --description "ASP.NET Core microservice for user management" `
  --homepage "https://github.com/alvarodiaz-dev/user-service" `
  --add-topic microservice `
  --add-topic csharp `
  --add-topic aspnet-core
```

## Example 5: Adding README Before Publishing

Ensure README.md exists before publishing:

**README.md**
```markdown
# User Service

RESTful microservice for user management and authentication.

## Features
- User CRUD operations
- JWT authentication
- Email verification
- Role-based access control

## Quick Start

### Prerequisites
- .NET 8.0 SDK
- PostgreSQL 14+

### Build
\`\`\`bash
dotnet build
\`\`\`

### Run
\`\`\`bash
dotnet run --project src/UserService.Api
\`\`\`

API available at: http://localhost:5000/swagger

## Project Structure
- `src/UserService.Api/` - ASP.NET Core Web API
- `src/UserService.Core/` - Business logic and entities
- `src/UserService.Models/` - DTOs and response models

## Documentation
- [API Endpoints](./docs/ENDPOINTS.md)
- [Database Schema](./docs/DATABASE.md)
- [Configuration Guide](./docs/CONFIG.md)

## Contributing
[Guidelines for contributing to this project]

## License
MIT License - See LICENSE file
```

Then publish:
```bash
cd ./generated/UserService
gh repo create alvarodiaz-dev/user-service \
  --public \
  --source=. \
  --remote=origin \
  --push
```

## Example 6: Complete Automated Workflow

### Using Agent + Skill Together

**What you ask:**
```
"Extract requirements from requirements.md, generate C# microservices, 
and publish them all to GitHub as alvarodiaz/service-name"
```

**What happens:**
1. extract-requirements skill → Parses requirements.md to JSON
2. generate-csharp skill → Creates ASP.NET Core projects
3. publish-to-github skill → Creates repos and pushes code
4. Result: Live repositories on GitHub with all code

**Verification:**
```bash
# List your new repositories
gh repo list alvarodiaz --limit 10
```

## Verification Commands

After publishing:

```bash
# View repository
gh repo view alvarodiaz-dev/user-service

# Get repository URL
gh repo view alvarodiaz-dev/user-service --json url -q '.url'

# Check recent commits
git -C ~/Downloads/user-service log --oneline -5

# List files in main branch
gh repo view alvarodiaz-dev/user-service --json nameWithOwner

# Check repository size
gh api repos/alvarodiaz-dev/user-service --jq '.size'
```

## Quick Reference

| Task | Command |
|------|---------|
| View repo | `gh repo view alvarodiaz-dev/user-service` |
| Clone repo | `git clone https://github.com/alvarodiaz-dev/user-service` |
| Add collaborator | `gh repo collaborators add alvarodiaz-dev/user-service username` |
| Edit settings | `gh repo edit alvarodiaz-dev/user-service --description "..."` |
| Create issue | `gh issue create --repo alvarodiaz-dev/user-service --title "..."` |
| Delete repo | `gh repo delete alvarodiaz-dev/user-service` |
| List all repos | `gh repo list alvarodiaz-dev` |
