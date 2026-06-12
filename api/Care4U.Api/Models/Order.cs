using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class Order
{
    public Guid Id { get; set; }

    public int PatientId { get; set; }

    public string OrderNo { get; set; } = null!;

    public string Status { get; set; } = null!;

    public decimal Subtotal { get; set; }

    public decimal Discount { get; set; }

    public decimal ShippingFee { get; set; }

    public decimal TotalAmount { get; set; }

    public string? ShippingName { get; set; }

    public string? ShippingPhone { get; set; }

    public string? ShippingAddress { get; set; }

    public string? ShippingNote { get; set; }

    public DateTime? ConfirmedAt { get; set; }

    public DateTime? DeliveredAt { get; set; }

    public DateTime? CancelledAt { get; set; }

    public string? CancelReason { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();

    public virtual Patient Patient { get; set; } = null!;

    public virtual ICollection<Payment> Payments { get; set; } = new List<Payment>();
}
