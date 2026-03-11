# C# Code Generation Template

## Complete Example: Order Service

### Input JSON
```json
{
  "services": [
    {
      "serviceName": "OrderService",
      "description": "Manages customer orders and order fulfillment",
      "endpoints": [
        {"method": "GET", "path": "/orders/{id}", "description": "Get order details"},
        {"method": "POST", "path": "/orders", "description": "Create new order"},
        {"method": "PUT", "path": "/orders/{id}", "description": "Update order"}
      ],
      "dataModels": [
        {
          "name": "Order",
          "fields": ["id: UUID", "customerId: UUID", "totalAmount: decimal", "status: string", "createdAt: timestamp"]
        },
        {
          "name": "OrderItem",
          "fields": ["id: UUID", "orderId: UUID", "productId: UUID", "quantity: integer", "price: decimal"]
        }
      ],
      "externalDependencies": ["PaymentService", "InventoryService", "OrderDB"]
    }
  ]
}
```

### Generated Project Structure
```
src/
├── OrderService.Api/
│   ├── Program.cs
│   ├── appsettings.json
│   ├── appsettings.Development.json
│   ├── OrderService.Api.csproj
│   ├── Controllers/
│   │   └── OrderServiceController.cs
│   └── Properties/
│       └── launchSettings.json
│
├── OrderService.Models/
│   ├── OrderService.Models.csproj
│   ├── Dtos/
│   │   ├── OrderDto.cs
│   │   ├── OrderItemDto.cs
│   │   ├── CreateOrderDto.cs
│   │   └── UpdateOrderDto.cs
│   └── Responses/
│       └── ApiResponse.cs
│
├── OrderService.Core/
│   ├── OrderService.Core.csproj
│   ├── Entities/
│   │   ├── Order.cs
│   │   └── OrderItem.cs
│   ├── Services/
│   │   ├── IOrderService.cs
│   │   ├── OrderService.cs
│   │   ├── IPaymentService.cs
│   │   └── IInventoryService.cs
│   └── Data/
│       └── ApplicationDbContext.cs
│
└── OrderService.sln
```

### Generated Files

#### 1. Program.cs
```csharp
using OrderService.Core.Data;
using OrderService.Core.Services;
using Microsoft.EntityFrameworkCore;

var builder = WebApplicationBuilder.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add DbContext
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseNpgsql(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        b => b.MigrationsAssembly("OrderService.Api")
    )
);

// Register Services
builder.Services.AddScoped<IOrderService, OrderService>();
builder.Services.AddScoped<IPaymentService, PaymentService>();
builder.Services.AddScoped<IInventoryService, InventoryService>();

// Add Logging
builder.Services.AddLogging();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();
```

#### 2. Entities/Order.cs
```csharp
namespace OrderService.Core.Entities
{
    public class Order
    {
        public Guid Id { get; set; }
        public Guid CustomerId { get; set; }
        public decimal TotalAmount { get; set; }
        public string Status { get; set; }
        public DateTime CreatedAt { get; set; }
        
        public ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
    }
}
```

#### 3. Dtos/OrderDto.cs
```csharp
namespace OrderService.Models.Dtos
{
    public class OrderDto
    {
        public Guid Id { get; set; }
        public Guid CustomerId { get; set; }
        public decimal TotalAmount { get; set; }
        public string Status { get; set; }
        public DateTime CreatedAt { get; set; }
        public ICollection<OrderItemDto> OrderItems { get; set; }
    }
    
    public class CreateOrderDto
    {
        public Guid CustomerId { get; set; }
        public ICollection<CreateOrderItemDto> OrderItems { get; set; }
    }
    
    public class UpdateOrderDto
    {
        public string Status { get; set; }
    }
    
    public class OrderItemDto
    {
        public Guid Id { get; set; }
        public Guid ProductId { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
    }
    
    public class CreateOrderItemDto
    {
        public Guid ProductId { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
    }
}
```

#### 4. Controllers/OrderServiceController.cs
```csharp
using Microsoft.AspNetCore.Mvc;
using OrderService.Core.Services;
using OrderService.Models.Dtos;

namespace OrderService.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OrderServiceController : ControllerBase
    {
        private readonly IOrderService _orderService;
        private readonly ILogger<OrderServiceController> _logger;

        public OrderServiceController(
            IOrderService orderService,
            ILogger<OrderServiceController> logger)
        {
            _orderService = orderService;
            _logger = logger;
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<OrderDto>> GetOrder(Guid id)
        {
            _logger.LogInformation($"Getting order {id}");
            try
            {
                var order = await _orderService.GetOrderAsync(id);
                if (order == null)
                    return NotFound(new { message = "Order not found" });
                
                return Ok(order);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error getting order {id}");
                return StatusCode(500, new { message = "Error retrieving order" });
            }
        }

        [HttpPost]
        public async Task<ActionResult<OrderDto>> CreateOrder([FromBody] CreateOrderDto dto)
        {
            _logger.LogInformation("Creating new order");
            try
            {
                var order = await _orderService.CreateOrderAsync(dto);
                return CreatedAtAction(nameof(GetOrder), new { id = order.Id }, order);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating order");
                return StatusCode(500, new { message = "Error creating order" });
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateOrder(Guid id, [FromBody] UpdateOrderDto dto)
        {
            _logger.LogInformation($"Updating order {id}");
            try
            {
                var success = await _orderService.UpdateOrderAsync(id, dto);
                if (!success)
                    return NotFound(new { message = "Order not found" });
                
                return NoContent();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error updating order {id}");
                return StatusCode(500, new { message = "Error updating order" });
            }
        }
    }
}
```

#### 5. Services/IOrderService.cs
```csharp
using OrderService.Models.Dtos;

namespace OrderService.Core.Services
{
    public interface IOrderService
    {
        Task<OrderDto> GetOrderAsync(Guid id);
        Task<OrderDto> CreateOrderAsync(CreateOrderDto dto);
        Task<bool> UpdateOrderAsync(Guid id, UpdateOrderDto dto);
    }
}
```

#### 6. Services/OrderService.cs
```csharp
using OrderService.Core.Data;
using OrderService.Core.Entities;
using OrderService.Models.Dtos;
using Microsoft.EntityFrameworkCore;

namespace OrderService.Core.Services
{
    public class OrderService : IOrderService
    {
        private readonly ApplicationDbContext _context;
        private readonly IPaymentService _paymentService;
        private readonly IInventoryService _inventoryService;
        private readonly ILogger<OrderService> _logger;

        public OrderService(
            ApplicationDbContext context,
            IPaymentService paymentService,
            IInventoryService inventoryService,
            ILogger<OrderService> logger)
        {
            _context = context;
            _paymentService = paymentService;
            _inventoryService = inventoryService;
            _logger = logger;
        }

        public async Task<OrderDto> GetOrderAsync(Guid id)
        {
            var order = await _context.Orders
                .Include(o => o.OrderItems)
                .FirstOrDefaultAsync(o => o.Id == id);
            
            if (order == null)
                return null;
            
            return MapToDto(order);
        }

        public async Task<OrderDto> CreateOrderAsync(CreateOrderDto dto)
        {
            var order = new Order
            {
                Id = Guid.NewGuid(),
                CustomerId = dto.CustomerId,
                Status = "Pending",
                CreatedAt = DateTime.UtcNow
            };

            foreach (var item in dto.OrderItems)
            {
                order.OrderItems.Add(new OrderItem
                {
                    Id = Guid.NewGuid(),
                    ProductId = item.ProductId,
                    Quantity = item.Quantity,
                    Price = item.Price,
                    OrderId = order.Id
                });
                
                order.TotalAmount += item.Price * item.Quantity;
            }

            _context.Orders.Add(order);
            await _context.SaveChangesAsync();

            _logger.LogInformation($"Order {order.Id} created");
            return MapToDto(order);
        }

        public async Task<bool> UpdateOrderAsync(Guid id, UpdateOrderDto dto)
        {
            var order = await _context.Orders.FindAsync(id);
            if (order == null)
                return false;

            order.Status = dto.Status;
            await _context.SaveChangesAsync();

            _logger.LogInformation($"Order {id} updated to status {dto.Status}");
            return true;
        }

        private OrderDto MapToDto(Order order)
        {
            return new OrderDto
            {
                Id = order.Id,
                CustomerId = order.CustomerId,
                TotalAmount = order.TotalAmount,
                Status = order.Status,
                CreatedAt = order.CreatedAt,
                OrderItems = order.OrderItems.Select(oi => new OrderItemDto
                {
                    Id = oi.Id,
                    ProductId = oi.ProductId,
                    Quantity = oi.Quantity,
                    Price = oi.Price
                }).ToList()
            };
        }
    }
}
```

## Customization Points

- **Namespace prefix:** Change `MyProject.Services` to your organization
- **Database:** Replace `UseNpgsql` with your chosen database (SqlServer, MySql, Sqlite)
- **Logging level:** Adjust logging verbosity
- **Validation:** Add FluentValidation for DTOs
- **Mapping:** Use AutoMapper instead of manual mapping
- **Async:** Can be made fully sync if needed
