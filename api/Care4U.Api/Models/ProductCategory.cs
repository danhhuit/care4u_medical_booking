using System;
using System.Collections.Generic;

namespace Care4U.Api.Models;

public partial class ProductCategory
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string? Description { get; set; }

    public int? ParentId { get; set; }

    public string? IconUrl { get; set; }

    public bool IsActive { get; set; }

    public DateTime CreatedAt { get; set; }

    public virtual ICollection<ProductCategory> InverseParent { get; set; } = new List<ProductCategory>();

    public virtual ProductCategory? Parent { get; set; }

    public virtual ICollection<StoreProduct> StoreProducts { get; set; } = new List<StoreProduct>();
}
