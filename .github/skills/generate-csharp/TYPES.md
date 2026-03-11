# Type Mapping Reference

This document shows how JSON types are converted to C# types during code generation.

## Basic Type Mapping

| JSON Type | C# Type | Example |
|-----------|---------|---------|
| `string` | `string` | `"John"` → `string Name { get; set; }` |
| `UUID` | `Guid` | `"550e8400-e29b-41d4-a716-446655440000"` → `Guid Id { get; set; }` |
| `guid` | `Guid` | Same as UUID |
| `integer` | `int` | `42` → `int Quantity { get; set; }` |
| `int64` | `long` | `9223372036854775807L` → `long Count { get; set; }` |
| `number` | `decimal` | `99.99` → `decimal Price { get; set; }` |
| `float` | `float` | `3.14f` → `float Rating { get; set; }` |
| `boolean` | `bool` | `true` → `bool IsActive { get; set; }` |
| `date` | `DateTime` | `"2024-03-11"` → `DateTime CreatedDate { get; set; }` |
| `timestamp` | `DateTime` | `"2024-03-11T10:30:00Z"` → `DateTime CreatedAt { get; set; }` |
| `datetime` | `DateTime` | Same as timestamp |

## Complex Type Mapping

| JSON Pattern | C# Type | Example |
|--------------|---------|---------|
| `array<string>` | `List<string>` | Tags → `List<string> Tags { get; set; }` |
| `array<UUID>` | `List<Guid>` | UserIds → `List<Guid> UserIds { get; set; }` |
| `array<object>` | `List<T>` | OrderItems → `List<OrderItem> OrderItems { get; set; }` |
| `object` | Custom class | User → `User { get; set; }` |
| `null\|string` | `string?` (nullable) | Optional field → `string? MiddleName { get; set; }` |

## Nullable Types

In C# 8.0+, nullability is explicit:

| Pattern | C# Code | Meaning |
|---------|---------|---------|
| `field: string` | `string Name { get; set; }` | Required, non-null |
| `field: string?` | `string? Nickname { get; set; }` | Optional, can be null |
| `field: int` | `int Count { get; set; }` | Required, default value 0 |
| `field: int?` | `int? OptionalCount { get; set; }` | Optional, can be null |

## JSON Array Format Examples

### Simple Array
```json
"fields": ["id: UUID", "tags: array<string>"]
```
Generates:
```csharp
public Guid Id { get; set; }
public List<string> Tags { get; set; }
```

### Nested Object Array
```json
"fields": ["id: UUID", "items: array<OrderItem>"]
```
Generates:
```csharp
public Guid Id { get; set; }
public List<OrderItem> Items { get; set; }
```

## Enums

If a field type suggests an enum (e.g., "status: enum<Pending|Active|Completed>"):

```json
"fields": ["status: enum<Pending|Active|Completed>"]
```
Generates:
```csharp
public enum OrderStatus
{
    Pending = 0,
    Active = 1,
    Completed = 2
}

public OrderStatus Status { get; set; }
```

## Relationship Mapping

### One-to-Many
```csharp
// Parent
public class Order
{
    public Guid Id { get; set; }
    public List<OrderItem> Items { get; set; } = new();
}

// Child
public class OrderItem
{
    public Guid Id { get; set; }
    public Guid OrderId { get; set; }
    public Order Order { get; set; }
}
```

### Many-to-One
```csharp
public class OrderItem
{
    public Guid Id { get; set; }
    public Guid OrderId { get; set; }
    public Order Order { get; set; }
}
```

### Many-to-Many
```csharp
public class Student
{
    public Guid Id { get; set; }
    public List<Course> Courses { get; set; } = new();
}

public class Course
{
    public Guid Id { get; set; }
    public List<Student> Students { get; set; } = new();
}
```

## DateTime Handling

| JSON Type | C# Property | Storage Format | Note |
|-----------|-------------|-----------------|------|
| `timestamp` | `DateTime` | UTC in DB | Always use UTC |
| `date` | `DateTime` (date only) | Date in DB | Set time to midnight |
| `time` | `TimeSpan` | Time in DB | Not yet common |

**Best practice in generated code:**
```csharp
public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
public DateTime? UpdatedAt { get; set; }
```

## String Formats

Special string formats may be recognized:

| Format | C# Handling | Note |
|--------|------------|------|
| `email` | `string` + validation | Add `[EmailAddress]` attribute |
| `url` | `string` + validation | Add `[Url]` attribute |
| `uuid` | Convert to `Guid` | More efficient than string |
| `phone` | `string` + validation | Add `[Phone]` attribute |

## Decimal Precision

For financial data:

```json
"fields": ["price: decimal", "discount: decimal"]
```

Generated:
```csharp
[Column(TypeName = "decimal(18,2)")]
public decimal Price { get; set; }

[Column(TypeName = "decimal(18,2)")]
public decimal Discount { get; set; }
```

## DTO Mapping Example

**Entity** (Database model):
```csharp
public class User
{
    public Guid Id { get; set; }
    public string Email { get; set; }
    public string PasswordHash { get; set; }  // Never in DTO
    public DateTime CreatedAt { get; set; }
}
```

**DTO** (API response):
```csharp
public class UserDto
{
    public Guid Id { get; set; }
    public string Email { get; set; }
    public DateTime CreatedAt { get; set; }
    // Note: PasswordHash is NOT included
}
```
