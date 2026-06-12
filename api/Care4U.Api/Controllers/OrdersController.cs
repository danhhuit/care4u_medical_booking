using Care4U.Api.Data;
using Care4U.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;

public class CreateOrderItemRequest
{
    public int ProductId { get; set; }
    public int Quantity { get; set; }
}

public class CreateOrderRequest
{
    public int PatientId { get; set; }
    public string? ShippingName { get; set; }
    public string? ShippingPhone { get; set; }
    public string? ShippingAddress { get; set; }
    public string? ShippingNote { get; set; }
    public decimal ShippingFee { get; set; } = 30000;
    public decimal Discount { get; set; } = 0;
    public string PaymentMethod { get; set; } = "cod";
    public List<CreateOrderItemRequest> Items { get; set; } = new();
}

public class CancelOrderRequest
{
    public string? CancelReason { get; set; }
}

[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public OrdersController(Care4UDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var data = await _context.Orders
            .Include(x => x.Patient)
            .Include(x => x.OrderItems)
                .ThenInclude(i => i.Product)
            .Include(x => x.Payments)
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new
            {
                x.Id,
                x.PatientId,
                PatientName = x.Patient.FullName,
                x.OrderNo,
                x.Status,
                x.Subtotal,
                x.Discount,
                x.ShippingFee,
                x.TotalAmount,
                x.ShippingName,
                x.ShippingPhone,
                x.ShippingAddress,
                x.ShippingNote,
                x.ConfirmedAt,
                x.DeliveredAt,
                x.CancelledAt,
                x.CancelReason,
                x.CreatedAt,
                Items = x.OrderItems.Select(i => new
                {
                    i.Id,
                    i.ProductId,
                    ProductName = i.Product.Name,
                    i.Quantity,
                    i.PriceAtPurchase,
                    i.Subtotal
                }),
                Payments = x.Payments.Select(p => new
                {
                    p.Id,
                    p.PaymentNo,
                    p.Type,
                    p.Amount,
                    p.FinalAmount,
                    p.PaymentMethod,
                    p.Status,
                    p.PaidAt
                })
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("patient/{patientId:int}")]
    public async Task<IActionResult> GetByPatient(int patientId)
    {
        var data = await _context.Orders
            .Include(x => x.Patient)
            .Include(x => x.OrderItems)
                .ThenInclude(i => i.Product)
            .Include(x => x.Payments)
            .Where(x => x.PatientId == patientId)
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new
            {
                x.Id,
                x.PatientId,
                PatientName = x.Patient.FullName,
                x.OrderNo,
                x.Status,
                x.Subtotal,
                x.Discount,
                x.ShippingFee,
                x.TotalAmount,
                x.ShippingName,
                x.ShippingPhone,
                x.ShippingAddress,
                x.ShippingNote,
                x.ConfirmedAt,
                x.DeliveredAt,
                x.CancelledAt,
                x.CancelReason,
                x.CreatedAt,
                Items = x.OrderItems.Select(i => new
                {
                    i.Id,
                    i.ProductId,
                    ProductName = i.Product.Name,
                    i.Quantity,
                    i.PriceAtPurchase,
                    i.Subtotal
                }),
                Payments = x.Payments.Select(p => new
                {
                    p.Id,
                    p.PaymentNo,
                    p.Type,
                    p.Amount,
                    p.FinalAmount,
                    p.PaymentMethod,
                    p.Status,
                    p.PaidAt
                })
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("{id:guid}")]
    public async Task<IActionResult> GetById(Guid id)
    {
        var item = await _context.Orders
            .Include(x => x.Patient)
            .Include(x => x.OrderItems)
                .ThenInclude(i => i.Product)
            .Include(x => x.Payments)
            .Where(x => x.Id == id)
            .Select(x => new
            {
                x.Id,
                x.PatientId,
                PatientName = x.Patient.FullName,
                x.OrderNo,
                x.Status,
                x.Subtotal,
                x.Discount,
                x.ShippingFee,
                x.TotalAmount,
                x.ShippingName,
                x.ShippingPhone,
                x.ShippingAddress,
                x.ShippingNote,
                x.ConfirmedAt,
                x.DeliveredAt,
                x.CancelledAt,
                x.CancelReason,
                x.CreatedAt,
                Items = x.OrderItems.Select(i => new
                {
                    i.Id,
                    i.ProductId,
                    ProductName = i.Product.Name,
                    i.Quantity,
                    i.PriceAtPurchase,
                    i.Subtotal
                }),
                Payments = x.Payments.Select(p => new
                {
                    p.Id,
                    p.PaymentNo,
                    p.Type,
                    p.Amount,
                    p.FinalAmount,
                    p.PaymentMethod,
                    p.Status,
                    p.PaidAt
                })
            })
            .FirstOrDefaultAsync();

        if (item == null)
        {
            return NotFound(new { message = "Không tìm thấy đơn hàng" });
        }

        return Ok(item);
    }

    [HttpPost]
    public async Task<IActionResult> Create(CreateOrderRequest request)
    {
        if (request.Items == null || request.Items.Count == 0)
        {
            return BadRequest(new { message = "Giỏ hàng đang trống" });
        }

        var patient = await _context.Patients
            .FirstOrDefaultAsync(x => x.Id == request.PatientId);

        if (patient == null)
        {
            return BadRequest(new { message = "Bệnh nhân không tồn tại" });
        }

        var normalizedItems = request.Items
            .Where(x => x.ProductId > 0 && x.Quantity > 0)
            .GroupBy(x => x.ProductId)
            .Select(g => new CreateOrderItemRequest
            {
                ProductId = g.Key,
                Quantity = g.Sum(x => x.Quantity)
            })
            .ToList();

        if (normalizedItems.Count == 0)
        {
            return BadRequest(new { message = "Giỏ hàng không hợp lệ" });
        }

        var productIds = normalizedItems.Select(x => x.ProductId).ToList();

        var products = await _context.StoreProducts
            .Where(x => productIds.Contains(x.Id) && x.IsActive)
            .ToListAsync();

        if (products.Count != productIds.Count)
        {
            return BadRequest(new { message = "Một số sản phẩm không tồn tại hoặc đã ngừng bán" });
        }

        foreach (var requestItem in normalizedItems)
        {
            var product = products.First(x => x.Id == requestItem.ProductId);

            if (product.StockQuantity < requestItem.Quantity)
            {
                return BadRequest(new
                {
                    message = $"Sản phẩm {product.Name} không đủ tồn kho",
                    productId = product.Id,
                    stockQuantity = product.StockQuantity
                });
            }
        }

        var now = DateTime.UtcNow;
        var subtotal = normalizedItems.Sum(requestItem =>
        {
            var product = products.First(x => x.Id == requestItem.ProductId);
            var price = product.SalePrice ?? product.Price;
            return price * requestItem.Quantity;
        });

        var discount = request.Discount < 0 ? 0 : request.Discount;
        var shippingFee = request.ShippingFee < 0 ? 0 : request.ShippingFee;
        var totalAmount = subtotal - discount + shippingFee;
        if (totalAmount < 0) totalAmount = 0;

        var rawPaymentMethod = string.IsNullOrWhiteSpace(request.PaymentMethod)
            ? "cod"
            : request.PaymentMethod.Trim().ToLower();

        var paymentMethod = NormalizePaymentMethod(rawPaymentMethod);
        var isCashPayment = paymentMethod == "cash";

        await using var transaction = await _context.Database.BeginTransactionAsync();

        try
        {
            var order = new Order
            {
                Id = Guid.NewGuid(),
                PatientId = request.PatientId,
                OrderNo = $"ORD-{now:yyyyMMdd-HHmmss}",
                Status = isCashPayment ? "pending" : "confirmed",
                Subtotal = subtotal,
                Discount = discount,
                ShippingFee = shippingFee,
                TotalAmount = totalAmount,
                ShippingName = string.IsNullOrWhiteSpace(request.ShippingName) ? patient.FullName : request.ShippingName,
                ShippingPhone = string.IsNullOrWhiteSpace(request.ShippingPhone) ? patient.Phone : request.ShippingPhone,
                ShippingAddress = string.IsNullOrWhiteSpace(request.ShippingAddress) ? patient.Address : request.ShippingAddress,
                ShippingNote = request.ShippingNote,
                ConfirmedAt = isCashPayment ? null : now,
                CreatedAt = now,
                UpdatedAt = now
            };

            _context.Orders.Add(order);

            foreach (var requestItem in normalizedItems)
            {
                var product = products.First(x => x.Id == requestItem.ProductId);
                var price = product.SalePrice ?? product.Price;

                _context.OrderItems.Add(new OrderItem
                {
                    OrderId = order.Id,
                    ProductId = product.Id,
                    Quantity = requestItem.Quantity,
                    PriceAtPurchase = price,
                    Subtotal = price * requestItem.Quantity,
                    CreatedAt = now
                });

                product.StockQuantity -= requestItem.Quantity;
                product.TotalSold += requestItem.Quantity;
                product.UpdatedAt = now;
            }

            var paymentStatus = isCashPayment ? "pending" : "completed";

            _context.Payments.Add(new Payment
            {
                Id = Guid.NewGuid(),
                UserId = patient.UserId,
                PaymentNo = $"PAY-{now:yyyyMMdd-HHmmss}",
                Type = "order",
                OrderId = order.Id,
                Amount = totalAmount,
                Discount = discount,
                FinalAmount = totalAmount,
                Currency = "VND",
                PaymentMethod = NormalizePaymentMethod(request.PaymentMethod),
                // PaymentMethod = paymentMethod,
                Status = paymentStatus,
                TransactionRef = isCashPayment ? null : $"TXN-{now:yyyyMMddHHmmss}",
                PaidAt = isCashPayment ? null : now,
                CreatedAt = now,
                UpdatedAt = now
            });

            await _context.SaveChangesAsync();
            await transaction.CommitAsync();

            return Ok(new
            {
                message = "Tạo đơn hàng thành công",
                order.Id,
                order.OrderNo,
                order.PatientId,
                order.Status,
                order.Subtotal,
                order.Discount,
                order.ShippingFee,
                order.TotalAmount,
                order.ShippingName,
                order.ShippingPhone,
                order.ShippingAddress,
                PaymentStatus = paymentStatus,
                Items = normalizedItems.Select(requestItem =>
                {
                    var product = products.First(x => x.Id == requestItem.ProductId);
                    var price = product.SalePrice ?? product.Price;
                    return new
                    {
                        product.Id,
                        product.Name,
                        Quantity = requestItem.Quantity,
                        Price = price,
                        Subtotal = price * requestItem.Quantity
                    };
                })
            });
        }
        catch
        {
            await transaction.RollbackAsync();
            throw;
        }
    }

    [HttpPut("{id:guid}/cancel")]
    public async Task<IActionResult> Cancel(Guid id, CancelOrderRequest request)
    {
        var order = await _context.Orders
            .Include(x => x.OrderItems)
                .ThenInclude(i => i.Product)
            .FirstOrDefaultAsync(x => x.Id == id);

        if (order == null)
        {
            return NotFound(new { message = "Không tìm thấy đơn hàng" });
        }

        if (order.Status == "cancelled")
        {
            return BadRequest(new { message = "Đơn hàng này đã được hủy trước đó" });
        }

        if (order.Status == "delivered")
        {
            return BadRequest(new { message = "Không thể hủy đơn hàng đã giao" });
        }

        var now = DateTime.UtcNow;

        order.Status = "cancelled";
        order.CancelReason = string.IsNullOrWhiteSpace(request.CancelReason)
            ? "Người dùng hủy đơn hàng"
            : request.CancelReason;
        order.CancelledAt = now;
        order.UpdatedAt = now;

        foreach (var item in order.OrderItems)
        {
            item.Product.StockQuantity += item.Quantity;
            item.Product.TotalSold = Math.Max(0, item.Product.TotalSold - item.Quantity);
            item.Product.UpdatedAt = now;
        }

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Hủy đơn hàng thành công",
            order.Id,
            order.OrderNo,
            order.Status,
            order.CancelReason,
            order.CancelledAt
        });
    }
    private static string NormalizePaymentMethod(string? method)
    {
        var value = (method ?? "").Trim().ToLower();

        return value switch
        {
            "cod" => "cash",
            "cash" => "cash",
            "wallet" => "bank_transfer",
            "care4u_wallet" => "bank_transfer",
            "vietqr" => "bank_transfer",
            "bank_transfer" => "bank_transfer",
            "momo" => "momo",
            "vnpay" => "vnpay",
            "zalopay" => "zalopay",
            "card" => "card",
            _ => "cash"
        };
    }
}
