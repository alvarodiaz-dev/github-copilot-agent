# Generate C# Integration Guide

## How the Agent Uses This Skill

### Automatic Detection

The agent loads this skill when it recognizes trigger keywords:
- "Generate C# code from JSON"
- "Create C# microservices"
- "Generate ASP.NET Core"
- "Build C# project scaffold"

## Complete Workflow: From Requirements to Code

### Stage 1: Extract Requirements
```
Your input: requirements.md file
↓
[extract-requirements skill]
↓
Output: requirements.structured.json
```

Example:
```
User: "Extract structured information from my requirements.md file"
Agent: [Extracts and produces JSON with services, endpoints, models]
```

### Stage 2: Generate C# Code
```
Input: requirements.structured.json
↓
[generate-csharp skill]
↓
Output: Complete C# project files
```

Example:
```
User: "Generate C# microservice code from this JSON structure"
Agent: [Generates controllers, services, models, and project layout]
```

## How to Trigger Each Skill

### Method 1: Step-by-Step Manual Process
**Step 1 - Extract:**
```
User: Extract structured information from requirements.md 
      into JSON with ServiceName, Description, Endpoints, DataModels
Agent: [Produces JSON output]
```

**Step 2 - Generate:**
```
User: Now generate C# ASP.NET Core code from this JSON structure
Agent: [Produces C# files]
```

### Method 2: Combined Request (Recommended)
```
User: Extract requirements from requirements.md and generate C# 
      microservice code with controllers and services
Agent: [Can chain both skills or ask which step first]
```

### Method 3: Direct with Specific Framework
```
User: Generate ASP.NET Core microservices with Entity Framework 
      from this JSON requirements file
Agent: [Loads generate-csharp skill automatically]
```

## Output Structure

### What You Get

**1. Project Structure (text diagram)**
```
src/
├── MyService.Api/
├── MyService.Models/
├── MyService.Core/
└── MyService.sln
```

**2. Individual Code Files**
- Controllers/{ServiceName}Controller.cs
- Entities/{Model}.cs
- Models/Dtos/{Model}Dto.cs
- Services/I{Service}Service.cs
- Services/{Service}Service.cs
- Program.cs
- appsettings.json

**3. Namespace Usage**
```
MyProject.Api → API layer
MyProject.Models → DTOs and request/response
MyProject.Core → Business logic and entities
```

## Customization Options

### Change Project Namespace
Default: `MyProject.Services`

To customize, tell the agent:
```
"Generate C# with namespace CompanyName.OrderManagement"
```

### Include/Exclude Components
By default generates: Models + Controllers + Services + Full structure

To customize:
```
"Generate only data models and DTOs"
"Include database context and migrations"
"Generate with repository pattern"
```

### Database Selection
Default: PostgreSQL (Npgsql)

To customize:
```
"Generate with SQL Server"
"Generate with MySQL"
"Generate with Entity Framework Core and SQLite"
```

### Add Additional Patterns
```
"Generate with Repository pattern"
"Include AutoMapper configuration"
"Add FluentValidation for DTOs"
"Include Swagger/OpenAPI documentation"
```

## File Organization

The generated code uses this structure:

```
.Api (ASP.NET Core Web Project)
├── Controllers/       ← HTTP endpoints
├── Program.cs         ← Startup and DI configuration
└── appsettings.json   ← Configuration

.Models (Class Library)
├── Dtos/              ← Request/Response DTOs
└── Responses/         ← Common response types

.Core (Class Library)
├── Entities/          ← Database models
├── Services/          ← Business logic & interfaces
├── Data/              ← DbContext & repositories
└── Interfaces/        ← Service contracts

.sln (Solution File)   ← Ties all projects together
```

## C# Generation Features

✅ **Included by default:**
- REST API controllers with CRUD operations
- Entity models with relationships
- DTO classes for data transfer
- Service interfaces and implementations
- Dependency injection configuration
- Async/await patterns
- Error handling and logging
- HTTP status codes mapping

✅ **Optional (customize):**
- Entity Framework Core setup
- Database migrations
- SQL database context
- Repository pattern
- Fluent validation
- AutoMapper profiles
- OpenAPI/Swagger docs
- Unit test structure

## Examples

### Example 1: Minimal Request
```
User: "Generate C# code from requirements.json"
```
Result: Controllers, DTOs, Services, Program.cs

### Example 2: Specific Framework
```
User: "Generate ASP.NET Core 8 with Entity Framework and PostgreSQL"
```
Result: Full stack with DbContext and migrations

### Example 3: Pattern-Based
```
User: "Generate C# microservices with repository pattern 
       and fluent validation"
```
Result: Repository interfaces, validators, all components

### Example 4: Documentation
```
User: "Generate C# code with Swagger documentation 
       and XML comments on all methods"
```
Result: Code with docs and SwaggerGen configuration

## Troubleshooting

**Skill not triggering?**
- Use keywords: "Generate", "C#", "ASP.NET", "microservice"
- Example: "Generate C# microservice code"

**Want to modify generated code?**
- The output is copy-paste ready
- Edit namespaces, class names, methods as needed
- Ask agent to regenerate with different parameters

**Need different code structure?**
- Specify the pattern: "Repository pattern", "CQRS", "Onion architecture"
- Specify database: "SQL Server", "PostgreSQL", "SQLite"
- Specify validation: "FluentValidation", "DataAnnotations"

## Next Steps After Generation

1. **Copy files** to your Visual Studio project
2. **Install NuGet packages:**
   ```
   dotnet add package Microsoft.EntityFrameworkCore
   dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL
   ```
3. **Configure connection string** in appsettings.json
4. **Create migrations:**
   ```
   dotnet ef migrations add Initial
   dotnet ef database update
   ```
5. **Run the service:**
   ```
   dotnet run
   ```
6. **Test endpoints** at `https://localhost:5001/swagger`
