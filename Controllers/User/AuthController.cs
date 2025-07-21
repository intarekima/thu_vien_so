using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Cryptography;
using System.Text;
using thuvienso.Data;
using thuvienso.Helpers;
using thuvienso.Models;

namespace thuvienso.Controllers.User;

[Route("user/auth")]
public class AuthController : Controller
{
    private readonly AppDbContext _context;

    public AuthController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet("login")]
    public IActionResult Login(string returnUrl = "/")
    {
        ViewBag.ReturnUrl = returnUrl;
        return View("~/Views/User/Auth/Login.cshtml");
    }

    [HttpPost("login")]
    public async Task<IActionResult> LoginPost(string email, string password)
    {
        var returnUrl = Request.Query["returnUrl"].FirstOrDefault() ?? "/";

        var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == email);
        if (user == null || !BCrypt.Net.BCrypt.Verify(password, user.Password))
        {
            TempData["Error"] = "Email hoặc mật khẩu không đúng.";
            return Redirect($"/user/auth/login?returnUrl={Uri.EscapeDataString(returnUrl)}");
        }

        HttpContext.Session.SetInt32("UserId", user.Id);
        HttpContext.Session.SetString("Name", user.Name);

        return Redirect(returnUrl);
    }


    [HttpGet("logout")]
    public IActionResult Logout()
    {
        HttpContext.Session.Remove("UserId");
        return Redirect("/user/auth/login");
    }

    [HttpGet("register")]
    public IActionResult Register()
    {
        return View("~/Views/User/Auth/Register.cshtml");
    }

    [HttpPost("register")]
    public async Task<IActionResult> RegisterPost(string name, string email, string phone, string password, string rePassword)
    {
        if(password != rePassword)
        {
            TempData["Error"] = "Mật khẩu không trùng khớp";
            return Redirect("/user/auth/register");
        }
        if (await _context.Users.AnyAsync(u => u.Email == email))
        {
            TempData["Error"] = "Email đã được sử dụng.";
            return Redirect("/user/auth/register");
        }

        if (await _context.Users.AnyAsync(u => u.Phone == phone))
        {
            TempData["Error"] = "SĐT đã được sử dụng.";
            return Redirect("/user/auth/register");
        }

        var user = new Models.User
        {
            Name = name,
            Email = email,
            Phone = phone,
            Password = BCrypt.Net.BCrypt.HashPassword(password),
            Role = "user"
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        TempData["Success"] = "Đăng ký thành công. Vui lòng đăng nhập.";
        return Redirect("/user/auth/login");
    }

    [HttpGet("forgot")]
    public IActionResult ForgotPassword()
    {
        return View("~/Views/User/Auth/ForgotPassword.cshtml");
    }

    [HttpPost("forgot")]
    public async Task<IActionResult> ForgotPasswordPost(string email)
    {
        var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == email);
        if (user == null)
        {
            TempData["Error"] = "Email không tồn tại.";
            return Redirect("/user/auth/forgot");
        }

        var random = new Random();
        var code = random.Next(100000, 999999).ToString();

        user.ResetCode = code;
        user.ResetCodeExpiry = DateTime.Now.AddMinutes(30);
        await _context.SaveChangesAsync();

        // Mẫu email HTML đẹp
        string body = $@"
        <!DOCTYPE html>
        <html>
        <body style='font-family: Arial, sans-serif; background-color: #f8f9fa; padding: 30px;'>
          <div style='max-width:600px;margin:0 auto;background:#fff;border-radius:6px;border:1px solid #dee2e6;overflow:hidden;'>
            <div style='background:#0d6efd;color:white;padding:20px 30px;'>
              <h2 style='margin:0;font-size:20px;text-align:center;'>Yêu cầu đặt lại mật khẩu</h2>
            </div>
            <div style='padding:30px;'>
              <p>Xin chào <strong>{user.Name}</strong>,</p>
              <p>Bạn (hoặc ai đó) vừa yêu cầu đặt lại mật khẩu cho tài khoản Thư Viện Số.</p>
              <p>Mã xác nhận của bạn là:</p>
              <div style='font-size:24px; font-weight:bold; color:#0d6efd; text-align:center; padding:10px 0;'>{code}</div>
              <p>Mã có hiệu lực trong <strong>30 phút</strong>. Vui lòng không chia sẻ mã này cho bất kỳ ai.</p>
            </div>
            <div style='background:#f1f3f5;color:#6c757d;text-align:center;padding:15px;'>
              <small>© 2025 <strong>Thư Viện Số</strong> – Email tự động, vui lòng không trả lời</small>
            </div>
          </div>
        </body>
        </html>";

        var subject = "Mã đặt lại mật khẩu – Thư Viện Số";
        var mailHelper = new MailHelper(HttpContext.RequestServices.GetService<IConfiguration>());
        mailHelper.Send(user.Email, subject, body);

        TempData["Success"] = "Đã gửi mã xác nhận đến email của bạn.";
        return Redirect($"/user/auth/verify?email={email}");
    }

    [HttpGet("verify")]
    public IActionResult VerifyResetCode(string email)
    {
        if (string.IsNullOrWhiteSpace(email))
        {
            TempData["Error"] = "Thiếu thông tin email.";
            return Redirect("/user/auth/forgot");
        }

        return View("~/Views/User/Auth/Verify.cshtml", model: email);
    }

    [HttpPost("verify")]
    public async Task<IActionResult> VerifyResetCodePost(string email, string code, string newPassword, string reNewPassword)
    {
        var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == email);
        if (user == null || user.ResetCode != code || user.ResetCodeExpiry < DateTime.Now)
        {
            TempData["Error"] = "Mã không hợp lệ hoặc đã hết hạn.";
            return Redirect($"/user/auth/verify?email={email}");
        }

        if (newPassword != reNewPassword)
        {
            TempData["Error"] = "Mật khẩu mới không trùng khớp.";
            return Redirect($"/user/auth/verify?email={email}");
        }

        user.Password = BCrypt.Net.BCrypt.HashPassword(newPassword);
        user.ResetCode = null;
        user.ResetCodeExpiry = null;
        await _context.SaveChangesAsync();

        TempData["Success"] = "Mật khẩu đã được thay đổi thành công. Vui lòng đăng nhập.";
        return Redirect("/user/auth/login");
    }

}
