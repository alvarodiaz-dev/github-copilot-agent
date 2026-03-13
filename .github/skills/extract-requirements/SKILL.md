---
name: extract-requirements
description: "Parse requirements files and extract microservice details into JSON"
---

## Output Schema

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

## Fields to Extract

- **ServiceName**: microservice name
- **Description**: service purpose
- **Endpoints**: API routes with method, path, description
- **DataModels**: data structures with fields and types
- **ExternalDependencies**: external services, APIs, databases

## Output and Storage

### JSON File Naming
Each extracted service should be saved as a separate JSON file:
- **Filename**: `requirements-{ServiceName}.json`
- **Location**: `services/{ServiceName}/requirements-{ServiceName}.json`

### Folder Structure
```
services/
├── {ServiceName1}/
│   └── requirements-{ServiceName1}.json
├── {ServiceName2}/
│   └── requirements-{ServiceName2}.json
└── {ServiceName3}/
    └── requirements-{ServiceName3}.json
```

