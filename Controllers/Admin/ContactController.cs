using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using thuvienso.Data;
using thuvienso.Models;

namespace thuvienso.Controllers.Admin
{
    [Route("admin/contact")]
    public class ContactController : Controller
    {
        private readonly AppDbContext _context;

        public ContactController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet("")]
        public async Task<IActionResult> Index(string? name, string? email, string? phone, string? isHandled, DateTime? fromDate, DateTime? toDate, int page = 1)
        {
            int pageSize = 10;
            var query = _context.Contacts.AsQueryable();

            if (!string.IsNullOrWhiteSpace(name))
                query = query.Where(c => c.Name.Contains(name));

            if (!string.IsNullOrWhiteSpace(email))
                query = query.Where(c => c.Email.Contains(email));

            if (!string.IsNullOrWhiteSpace(phone))
                query = query.Where(c => c.Phone.Contains(phone));

            if (!string.IsNullOrEmpty(isHandled))
            {
                bool handled = isHandled == "true";
                //query = query.Where(c => c.IsHandled == handled);
            }

            if (fromDate.HasValue)
                query = query.Where(c => c.CreatedAt >= fromDate.Value);

            if (toDate.HasValue)
                query = query.Where(c => c.CreatedAt <= toDate.Value);

            int totalItems = await query.CountAsync();

            var contacts = await query
                .OrderByDescending(c => c.Id)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            // Gửi về view để giữ form
            ViewBag.Name = name;
            ViewBag.Email = email;
            ViewBag.Phone = phone;
            //ViewBag.IsHandled = isHandled;
            ViewBag.FromDate = fromDate?.ToString("yyyy-MM-dd");
            ViewBag.ToDate = toDate?.ToString("yyyy-MM-dd");
            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalItems = totalItems;

            return View("~/Views/Admin/Contact/Index.cshtml", contacts);
        }

        [HttpGet("delete/{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var contact = await _context.Contacts.FindAsync(id);
            if (contact == null)
            {
                TempData["Error"] = "Không tìm thấy liên hệ cần xoá.";
                return RedirectToAction("Index");
            }

            try
            {
                _context.Contacts.Remove(contact);
                await _context.SaveChangesAsync();
                TempData["Success"] = "Đã xoá liên hệ thành công.";
            }
            catch
            {
                TempData["Error"] = "Xảy ra lỗi khi xoá liên hệ.";
            }

            return RedirectToAction("Index");
        }

    }
}
