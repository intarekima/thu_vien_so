using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using thuvienso.Data;
using thuvienso.Models;

namespace thuvienso.Controllers.User
{
    [Route("category")]
    public class CategoryController : Controller
    {
        private readonly AppDbContext _context;

        public CategoryController(AppDbContext context)
        {
            _context = context;
        }

        // Route: /category → hiển thị toàn bộ tài liệu
        [HttpGet("")]
        public async Task<IActionResult> Index(string? search, int? categoryId, int? publisherId, int? authorId, string? sort, int page = 1)
        {
            int pageSize = 12;

            IQueryable<Document> query;

            // Nếu có từ khóa tìm kiếm -> dùng full-text MATCH
            if (!string.IsNullOrWhiteSpace(search))
            {
                query = _context.Documents
                    .FromSqlRaw(@"
                SELECT * FROM Documents
                WHERE MATCH (Title) AGAINST ({0} IN NATURAL LANGUAGE MODE)", search)
                    .AsQueryable();
            }
            else
            {
                query = _context.Documents.AsQueryable();
            }

            // Include liên kết
            query = query
                .Include(d => d.Category)
                .Include(d => d.Publisher)
                .Include(d => d.DocumentAuthors).ThenInclude(da => da.Author);

            // Lọc theo danh mục
            if (categoryId.HasValue)
                query = query.Where(d => d.CategoryId == categoryId);

            // Gán tên danh mục ra ViewBag
            if (categoryId.HasValue)
            {
                var currentCategory = await _context.Categories.FirstOrDefaultAsync(c => c.Id == categoryId);
                ViewBag.CurrentCategoryName = currentCategory?.Name ?? $"Danh mục không tồn tại (ID: {categoryId})";
            }
            else
            {
                ViewBag.CurrentCategoryName = "Danh mục tài liệu";
            }

            // Lọc theo nhà xuất bản
            if (publisherId.HasValue)
                query = query.Where(d => d.PublisherId == publisherId);

            // Lọc theo tác giả (many-to-many)
            if (authorId.HasValue)
                query = query.Where(d => d.DocumentAuthors.Any(da => da.AuthorId == authorId));

            // Sắp xếp
            query = sort switch
            {
                "newest" => query.OrderByDescending(d => d.Id),
                "oldest" => query.OrderBy(d => d.Id),
                "view_asc" => query.OrderByDescending(d => d.View ?? 0),       // Xem nhiều
                "view_desc" => query.OrderByDescending(d => d.Download ?? 0),  // Tải nhiều
                "free" => query.Where(d => d.IsFree).OrderByDescending(d => d.Id),
                "fee" => query.Where(d => !d.IsFree).OrderByDescending(d => d.Id),
                _ => query.OrderByDescending(d => d.Id)
            };

            // Pagination
            var totalCount = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalCount / (double)pageSize);

            var documents = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.TotalPages = totalPages;
            ViewBag.CurrentPage = page;

            // Truyền xuống ViewBag cho dropdown filter
            ViewBag.Categories = await _context.Categories
                .Select(c => new SelectListItem { Value = c.Id.ToString(), Text = c.Name }).ToListAsync();

            ViewBag.Publishers = await _context.Publishers
                .Select(p => new SelectListItem { Value = p.Id.ToString(), Text = p.Name }).ToListAsync();

            ViewBag.Authors = await _context.Authors
                .Select(a => new SelectListItem { Value = a.Id.ToString(), Text = a.Name }).ToListAsync();

            return View("~/Views/User/Category/Index.cshtml", documents);
        }

    }
}
