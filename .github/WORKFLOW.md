# Complete Microservice Generation Workflow

This document shows the complete end-to-end workflow: Requirements → C# Code → GitHub Push

## 🎯 Complete Pipeline

```
Your Requirements (requirements.md)
    ↓
[1️⃣ extract-requirements skill]    ← Parses and structures
    ↓
Structured JSON (requirements.json)
    ↓
[2️⃣ generate-csharp skill]          ← Generates C# code
    ↓
ASP.NET Core Project Files
    ↓
[3️⃣ publish-to-github skill]        ← Pushes to GitHub
    ↓
🚀 Live on GitHub: https://github.com/alvarodiaz-dev/service-name
```

## 🚀 Option 1: Use the Custom Agent (Recommended)

The **C# Microservice Generator** agent orchestrates the entire flow:

### Command
```
"Generate microservices from my requirements.md file and publish to GitHub"
```

### What It Does Automatically
1. ✅ Extracts requirements from requirements.md
2. ✅ Converts to structured JSON
3. ✅ Generates full C# ASP.NET Core code
4. ✅ Creates project structure with controllers, services, models
5. ✅ Generates README and infrastructure files
6. ✅ Initializes git repository
7. ✅ Creates GitHub repository under `alvarodiaz-dev/`
8. ✅ Pushes all code to GitHub

### Result
- Complete project on GitHub
- All services published
- Ready to clone and run

---

## 🔧 Option 2: Manual Step-by-Step (Maximum Control)

Use individual skills for more control:

### Step 1: Extract Requirements

**Ask the agent:**
```
"Extract structured information from my requirements.md file 
into JSON format with ServiceName, Description, Endpoints, 
DataModels, and ExternalDependencies"
```

**Agent uses:** `extract-requirements` skill

**You get:** Structured JSON output

**Example output:**
```json
{
  "services": [
    {
      "serviceName": "UserService",
      "description": "Manages users and authentication",
      "endpoints": [
        {"method": "GET", "path": "/users/{id}"},
        {"method": "POST", "path": "/users"}
      ],
      "dataModels": [
        {"name": "User", "fields": ["id: UUID", "email: string"]}
      ],
      "externalDependencies": ["AuthDB"]
    }
  ]
}
```

### Step 2: Generate C# Code

**Ask the agent:**
```
"Generate ASP.NET Core microservice code from this JSON structure 
with controllers, services, and full project layout"
```

**Agent uses:** `generate-csharp` skill

**You get:** 
- Controllers/{ServiceName}Controller.cs
- Services/I{Service}Service.cs
- Services/{Service}Service.cs  
- Models/Dtos/{Model}Dto.cs
- Entities/{Model}.cs
- Program.cs
- appsettings.json
- Complete project structure

### Step 3: Publish to GitHub

**Ask the agent or run command:**
```
"Publish this generated code to GitHub as alvarodiaz-dev/user-service"
```

**Or manually:**
```powershell
cd ./generated/UserService
C:/tools/bin/gh.exe repo create alvarodiaz-dev/user-service `
  --public `
  --source=. `
  --remote=origin `
  --push
```

**Agent uses:** `publish-to-github` skill

**You get:** 
- ✅ Repository created at https://github.com/alvarodiaz-dev/user-service
- ✅ All code pushed to main branch
- ✅ Ready to clone: `git clone https://github.com/alvarodiaz-dev/user-service`

---

## 📋 Prerequisites Checklist

Before you start, ensure you have:

### Required
- [ ] VS Code and Copilot Chat
- [ ] `requirements.md` file with microservice specs
- [ ] GitHub account
- [ ] GitHub CLI installed (`C:/tools/bin/gh.exe --version` or `gh --version`)
- [ ] GitHub CLI authenticated (`C:/tools/bin/gh.exe auth status` or `gh auth login`)
- [ ] Git configured with name/email:
  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "your@email.com"
  ```

### Optional
- [ ] Docker (for containerization)
- [ ] .NET 8 SDK (to run generated code locally)
- [ ] SQL Server/PostgreSQL (if database integration needed)

---

## 📝 Example Workflow

### Your requirements.md:
```markdown
# OrderService Microservice

## Purpose
Manages customer orders and order fulfillment workflows.

## Endpoints
- GET /orders/{id} - Get order details
- POST /orders - Create new order
- PUT /orders/{id}/status - Update order status
- DELETE /orders/{id} - Cancel order

## Data Models
Order: id (UUID), customerId (UUID), totalAmount (decimal), status (string), createdAt (timestamp)
OrderItem: id (UUID), orderId (UUID), productId (UUID), quantity (int), price (decimal)

## External Dependencies
- PaymentService
- InventoryService  
- OrderDatabase (PostgreSQL)
```

### Your Commands:

**All at once:**
```
"Extract requirements from requirements.md, generate C# microservices, 
and publish to GitHub"
```

OR

**Step by step:**

1️⃣ Extract:
```
"Extract requirements from my requirements.md"
```

2️⃣ Generate:
```
"Generate C# ASP.NET Core code from the extracted requirements"
```

3️⃣ Publish:
```
"Publish the generated code to GitHub as alvarodiaz-dev/order-service"
```

### Agent Output:

```
✅ Requirements Extracted
   - 1 service (OrderService)
   - 4 endpoints
   - 2 data models
   - 3 dependencies

✅ Code Generated  
   - Controllers: OrderServiceController.cs
   - Services: OrderService.cs
   - Models: OrderDto.cs, OrderItemDto.cs, CreateOrderDto.cs
   - Entities: Order.cs, OrderItem.cs
   - Infrastructure: Program.cs, appsettings.json
   - Files: 12 total

✅ Published to GitHub
   - Repository: https://github.com/alvarodiaz-dev/order-service
   - Branch: main
   - All files committed and pushed

📋 Quick Start
git clone https://github.com/alvarodiaz-dev/order-service
cd order-service
dotnet build
dotnet run

🔗 Repository: https://github.com/alvarodiaz-dev/order-service

📚 Key Files
- Controllers/OrderServiceController.cs - API endpoints
- Services/OrderService.cs - Business logic
- Models/Dtos/*.cs - Data transfer objects
- Entities/ - Database models
- README.md - Full documentation
```

---

## 🔄 Workflow Variations

### Variation A: Single Service
```
requirements.md (1 service)
    ↓ extract
requirements.json
    ↓ generate
1 C# project
    ↓ publish
1 GitHub repository
```

### Variation B: Multiple Services
```
requirements.md (3 services)
    ↓ extract
requirements.json (3 services)
    ↓ generate
3 C# projects
    ↓ publish
3 separate GitHub repositories
```

### Variation C: Microservices with Shared Models
```
requirements.md (shared + individual services)
    ↓ extract
requirements.json (with dependencies marked)
    ↓ generate
Shared library + multiple services
    ↓ publish
1 shared repo + N service repos
```

---

## 🛠️ Troubleshooting

### Agent not extracting requirements?
```
✓ Use keywords: "extract", "parse", "structure", "requirements"
✓ Example: "Extract structured information from requirements.md"
→ Agent loads extract-requirements skill automatically
```

### Agent not generating C# code?
```
✓ Use keywords: "generate", "C#", "ASP.NET", "create code"
✓ Example: "Generate C# microservice code from JSON"
→ Agent loads generate-csharp skill automatically
```

### Agent not pushing to GitHub?
```
✓ Use keywords: "publish", "GitHub", "push", "create repo"
✓ Example: "Publish this code to GitHub"
→ Agent loads publish-to-github skill automatically
✓ Ensure: gh auth status shows you're logged in
```

---

## 📚 Reference Documents

### Skills Directory
- [extract-requirements](./skills/extract-requirements/SKILL.md) - Parse requirements
- [generate-csharp](./skills/generate-csharp/SKILL.md) - Generate C# code
- [publish-to-github](./skills/publish-to-github/SKILL.md) - Publish to GitHub

### Agent
- [C# Microservice Generator](./agents/microservice-generator.agent.md) - Orchestrates entire workflow

### Setup
- [GitHub CLI Setup](./skills/publish-to-github/SETUP.md) - Prerequisites for publishing
- [Type Mapping](./skills/generate-csharp/TYPES.md) - JSON to C# types

### Templates
- [Extract-Requirements Template](./skills/extract-requirements/TEMPLATE.md) - Format examples
- [Generate-C# Template](./skills/generate-csharp/TEMPLATE.md) - Code generation examples
- [Publish Examples](./skills/publish-to-github/EXAMPLES.md) - GitHub publishing examples

---

## ✨ Next Steps

1. **Prepare requirements.md** with your microservice specs
2. **Run the agent:** Ask for complete microservice generation
3. **Verify on GitHub:** Visit https://github.com/alvarodiaz-dev/your-service
4. **Clone locally:** Start developing

Enjoy your automated microservice workflow! 🚀
