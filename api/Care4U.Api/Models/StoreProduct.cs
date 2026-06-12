using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class StoreProduct
{
    public int Id { get; set; }

    public int CategoryId { get; set; }

    public string Name { get; set; } = null!;

    public string? Slug { get; set; }

    public string? Description { get; set; }

    public string? ShortDesc { get; set; }

    public string? Sku { get; set; }

    public decimal Price { get; set; }

    public decimal? SalePrice { get; set; }

    public int StockQuantity { get; set; }

    public string? Unit { get; set; }

    public string? Brand { get; set; }

    public string? Origin { get; set; }

    public string? ImageUrl { get; set; }

    public List<string>? Images { get; set; }

    public decimal? Rating { get; set; }

    public int TotalSold { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedAt { get; set; }

    public DateTime UpdatedAt { get; set; }

    public virtual ProductCategory Category { get; set; } = null!;

    public virtual ICollection<OrderItem> OrderItems { get; set; } = new List<OrderItem>();
}
