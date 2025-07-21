using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using thuvienso.Data;
using thuvienso.Models;

namespace thuvienso.Controllers.Admin
{
    [Route("admin/qr")]
    public class QRCodeController : Controller
    {
        private readonly AppDbContext _context;

        public QRCodeController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet("")]
        public async Task<IActionResult> Index(string? search, string? type, string? sortBy, int page = 1)
        {
            int pageSize = 10;
            var query = _context.QRCodes
                .Include(q => q.Document)
                .ThenInclude(d => d.Category)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(search))
                query = query.Where(q => q.Document.Title.Contains(search));

            if (!string.IsNullOrWhiteSpace(type) && Enum.TryParse(type, out QRCodeType enumType))
                query = query.Where(q => q.Type == enumType);

            // 👉 Sắp xếp theo sortBy
            query = sortBy switch
            {
                "scan" => query.OrderByDescending(q => q.ScanCount),
                _ => query.OrderByDescending(q => q.Id)
            };

            int totalItems = await query.CountAsync();

            var list = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;
            ViewBag.Search = search;
            ViewBag.Type = type;
            ViewBag.SortBy = sortBy;

            return View("~/Views/Admin/QRCode/Index.cshtml", list);
        }
    }
}
