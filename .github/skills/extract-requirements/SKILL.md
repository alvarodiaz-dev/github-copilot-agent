---
name: extract-requirements
description: "Use when: parsing requirements files to extract & structure microservice details into JSON (ServiceName, Description, Endpoints, DataModels, ExternalDependencies)"
---

# Extract Requirements Skill

Systematically parse requirements files (plain text, markdown) and extract structured microservice information into JSON schema format.

## When to Use This Skill

- You have requirements.txt, requirements.md, or similar documentation defining microservice specifications
- You need to convert unstructured requirements into machine-readable JSON
- Building microservice configurations or API specifications from documentation
- Organizing microservice metadata for downstream tools or workflows

## Workflow

### Step 1: Identify the Requirements File
- Locate the requirements file in your workspace (typically `requirements.md`, `requirements.txt`, or similar)
- Note the file format (markdown, plain text) and location

### Step 2: Extract Key Fields
Parse the document for these fields:

| Field | Description | Pattern |
|-------|-------------|---------|
| **ServiceName** | Name of the microservice | Usually a heading or bold text |
| **Description** | Purpose and overview | First paragraph after service name |
| **Endpoints** | API routes/endpoints | Lines starting with `/`, `GET`, `POST`, etc. |
| **DataModels** | Data structures, schemas | Code blocks, data type definitions |
| **ExternalDependencies** | External services, APIs, databases | "depends on", "requires", "integrates with" |

### Step 3: Structure Output
Produce JSON following this schema:

```json
{
  "services": [
    {
      "serviceName": "string",
      "description": "string",
      "endpoints": [
        {
          "method": "GET|POST|PUT|DELETE",
          "path": "string",
          "description": "string"
        }
      ],
      "dataModels": [
        {
          "name": "string",
          "fields": ["field1: type", "field2: type"]
        }
      ],
      "externalDependencies": ["service1", "service2"]
    }
  ]
}
```

### Step 4: Validate Extraction
- Confirm all services are captured
- Verify endpoint methods and paths are correctly identified
- Check that data model fields are complete
- Ensure dependencies list all external integrations

### Step 5: Return JSON Output
Return the extracted JSON schema. This output can be:
- Saved as `requirements.structured.json`
- Passed to the C# Microservice Generator agent
- Used for further processing or analysis

## Example

**Input (requirements.md):**
```
## UserService
Manages user authentication and profiles.

### Endpoints
- GET /users/{id} - Retrieve user by ID
- POST /users - Create new user
- PUT /users/{id} - Update user

### Data Models
User: id (UUID), name (string), email (string)

### Dependencies
- AuthDB (PostgreSQL)
- EmailService
```

**Output (JSON):**
```json
{
  "services": [
    {
      "serviceName": "UserService",
      "description": "Manages user authentication and profiles.",
      "endpoints": [
        {"method": "GET", "path": "/users/{id}", "description": "Retrieve user by ID"},
        {"method": "POST", "path": "/users", "description": "Create new user"},
        {"method": "PUT", "path": "/users/{id}", "description": "Update user"}
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

## Tips

- **Multi-service files**: If one file contains multiple services, extract each service as a separate object in the `services` array
- **Incomplete data**: If a field is missing from requirements, use `null` or omit it
- **Nested dependencies**: List only direct dependencies; mark database connections as separate from service dependencies
- **Formatting flexibility**: Requirements may vary in format; extract the **intent** rather than exact structure

## Integration with Agents

This skill is automatically invoked when you ask the agent to:
- "Extract requirements from [file]"
- "Structure this requirements file into JSON"
- "Parse requirements and organize microservice details"

The agent recognizes these trigger phrases in the skill description and loads this workflow automatically.
