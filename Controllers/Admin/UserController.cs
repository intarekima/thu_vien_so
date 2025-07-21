using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using thuvienso.Data;
using thuvienso.Models;

namespace thuvienso.Controllers.Admin
{
    [Authorize(Roles = "admin", AuthenticationSchemes = "AdminAuth")]
    [Route("admin/user")]
    public class UserController : Controller
    {
        private readonly AppDbContext _context;

        public UserController(AppDbContext context)
        {
            _context = context;
        }

        [HttpGet("")]
        public async Task<IActionResult> Index(string? search, string? role)
        {
            var query = _context.Users.AsQueryable();

            if (!string.IsNullOrWhiteSpace(search))
            {
                query = query.Where(u =>
                    u.Name.Contains(search) ||
                    u.Email.Contains(search) ||
                    u.Phone.Contains(search));
            }

            if (!string.IsNullOrWhiteSpace(role))
            {
                query = query.Where(u => u.Role == role);
            }

            var users = await query
                .OrderBy(u => u.Role)
                .ThenBy(u => u.Name)
                .ToListAsync();

            // Truyền lại để giữ trạng thái form (nếu cần thêm ViewBag)
            ViewBag.Search = search;
            ViewBag.Role = role;

            return View("~/Views/Admin/User/Index.cshtml", users);
        }


        [HttpGet("create")]
        public IActionResult Create()
        {
            return View("~/Views/Admin/User/Create.cshtml");
        }

        [HttpPost("create")]
        public async Task<IActionResult> Create(string name, string email, string password, string confirmPassword, string role)
        {
            if (string.IsNullOrWhiteSpace(name) || string.IsNullOrWhiteSpace(email) ||
                string.IsNullOrWhiteSpace(password) || string.IsNullOrWhiteSpace(role))
            {
                TempData["Error"] = "Vui lòng nhập đầy đủ thông tin.";
                return Redirect("/admin/user/create");
            }

            var exists = await _context.Users.AnyAsync(u => u.Email == email);
            if (exists)
            {
                TempData["Error"] = "Email đã tồn tại.";
                return Redirect("/admin/user/create");
            }

            if (password != confirmPassword)
            {
                TempData["Error"] = "Mật khẩu và xác nhận không khớp.";
                return Redirect("/admin/user/create");
            }

            var user = new Models.User
            {
                Name = name,
                Email = email,
                Password = BCrypt.Net.BCrypt.HashPassword(password), // nên mã hóa sau nếu cần
                Role = role
            };

            _context.Users.Add(user);
            await _context.SaveChangesAsync();

            TempData["Success"] = "Tạo người dùng thành công.";
            return Redirect("/admin/user");
        }

        [HttpGet("edit/{id}")]
        public async Task<IActionResult> Edit(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();

            return View("~/Views/Admin/User/Edit.cshtml", user);
        }

        [HttpPost("edit/{id}")]
        public async Task<IActionResult> Edit(int id, string name, string role, string? newPassword, string? confirmNewPassword)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();

            if (string.IsNullOrWhiteSpace(name) || string.IsNullOrWhiteSpace(role))
            {
                TempData["Error"] = "Họ tên và vai trò không được để trống.";
                return Redirect($"/admin/user/edit/{id}");
            }

            if (!string.IsNullOrWhiteSpace(newPassword))
            {
                if (newPassword != confirmNewPassword)
                {
                    TempData["Error"] = "Mật khẩu mới và xác nhận không khớp.";
                    return Redirect($"/admin/user/edit/{id}");
                }

                user.Password = BCrypt.Net.BCrypt.HashPassword(newPassword);
            }

            user.Name = name.Trim();
            user.Role = role.Trim();

            await _context.SaveChangesAsync();

            TempData["Success"] = "Cập nhật người dùng thành công.";
            return Redirect("/admin/user");
        }

        [HttpGet("delete/{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null) return NotFound();

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();

            TempData["Success"] = "Xóa thành công.";
            return Redirect("/admin/user");
        }
    }
}
