# Requirements Extraction Template

Use this template when extracting information from requirements files. Copy, fill in your details, and return the JSON to get structured output.

## Requirements File Template

Add this to your requirements.md or create a structured template:

```markdown
# Microservice Requirements

## [ServiceName]
**Description:** [Purpose and overview]

### Endpoints
- [METHOD] [PATH] - [Description]
- Example: GET /api/users/{id} - Retrieve user by ID

### Data Models
[ModelName]: 
  - field1: type
  - field2: type
  
Example:
User:
  - id: UUID
  - email: string
  - createdAt: timestamp

### External Dependencies
- [ServiceName or System]
- Example: PostgreSQL Database, AuthService, PaymentGateway
```

## Extraction Checklist

When parsing requirements, verify:

- [ ] All services/microservices identified
- [ ] Name is clear and follows naming conventions (PascalCase preferred)
- [ ] Description captures the main purpose (1-2 sentences)
- [ ] All endpoints listed with HTTP method
- [ ] All data models identified with their fields and types
- [ ] External dependencies clearly marked (databases, APIs, services)
- [ ] No duplicate endpoints or services

## Common Patterns

### Endpoints in Different Formats
**Markdown list style:**
```
- GET /users - List all users
- POST /users - Create new user
```

**OpenAPI style:**
```
GET /api/users/{id}
POST /api/users
```

**Table style:**
| Method | Path | Description |
|--------|------|-------------|
| GET | /users | List users |

**Pattern:** Extract `METHOD`, `PATH`, and `DESCRIPTION` regardless of format.

### Data Models in Different Formats
**Bullet points:**
```
User: id (UUID), name (string), email (email)
```

**Code block:**
```
class User {
  UUID id;
  String name;
  String email;
}
```

**YAML:**
```yaml
User:
  id: UUID
  name: string
  email: email
```

**Pattern:** Extract field names and types in the format `fieldname: type`.

## How to Trigger the Skill

In your chat:
1. **Direct invocation:** `/extract-requirements` (if available as slash command)
2. **Natural language:** "Extract and structure this requirements file" 
3. **With agent:** Ask the microservice generator agent to use this skill first

The agent automatically recognizes the trigger phrases and loads this workflow.
