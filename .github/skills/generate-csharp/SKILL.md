---
name: generate-csharp
description: "Generate ASP.NET Core microservice code from structured JSON"
---

## JSON to C# Mapping

| JSON Element | Generated C# | Location |
|--------------|--------------|----------|
| serviceName | Controller class `{ServiceName}Controller` | `Controllers/` |
| endpoints | Controller action methods | Inside controller |
| dataModels | DTO classes `{ModelName}Dto` | `Models/` |
| dataModels | Entity classes `{ModelName}` | `Entities/` |
| externalDependencies | Service interfaces & injections | `Services/` |

## Type Mapping

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

## Project Structure

Each microservice is organized in its own dedicated folder under `services/` to prevent conflicts when generating multiple services. The requirements JSON is stored alongside the source code.

```
services/
├── {ServiceName}/
│   ├── requirements-{ServiceName}.json
│   ├── {ServiceName}Service.sln
│   └── src/
│       ├── {ServiceName}Service.Api/
│       │   ├── Program.cs
│       │   ├── appsettings.json
│       │   ├── Controllers/
│       │   │   └── {ServiceName}Controller.cs
│       │   ├── Properties/
│       │   └── {ServiceName}Service.Api.csproj
│       ├── {ServiceName}Service.Models/
│       │   ├── Models/
│       │   ├── Dtos/
│       │   │   └── *Dto.cs
│       │   ├── Responses/
│       │   └── {ServiceName}Service.Models.csproj
│       └── {ServiceName}Service.Core/
│           ├── Entities/
│           │   └── *.cs
│           ├── Services/
│           │   ├── I{ServiceName}Service.cs
│           │   └── {ServiceName}Service.cs
│           ├── Interfaces/
│           └── {ServiceName}Service.Core.csproj
```

### Directory Organization Benefits

- **Isolation**: Each service has its own namespace to prevent naming conflicts
- **Scalability**: Easy to add multiple microservices without file collisions
- **Maintainability**: Requirements JSON stored with its corresponding service code
- **Clarity**: Clear hierarchy makes it easy to locate service-specific files

## Output

Return: organized file structure with services folder hierarchy, individual code files per service, requirements JSON saved with service files, and summary

