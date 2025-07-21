using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using thuvienso.Data;
using thuvienso.Models;

namespace thuvienso.Controllers.User
{
    [Route("document")]
    public class DocumentController : Controller
    {
        private readonly AppDbContext _context;

        public DocumentController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> Details(int id)
        {
            var doc = await _context.Documents
                .Include(d => d.Category)
                .Include(d => d.Publisher)
                .Include(d => d.DocumentAuthors)
                    .ThenInclude(da => da.Author)
                .FirstOrDefaultAsync(d => d.Id == id);

            if (doc == null) return NotFound();

            // +1 lượt xem
            doc.View = (doc.View ?? 0) + 1;
            await _context.SaveChangesAsync();

            // Lấy danh sách tài liệu mới và phổ biến
            ViewBag.NewestDocs = await _context.Documents
                .Where(d => d.Id != id)
                .Include(d => d.DocumentAuthors).ThenInclude(da => da.Author)
                .OrderByDescending(d => d.Id).Take(12).ToListAsync();

            ViewBag.PopularDocs = await _context.Documents
                .Where(d => d.Id != id)
                .Include(d => d.DocumentAuthors).ThenInclude(da => da.Author)
                .OrderByDescending(d => d.View).Take(12).ToListAsync();

            ViewBag.AllCategories = await _context.Categories.ToListAsync();

            // ✅ Xử lý quyền xem tài liệu
            string fileToRender = doc.IsFree ? doc.FileUrl : doc.PreviewFileUrl;
            var userId = HttpContext.Session.GetInt32("UserId");

            if (!doc.IsFree && userId != null)
            {
                var payment = await _context.Payments
                    .Where(p => p.UserId == userId && p.DocumentId == doc.Id && p.PaymentStatus == "paid")
                    .OrderByDescending(p => p.PercentPaid)
                    .FirstOrDefaultAsync();

                if (payment != null)
                {
                    var fileName = Path.GetFileName(doc.FileUrl);
                    if (payment.PercentPaid >= 100)
                    {
                        fileToRender = doc.FileUrl;
                    }
                    else
                    {
                        fileToRender = $"/payment/user-{userId}/document-{doc.Id}/{fileName}";
                    }

                    ViewBag.PercentPaid = payment.PercentPaid;
                }
            }

            ViewBag.FileToRender = fileToRender;

            return View("~/Views/User/Document/Detail.cshtml", doc);
        }



        [HttpGet("download/{id}")]
        public async Task<IActionResult> Download(int id)
        {
            var userId = HttpContext.Session.GetInt32("UserId");
            if (userId == null)
                return Redirect("/user/auth/login");

            var doc = await _context.Documents.FindAsync(id);
            if (doc == null || string.IsNullOrEmpty(doc.FileUrl))
                return NotFound();

            var fileName = Path.GetFileName(doc.FileUrl);
            string filePath;

            if (doc.IsFree)
            {
                // Tài liệu miễn phí → tải bản gốc
                filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", doc.FileUrl.TrimStart('/'));
            }
            else
            {
                // Tài liệu có phí → kiểm tra thanh toán
                var payment = await _context.Payments
                    .Where(p => p.UserId == userId && p.DocumentId == doc.Id && p.PaymentStatus == "paid")
                    .OrderByDescending(p => p.PercentPaid)
                    .FirstOrDefaultAsync();

                if (payment == null)
                {
                    return Unauthorized("❌ Bạn chưa thanh toán cho tài liệu này.");
                }

                if (payment.PercentPaid >= 100)
                {
                    // Đã thanh toán toàn phần → tải bản gốc
                    filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", doc.FileUrl.TrimStart('/'));
                }
                else
                {
                    // Thanh toán một phần → tải bản cá nhân đã cắt
                    filePath = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "payment", $"user-{userId}", $"document-{doc.Id}", fileName);
                    if (!System.IO.File.Exists(filePath))
                        return NotFound("❌ File preview không tồn tại. Vui lòng liên hệ hỗ trợ.");
                }
            }

            if (!System.IO.File.Exists(filePath))
                return NotFound("❌ Không tìm thấy file.");

            // Tăng lượt tải nếu được phép tải
            doc.Download = (doc.Download ?? 0) + 1;
            await _context.SaveChangesAsync();

            var contentType = "application/octet-stream";
            return PhysicalFile(filePath, contentType, fileName);
        }


        [HttpGet("qr-detail/{id}")]
        public async Task<IActionResult> QrDetail(int id)
        {
            var qr = await _context.QRCodes
                .FirstOrDefaultAsync(q => q.DocumentId == id && q.Type == QRCodeType.view && q.IsActive);

            if (qr == null)
                return NotFound("❌ Mã QR không hợp lệ hoặc đã bị vô hiệu hóa.");

            // Tăng scan count
            qr.ScanCount += 1;

            await _context.SaveChangesAsync();

            return Redirect($"/document/{id}");
        }

        [HttpGet("qr-download/{id}")]
        public async Task<IActionResult> QrDownload(int id)
        {
            var qr = await _context.QRCodes
                .FirstOrDefaultAsync(q => q.DocumentId == id && q.Type == QRCodeType.download && q.IsActive);

            if (qr == null)
                return NotFound("❌ Mã QR không hợp lệ hoặc đã bị vô hiệu hóa.");

            // Tăng scan count
            qr.ScanCount += 1;

            await _context.SaveChangesAsync();

            return Redirect($"/document/download/{id}");
        }

    }
}
