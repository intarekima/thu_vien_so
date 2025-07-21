using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using thuvienso.Data;

namespace thuvienso.Controllers.Admin;

[Authorize(Roles = "admin")]
[Route("admin")]
public class DashboardController : Controller
{
    private readonly AppDbContext _context;

    public DashboardController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet("dashboard")]
    public async Task<IActionResult> Dashboard()
    {
        // Tổng quan
        ViewBag.TotalViews = await _context.Documents.SumAsync(d => d.View);
        ViewBag.TotalDownloads = await _context.Documents.SumAsync(d => d.Download);
        ViewBag.TotalQrScans = await _context.QRCodes.SumAsync(q => q.ScanCount);
        ViewBag.TotalRevenue = await _context.Payments
            .Where(o => o.PaymentStatus == "paid")
            .SumAsync(o => o.PricePaid);

        // 4 bảng top
        ViewBag.TopViewed = await _context.Documents
            .OrderByDescending(d => d.View)
            .Take(10)
            .ToListAsync();

        ViewBag.TopDownloaded = await _context.Documents
            .OrderByDescending(d => d.Download)
            .Take(10)
            .ToListAsync();

        ViewBag.TopPurchased = await _context.Documents
            .OrderByDescending(d => d.Purchase)
            .Take(10)
            .Select(d => new { d.Id, d.Title, PurchaseCount = d.Purchase })
            .ToListAsync();

        ViewBag.TopRevenue = await _context.Payments
            .Where(o => o.PaymentStatus == "paid")
            .GroupBy(o => o.DocumentId)
            .Select(g => new {
                DocumentId = g.Key,
                Revenue = g.Sum(x => x.PricePaid)
            })
            .OrderByDescending(g => g.Revenue)
            .Take(10)
            .Join(_context.Documents, g => g.DocumentId, d => d.Id,
                (g, d) => new { d.Id, d.Title, Revenue = g.Revenue })
            .ToListAsync();

        ViewBag.RecentOrders = await _context.Payments
            .Include(p => p.User)
            .Include(p => p.Document)
            .OrderByDescending(p => p.CreatedAt)
            .Take(10)
            .Select(p => new
            {
                p.Id,
                p.OrderCode,
                p.PaymentStatus,
                p.PercentPaid,
                p.TotalPrice,
                p.PricePaid,
                p.QrCodeUrl,
                p.CheckoutUrl,
                p.TransactionTime,
                p.CreatedAt,
                UserFullName = p.User.Name,
                Phone = p.User.Phone,
                Email = p.User.Email,
                DocumentTitle = p.Document.Title
            })
            .ToListAsync();


        return View("Views/Admin/Dashboard.cshtml");
    }
}
