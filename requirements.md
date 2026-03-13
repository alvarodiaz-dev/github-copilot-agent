# Microservice Requirements

## AuthService

### Purpose
Handles basic user authentication for the system. Allows users to register and log in.

### Endpoints

- POST /auth/register - Register a new user
- POST /auth/login - Log in with email and password
- GET /auth/users - List registered users

### Data Models

**User**
- id: UUID
- email: string
- password: string

**RegisterRequest**
- email: string
- password: string

**LoginRequest**
- email: string
- password: string

**LoginResponse**
- token: string
- userId: UUID

### External Dependencies
- PostgreSQL Database
- JWT Authentication