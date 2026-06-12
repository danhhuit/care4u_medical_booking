using Care4U.Api.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Care4U.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class DoctorsController : ControllerBase
{
    private readonly Care4UDbContext _context;

    public DoctorsController(Care4UDbContext context)
    {
        _context = context;
    }

    // GET: /api/Doctors
    // GET: /api/Doctors?specialtyId=1
    [HttpGet]
    public async Task<IActionResult> GetAll([FromQuery] int? specialtyId)
    {
        var query = _context.Doctors
            .Include(x => x.Specialty)
            .Include(x => x.HealthCenter)
            .AsQueryable();

        if (specialtyId.HasValue)
        {
            query = query.Where(x => x.SpecialtyId == specialtyId.Value);
        }

        var data = await query
            .OrderByDescending(x => x.Rating)
            .Select(x => new
            {
                x.Id,
                x.FullName,
                x.Title,
                x.ExperienceYears,
                x.ConsultationFee,
                x.Bio,
                x.Education,
                x.Achievements,
                x.Rating,
                x.TotalReviews,
                x.AvatarUrl,
                x.IsAvailable,
                x.SpecialtyId,
                SpecialtyName = x.Specialty.Name,
                HealthCenterId = x.HealthCenterId,
                HealthCenterName = x.HealthCenter != null ? x.HealthCenter.Name : null,
                HealthCenterAddress = x.HealthCenter != null ? x.HealthCenter.Address : null
            })
            .ToListAsync();

        return Ok(data);
    }

    // GET: /api/Doctors/1
    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var doctor = await _context.Doctors
            .Include(x => x.Specialty)
            .Include(x => x.HealthCenter)
            .Where(x => x.Id == id)
            .Select(x => new
            {
                x.Id,
                x.FullName,
                x.Title,
                x.LicenseNumber,
                x.ExperienceYears,
                x.ConsultationFee,
                x.Bio,
                x.Education,
                x.Achievements,
                x.Rating,
                x.TotalReviews,
                x.AvatarUrl,
                x.IsAvailable,
                x.SpecialtyId,
                SpecialtyName = x.Specialty.Name,
                HealthCenterId = x.HealthCenterId,
                HealthCenterName = x.HealthCenter != null ? x.HealthCenter.Name : null,
                HealthCenterAddress = x.HealthCenter != null ? x.HealthCenter.Address : null
            })
            .FirstOrDefaultAsync();

        if (doctor == null)
        {
            return NotFound(new { message = "Không tìm thấy bác sĩ" });
        }

        return Ok(doctor);
    }
}