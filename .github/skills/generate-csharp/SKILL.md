---
name: generate-csharp
description: "Use when: generating ASP.NET Core microservice code from structured JSON (models, controllers, services, project structure)"
---

# Generate C# Skill

Transforms structured JSON requirements into complete ASP.NET Core microservice code including models, controllers, services, and full project structure.

## When to Use This Skill

- You have JSON extracted from requirements (via extract-requirements skill)
- You need to generate ASP.NET Core controllers, DTOs, and service classes
- Building a complete microservice project scaffold from specifications
- Converting API specifications into working C# code

## Workflow

### Step 1: Prepare JSON Input
Ensure your JSON follows this schema (output from extract-requirements skill):

```json
{
  "services": [
    {
      "serviceName": "UserService",
      "description": "Manages user authentication and profiles",
      "endpoints": [
        {"method": "GET", "path": "/users/{id}", "description": "Retrieve user"},
        {"method": "POST", "path": "/users", "description": "Create user"}
      ],
      "dataModels": [
        {
          "name": "User",
          "fields": ["id: UUID", "name: string", "email: string"]
        }
      ],
      "externalDependencies": ["AuthDB", "EmailService"]
    }
  ]
}
```

### Step 2: Map JSON to C# Code

For each service in the JSON, generate:

| JSON Element | Generated C# | Location |
|--------------|--------------|----------|
| serviceName | Controller class `{ServiceName}Controller` | `Controllers/` |
| endpoints | Controller action methods | Inside controller |
| dataModels | DTO classes `{ModelName}Dto` | `Models/` |
| dataModels | Entity classes `{ModelName}` | `Entities/` |
| externalDependencies | Service interfaces & injections | `Services/` |

### Step 3: Generate Models/DTOs

For each model, create:

**Entity class** (`Entities/User.cs`):
```csharp
namespace MyProject.Services.Entities
{
    public class User
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
    }
}
```

**DTO class** (`Models/UserDto.cs`):
```csharp
namespace MyProject.Services.Models
{
    public class UserDto
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
    }
}
```

### Step 4: Generate Controller

Create controller with action methods matching endpoints:

```csharp
namespace MyProject.Services.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UserServiceController : ControllerBase
    {
        private readonly IUserService _service;

        public UserServiceController(IUserService service)
        {
            _service = service;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<UserDto>> GetUser(Guid id)
        {
            var user = await _service.GetUserAsync(id);
            if (user == null)
                return NotFound();
            return Ok(user);
        }

        [HttpPost]
        public async Task<ActionResult<UserDto>> CreateUser([FromBody] CreateUserDto dto)
        {
            var user = await _service.CreateUserAsync(dto);
            return CreatedAtAction(nameof(GetUser), new { id = user.Id }, user);
        }
    }
}
```

### Step 5: Generate Service Interface and Implementation

**Service Interface** (`Services/IUserService.cs`):
```csharp
namespace MyProject.Services.Services
{
    public interface IUserService
    {
        Task<UserDto> GetUserAsync(Guid id);
        Task<UserDto> CreateUserAsync(CreateUserDto dto);
    }
}
```

**Service Implementation** (`Services/UserService.cs`):
```csharp
namespace MyProject.Services.Services
{
    public class UserService : IUserService
    {
        private readonly ILogger<UserService> _logger;
        private readonly IAuthService _authService;
        private readonly IEmailService _emailService;

        public UserService(
            ILogger<UserService> logger,
            IAuthService authService,
            IEmailService emailService)
        {
            _logger = logger;
            _authService = authService;
            _emailService = emailService;
        }

        public async Task<UserDto> GetUserAsync(Guid id)
        {
            _logger.LogInformation($"Retrieving user {id}");
            // Implementation
            return new UserDto { Id = id };
        }

        public async Task<UserDto> CreateUserAsync(CreateUserDto dto)
        {
            _logger.LogInformation($"Creating user {dto.Name}");
            // Implementation
            return new UserDto { Id = Guid.NewGuid(), Name = dto.Name };
        }
    }
}
```

### Step 6: Generate Project Structure

Create complete project organization:

```
src/
├── MyProject.Services.Api/
│   ├── Program.cs
│   ├── appsettings.json
│   ├── Controllers/
│   │   └── UserServiceController.cs
│   └── Properties/
│       └── launchSettings.json
├── MyProject.Services.Models/
│   ├── Dtos/
│   │   ├── UserDto.cs
│   │   └── CreateUserDto.cs
│   └── Responses/
│       └── ApiResponse.cs
├── MyProject.Services.Core/
│   ├── Entities/
│   │   └── User.cs
│   ├── Services/
│   │   ├── IUserService.cs
│   │   └── UserService.cs
│   └── Interfaces/
│       └── [service interfaces]
└── MyProject.Services.sln
```

### Step 7: Generate Dependency Injection Setup

Create `Program.cs` with DI container configuration:

```csharp
var builder = WebApplicationBuilder.CreateBuilder(args);

// Add services
builder.Services.AddControllers();
builder.Services.AddScoped<IUserService, UserService>();
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<IEmailService, EmailService>();

// Add DbContext if database dependency exists
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

app.UseHttpsRedirection();
app.UseRouting();
app.UseAuthorization();

app.MapControllers();
app.Run();
```

## Type Mapping

Convert JSON field types to C# types:

| JSON Type | C# Type |
|-----------|---------|
| string | `string` |
| UUID | `Guid` |
| timestamp | `DateTime` |
| boolean | `bool` |
| integer | `int` |
| number | `decimal` or `double` |
| array | `List<T>` |
| object | Custom class |

## Output Format

Return the generated code as:
1. **Organized file structure** (project layout)
2. **Individual code files** (copy-paste ready)
3. **Summary** with file count and namespaces used

## Tips

- **Naming convention:** Use PascalCase for classes (UserService, not user_service)
- **Namespaces:** `MyProject.Services.*` as base (adjustable)
- **Null safety:** Add null checks and validation
- **Async/await:** Use async patterns for I/O operations
- **Logging:** Inject `ILogger<T>` in services
- **DTOs:** Separate request/response DTOs from entities
- **Dependencies:** For each external dependency, create a service interface

## Integration with Extract-Requirements Skill

This skill works **downstream** of extract-requirements:

```
requirements.md
    ↓
[extract-requirements skill]
    ↓
requirements.structured.json
    ↓
[generate-csharp skill] ← You are here
    ↓
Generated C# microservice files
```

## Invocation Triggers

The agent automatically loads this skill when you ask:
- "Generate C# code from this JSON"
- "Create C# microservices from requirements"
- "Generate ASP.NET Core services from JSON structure"
- "Build C# project scaffold from requirements"
