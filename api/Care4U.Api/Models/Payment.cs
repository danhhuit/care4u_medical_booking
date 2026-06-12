using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class Payment
{
    public Guid Id { get; set; }

    public Guid UserId { get; set; }

    public string PaymentNo { get; set; } = null!;

    public string Type { get; set; } = null!;

    public Guid? AppointmentId { get; set; }

    public Guid? OrderId { get; set; }

    public decimal Amount { get; set; }

    public decimal? Discount { get; set; }

    public decimal? FinalAmount { get; set; }

    public string Currency { get; set; } = null!;

    public string PaymentMethod { get; set; } = null!;

    public string Status { get; set; } = null!;

    public string? TransactionRef { get; set; }

    public string? GatewayResponse { get; set; }

    public DateTime? PaidAt { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual Appointment? Appointment { get; set; }

    public virtual Order? Order { get; set; }

    public virtual User User { get; set; } = null!;
}
