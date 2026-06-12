using Care4U.Api.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class StoreProductsController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public StoreProductsController(Care4UDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] int? categoryId)
    {
        var query = _context.StoreProducts.AsQueryable();

        if (categoryId.HasValue)
        {
            query = query.Where(x => x.CategoryId == categoryId.Value);
        }

        var data = await query
            .Where(x => x.IsActive)
            .OrderBy(x => x.Id)
            .Select(x => new
            {
                x.Id,
                x.CategoryId,
                x.Name,
                x.Slug,
                x.Description,
                x.ShortDesc,
                x.Sku,
                x.Price,
                x.SalePrice,
                x.StockQuantity,
                x.Unit,
                x.Brand,
                x.Origin,
                x.ImageUrl,
                x.Rating,
                x.TotalSold,
                x.IsActive
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var item = await _context.StoreProducts
            .Where(x => x.Id == id && x.IsActive)
            .Select(x => new
            {
                x.Id,
                x.CategoryId,
                x.Name,
                x.Slug,
                x.Description,
                x.ShortDesc,
                x.Sku,
                x.Price,
                x.SalePrice,
                x.StockQuantity,
                x.Unit,
                x.Brand,
                x.Origin,
                x.ImageUrl,
                x.Rating,
                x.TotalSold,
                x.IsActive
            })
            .FirstOrDefaultAsync();

        if (item == null)
        {
            return NotFound(new { message = "Không tìm thấy sản phẩm" });
        }

        return Ok(item);
    }
}