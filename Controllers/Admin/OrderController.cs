using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using thuvienso.Data;

namespace thuvienso.Controllers.Admin
{
    [Route("admin/order")]
    public class OrderController : Controller
    {
        private readonly AppDbContext _context;

        public OrderController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet("")]
        public async Task<IActionResult> Index(string? search, string? status, int? percent, DateTime? fromDate, DateTime? toDate, int page = 1)
        {
            int pageSize = 10;
            var query = _context.Payments
                .Include(o => o.User)
                .Include(o => o.Document)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(search))
            {
                query = query.Where(o =>
                    o.User.Name.Contains(search) ||
                    o.User.Email.Contains(search) ||
                    o.User.Phone.Contains(search) ||
                    o.Document.Title.Contains(search) ||
                    o.OrderCode.Contains(search));
            }

            if (!string.IsNullOrEmpty(status))
            {
                query = query.Where(o => o.PaymentStatus == status);
            }

            if (percent.HasValue)
            {
                query = query.Where(o => o.PercentPaid == percent);
            }

            if (fromDate.HasValue)
            {
                query = query.Where(o => o.CreatedAt >= fromDate);
            }

            if (toDate.HasValue)
            {
                query = query.Where(o => o.CreatedAt <= toDate);
            }

            int totalItems = await query.CountAsync();
            var orders = await query
                .OrderByDescending(o => o.Id)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;
            ViewBag.Search = search;
            ViewBag.Status = status;
            ViewBag.Percent = percent;
            ViewBag.FromDate = fromDate?.ToString("yyyy-MM-dd");
            ViewBag.ToDate = toDate?.ToString("yyyy-MM-dd");

            return View("~/Views/Admin/Order/Index.cshtml", orders);
        }
    }
}
