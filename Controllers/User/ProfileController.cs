using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using thuvienso.Data;

namespace thuvienso.Controllers.User
{
    [Route("user/profile")]
    public class ProfileController : Controller
    {
        private readonly AppDbContext _context;

        public ProfileController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet("")]
        public async Task<IActionResult> Index()
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null)
                return Redirect("/user/auth/login");

            // 👉 Danh sách đã thanh toán
            var paidDocs = await _context.Payments
                .Where(p => p.UserId == userId && p.PaymentStatus == "paid")
                .Include(p => p.Document)
                .GroupBy(p => p.DocumentId)
                .Select(g => g.OrderByDescending(p => p.PercentPaid).First())
                .ToListAsync();

            // 👉 Danh sách đang chờ thanh toán
            var pendingDocs = await _context.Payments
                .Where(p => p.UserId == userId && p.PaymentStatus == "pending")
                .Include(p => p.Document)
                .GroupBy(p => p.DocumentId)
                .Select(g => g.OrderByDescending(p => p.CreatedAt).First())
                .ToListAsync();

            ViewBag.PendingDocs = pendingDocs;
            return View("~/Views/User/Profile.cshtml", paidDocs);
        }
    }
}
