using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class OrderItem
{
    public int Id { get; set; }

    public Guid OrderId { get; set; }

    public int ProductId { get; set; }

    public int Quantity { get; set; }

    public decimal PriceAtPurchase { get; set; }

    public decimal? Subtotal { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual Order Order { get; set; } = null!;

    public virtual StoreProduct Product { get; set; } = null!;
}
