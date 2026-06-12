using Care4U.Api.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class MedicinesController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public MedicinesController(Care4UDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var data = await _context.Medicines
            .OrderBy(x => x.Name)
            .Select(x => new
            {
                x.Id,
                x.Name,
                x.GenericName,
                x.BrandName,
                x.DrugCode,
                x.Category,
                x.DosageForm,
                x.Strength,
                x.Manufacturer,
                x.Description,
                x.UsageInstructions,
                x.SideEffects,
                x.Contraindications,
                x.StorageConditions,
                x.Price,
                x.Unit,
                x.RequiresRx,
                x.IsActive,
                x.ImageUrl,
                x.CreatedAt,
                x.UpdatedAt
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("active")]
    public async Task<IActionResult> GetActive()
    {
        var data = await _context.Medicines
            .Where(x => x.IsActive)
            .OrderBy(x => x.Name)
            .Select(x => new
            {
                x.Id,
                x.Name,
                x.GenericName,
                x.BrandName,
                x.DrugCode,
                x.Category,
                x.DosageForm,
                x.Strength,
                x.Manufacturer,
                x.Description,
                x.UsageInstructions,
                x.SideEffects,
                x.Contraindications,
                x.StorageConditions,
                x.Price,
                x.Unit,
                x.RequiresRx,
                x.IsActive,
                x.ImageUrl,
                x.CreatedAt,
                x.UpdatedAt
            })
            .ToListAsync();

        return Ok(data);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var item = await _context.Medicines
            .Where(x => x.Id == id)
            .Select(x => new
            {
                x.Id,
                x.Name,
                x.GenericName,
                x.BrandName,
                x.DrugCode,
                x.Category,
                x.DosageForm,
                x.Strength,
                x.Manufacturer,
                x.Description,
                x.UsageInstructions,
                x.SideEffects,
                x.Contraindications,
                x.StorageConditions,
                x.Price,
                x.Unit,
                x.RequiresRx,
                x.IsActive,
                x.ImageUrl,
                x.CreatedAt,
                x.UpdatedAt
            })
            .FirstOrDefaultAsync();

        if (item == null)
        {
            return NotFound(new { message = "Không tìm thấy thuốc" });
        }

        return Ok(item);
    }
}
