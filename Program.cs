using Microsoft.EntityFrameworkCore;
using thuvienso.Data;
try
{
    var builder = WebApplication.CreateBuilder(args);
// Ghi checkpoint sớm nhất có thể
File.WriteAllText("logs/checkpoint1.txt", "App bắt đầu chạy");

// ===== Đăng ký Razor Pages, Cookie Auth, EF Core, Session =====
builder.Services.AddControllersWithViews();

builder.Services.AddAuthentication("AdminAuth")
    .AddCookie("AdminAuth", options =>
    {
        options.LoginPath = "/admin/auth/login";
        options.LogoutPath = "/admin/auth/logout";
        options.AccessDeniedPath = "/admin/auth/denied";
    });

// ✅ Bọc đoạn AddDbContext trong try-catch để ghi log lỗi startup

    var connectionString = builder.Configuration.GetConnectionString("DefaultConnection") ?? "NULL";
    File.WriteAllText("logs/connection.txt", connectionString);
    builder.Services.AddDbContext<AppDbContext>(options =>
        options.UseMySql(
            connectionString,
            ServerVersion.AutoDetect(connectionString)
        )
    );


// ✅ Session cho người dùng cuối
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
});

builder.Services.AddAuthorization();

var app = builder.Build();

// ===== Middleware xử lý static, routing, session, auth =====
app.UseStaticFiles();
app.UseRouting();

app.UseSession(); // ✅ Bắt buộc cho User session
app.UseAuthentication();
app.UseAuthorization();

// ===== Middleware kiểm tra truy cập admin =====
app.Use(async (context, next) =>
{
    var path = context.Request.Path;
    var isAdminArea = path.StartsWithSegments("/admin");

    if (isAdminArea && path == "/admin")
    {
        context.Response.Redirect("/admin/dashboard");
        return;
    }

    var isLoggedIn = context.User?.Identity?.IsAuthenticated ?? false;
    if (isAdminArea && !isLoggedIn &&
        !path.StartsWithSegments("/admin/auth") &&
        context.Request.Method == "GET")
    {
        context.Response.Redirect("/admin/auth/login");
        return;
    }

    await next();
});

// ===== Middleware kiểm tra truy cập người dùng cuối (session-based) =====
app.Use(async (context, next) =>
{
    var path = context.Request.Path;
    var isUserProtected = path.StartsWithSegments("/user/profile")
                        || path.StartsWithSegments("/user/payment")
                        || path.StartsWithSegments("/document");

    var userId = context.Session.GetInt32("UserId");
    if (isUserProtected && userId == null && context.Request.Method == "GET")
    {
        var returnUrl = context.Request.Path + context.Request.QueryString;
        context.Session.SetString("ReturnUrl", returnUrl); // ghi nhớ lâu
        context.Response.Redirect($"/user/auth/login");
        return;
    }
    // Đã đăng nhập → kiểm tra ReturnUrl có tồn tại → redirect 1 lần duy nhất
    else if (userId != null && context.Session.Keys.Contains("ReturnUrl"))
    {
        var returnUrl = context.Session.GetString("ReturnUrl");
        context.Session.Remove("ReturnUrl");
        context.Response.Redirect(returnUrl ?? "/");
        return;
    }

    await next();
});

// ===== Route mặc định người dùng cuối =====
app.MapControllerRoute(
    name: "user",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
}
catch (Exception ex)
{
    File.WriteAllText("logs/startup-error.txt", ex.ToString()); // log lỗi thật vào file
    throw; // vẫn throw để hiển thị lỗi 500
}