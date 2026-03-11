# 🚀 Microservice Generator Toolkit

Complete automated solution for generating ASP.NET Core microservices from requirements and publishing to GitHub.

## 📦 What's Included

### 3 Reusable Skills
1. **extract-requirements** - Parses markdown requirements → Structured JSON
2. **generate-csharp** - JSON → Full ASP.NET Core project scaffold
3. **publish-to-github** - Git + GitHub CLI → Published repository

### 1 Custom Agent
- **C# Microservice Generator** - Orchestrates entire workflow

### Documentation
- **WORKFLOW.md** - Complete end-to-end guide
- **Individual skill documentation** - Detailed references

---

## ⚡ Quick Start (5 minutes)

### 1️⃣ Prerequisites
```powershell
# For Portable GitHub CLI (no admin required)
Test-Path C:/tools/bin/gh.exe
C:/tools/bin/gh.exe auth login
C:/tools/bin/gh.exe auth status

# OR For Standard Installation
winget install GitHub.cli
gh auth login
gh auth status
```

### 2️⃣ Prepare Requirements
Create `requirements.md`:

```markdown
# UserService Microservice

Manages user authentication and profiles.

## Endpoints
- GET /users/{id} - Get user
- POST /users - Create user

## Data Models
User: id (UUID), name (string), email (string)

## External Dependencies
- AuthDB (PostgreSQL)
```

### 3️⃣ Run the Agent
Ask in VS Code Copilot Chat:
```
"Generate microservices from my requirements.md and publish to GitHub"
```

### 4️⃣ Done! 🎉
- C# code generated ✅
- Project pushed to GitHub ✅
- Available at: https://github.com/alvarodiaz-dev/user-service ✅

---

## 🎯 Usage Patterns

### Pattern 1: Full Automation
**Ask the agent:**
```
"Extract requirements from requirements.md, generate C# microservices, 
and publish everything to GitHub under alvarodiaz-dev organization"
```

**Result:** Complete workflow from your requirements to live GitHub repositories

### Pattern 2: Step-by-Step Control
**Step 1:**
```
"Extract requirements from requirements.md into JSON"
```

**Step 2:**
```
"Generate C# code from this JSON structure"
```

**Step 3:**
```
"Publish the generated code to GitHub"
```

### Pattern 3: Just Publishing
If you have existing C# code:
```
"Publish this C# project to GitHub as alvarodiaz-dev/my-service"
```

---

## 📁 Directory Structure

```
.github/
├── skills/
│   ├── extract-requirements/      ← Parse requirements
│   │   ├── SKILL.md               ← Main workflow
│   │   ├── TEMPLATE.md            ← Format examples
│   │   └── USAGE.md               ← Integration guide
│   ├── generate-csharp/           ← Generate code
│   │   ├── SKILL.md               ← Main workflow
│   │   ├── TEMPLATE.md            ← Code examples
│   │   ├── USAGE.md               ← Integration
│   │   └── TYPES.md               ← Type mapping
│   └── publish-to-github/         ← Publish to GitHub
│       ├── SKILL.md               ← Main workflow
│       ├── SETUP.md               ← Prerequisites
│       └── EXAMPLES.md            ← Publishing examples
├── agents/
│   └── microservice-generator.agent.md  ← Master agent
└── WORKFLOW.md                    ← Complete guide
```

---

## 🔍 How It Works

### Skill 1: Extract Requirements
**Input:** requirements.md
```markdown
## UserService
Manages users.
- GET /users/{id}
- POST /users
User: id UUID, name string
```

**Output:** Structured JSON
```json
{
  "services": [{
    "serviceName": "UserService",
    "endpoints": [
      {"method": "GET", "path": "/users/{id}"}
    ],
    "dataModels": [
      {"name": "User", "fields": ["id: UUID", "name: string"]}
    ]
  }]
}
```

### Skill 2: Generate C# Code
**Input:** Structured JSON

**Output:** Complete project
```
src/
├── UserService.Api/
│   ├── Program.cs
│   └── Controllers/UserServiceController.cs
├── UserService.Models/
│   └── Dtos/UserDto.cs
└── UserService.Core/
    ├── Entities/User.cs
    └── Services/UserService.cs
```

### Skill 3: Publish to GitHub
**Input:** Generated C# project

**Output:** Published repository
```
✅ Repository: https://github.com/alvarodiaz/user-service
✅ Code pushed to main branch
✅ Ready to clone and run
```

---

## 🎓 Examples

### Example 1: Generate Single Microservice
```
requirements.md:
- OrderService with 4 endpoints  
- 2 data models (Order, OrderItem)
- Dependencies: PaymentService, InventoryService

Result:
- OrderServiceController.cs
- OrderService + OrderItemService
- Order + OrderItem entities
- GitHub repo: alvarodiaz/order-service
```

### Example 2: Generate Multiple Microservices
```
requirements.md contains:
- UserService
- OrderService
- PaymentService

Result:
- 3 separate GitHub repositories
- Each with full ASP.NET Core structure
- All published under alvarodiaz/
```

---

## 🛠️ Advanced Usage

### Customize Code Generation
```
"Generate C# with Repository pattern and Entity Framework Core"
```

### Use Specific Database
```
"Generate ASP.NET Core services with SQL Server and EF Core"
```

### Private Repositories
```
"Publish to GitHub as private repositories"
```

### Add CI/CD
```
"Generate with GitHub Actions workflows for CI/CD"
```

---

## 📖 Full Documentation

For detailed information, see:

| Document | Purpose |
|----------|---------|
| [WORKFLOW.md](./WORKFLOW.md) | Complete end-to-end guide |
| [extract-requirements/SKILL.md](./skills/extract-requirements/SKILL.md) | Parsing methodology |
| [generate-csharp/SKILL.md](./skills/generate-csharp/SKILL.md) | Code generation details |
| [publish-to-github/SKILL.md](./skills/publish-to-github/SKILL.md) | Publishing workflow |
| [generate-csharp/TYPES.md](./skills/generate-csharp/TYPES.md) | JSON ↔ C# type mapping |
| [publish-to-github/SETUP.md](./skills/publish-to-github/SETUP.md) | GitHub CLI setup |

---

## ⚙️ Configuration

### GitHub Organization
Edit in `.github/agents/microservice-generator.agent.md`:
```yaml
organization: "alvarodiaz-dev"  ← Currently set to this
```

### Naming Convention
Repositories are created as:
- Input: `UserService`
- Output: `alvarodiaz-dev/user-service` (lowercase)

### Namespace
Generated C# uses:
- Default: `MyProject.Services.*`
- Customizable per generation

---

## 🚨 Troubleshooting

### GitHub CLI not found
```powershell
# Check portable installation
Test-Path C:/tools/bin/gh.exe

# If not available, install standard version
winget install GitHub.cli
# Restart terminal after install
```

### Not authenticated to GitHub
```powershell
# Portable version
C:/tools/bin/gh.exe auth login

# Or standard version
gh auth login
# Follow prompts to authenticate
```

### Repository already exists
```powershell
# Use different name or delete existing (portable):
C:/tools/bin/gh.exe repo delete alvarodiaz-dev/user-service

# Or standard version
gh repo delete alvarodiaz-dev/user-service
# Then try again
```

### Agent not recognizing skill
- Refresh VS Code
- Ensure YAML frontmatter in SKILL.md is correct
- Check skill is in correct directory: `.github/skills/{name}/`

---

## 🎯 Next Steps

1. **Setup prerequisites** (5 min)
   - GitHub CLI already ready (portable at `C:/tools/bin/gh.exe`)
   - Verify: `C:/tools/bin/gh.exe auth status`

2. **Create requirements** (10 min)
   - Write requirements.md with your microservices

3. **Run generator** (2 min)
   - Ask the agent to generate and publish

4. **Clone and develop** (ongoing)
   - Clone repository: `git clone https://github.com/alvarodiaz-dev/...`
   - Start writing business logic

---

## 📞 Support

For issues or questions:
1. Check [WORKFLOW.md](./WORKFLOW.md) for detailed examples
2. Review skill documentation in `./skills/{skill-name}/`
3. See [Troubleshooting](./WORKFLOW.md#troubleshooting) section

---

## ✨ Features

✅ **Automated Workflow**
- Extract → Generate → Publish in one command

✅ **ASP.NET Core**
- Latest .NET 8.0 best practices
- Dependency injection setup
- Entity Framework Core ready

✅ **Production Ready**
- Controllers, services, models
- Logging, error handling
- Configuration templates
- .gitignore, Docker support

✅ **GitHub Integration**
- Automated repository creation
- Automatic code push
- Uses GitHub CLI (`C:/tools/bin/gh.exe` portable or `gh` standard)

✅ **Type Safe**
- JSON → C# type mapping
- Null safety (C# 8.0+)
- Data validation ready

---

Enjoy building microservices! 🚀
