using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using PdfSharpCore.Pdf.IO;
using System.Security.Cryptography;
using System.Text;
using thuvienso.Data;
using thuvienso.Helpers;
using thuvienso.Models;

[Route("payment")]
public class PaymentController : Controller
{
    private readonly AppDbContext _context;
    private readonly IConfiguration _config;

    public PaymentController(AppDbContext context, IConfiguration config)
    {
        _context = context;
        _config = config;
    }

    /// <summary>
    /// Tạo hoặc cập nhật yêu cầu thanh toán cho tài liệu.
    /// Quy tắc:
    /// - Mỗi người với mỗi tài liệu chỉ có tối đa 1 bản ghi `paid` + 1 bản ghi `pending`.
    /// - Nếu đã `paid`, được phép tạo `pending` mới (cập nhật nếu đã có).
    /// - Nếu chưa `paid` mà có `pending` → cập nhật dòng đó.
    /// </summary>
    [HttpPost("create")]
    public async Task<IActionResult> Create([FromForm] int documentId, [FromForm] int percent)
    {
        var userId = HttpContext.Session.GetInt32("UserId");
        if (userId == null) return Unauthorized();

        // 👉 Lấy tài liệu
        var document = await _context.Documents.FindAsync(documentId);
        if (document == null || document.IsFree || document.Price == null)
            return BadRequest("Tài liệu không hợp lệ");

        var price = document.Price.Value;
        var percentValue = Math.Clamp(percent, 1, 100);

        // 👉 Lấy bản ghi thanh toán đã thanh toán
        var paymentPaid = await _context.Payments
            .FirstOrDefaultAsync(p => p.UserId == userId && p.DocumentId == documentId && p.PaymentStatus == "paid");

        // 👉 Lấy bản ghi thanh toán đang chờ (QR chưa quét)
        var paymentPending = await _context.Payments
            .FirstOrDefaultAsync(p => p.UserId == userId && p.DocumentId == documentId && p.PaymentStatus == "pending");

        var percentOld = paymentPaid?.PercentPaid ?? 0;
        if (percentValue <= percentOld)
            return BadRequest("Bạn đã thanh toán phần trăm này hoặc cao hơn.");

        // Tính phần cần thanh toán thêm
        var addedPercent = percentValue - percentOld;
        var amount = (int)Math.Round(price * addedPercent / 100);// PayOS dùng đơn vị VND


        // 👉 Tạo orderCode mới
        long orderCode = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
        var baseUrl = _config["PublicUrl"];
        var returnUrl = $"{baseUrl}/user/profile";
        var cancelUrl = $"{baseUrl}/document/{document.Id}";
        var description = $"TL#{document.Id} - +{addedPercent}%";

        var rawSignature = $"amount={amount}&cancelUrl={cancelUrl}&description={description}&orderCode={orderCode}&returnUrl={returnUrl}";
        var signature = ComputeHmacSha256(rawSignature, _config["PayOS:ChecksumKey"]);

        // 👉 Payload gửi PayOS
        var payload = new
        {
            orderCode = orderCode,
            amount = amount,
            description = description,
            cancelUrl = cancelUrl,
            returnUrl = returnUrl,
            webhookUrl = _config["PayOS:WebhookUrl"], // 👈 BẮT BUỘC PHẢI CÓ
            signature = signature
        };

        // 👉 Log để xác minh URL webhook đang dùng
        Console.WriteLine("🌐 Webhook URL đang dùng:");
        Console.WriteLine(payload.webhookUrl);

        //Console.WriteLine("📦 Payload gửi lên:");
        //Console.WriteLine(JsonConvert.SerializeObject(payload));
        //Console.WriteLine("🔐 Raw Signature:");
        //Console.WriteLine(rawSignature);
        //Console.WriteLine("✅ Signature:");
        //Console.WriteLine(signature);

        var client = new HttpClient();
        client.DefaultRequestHeaders.Add("x-client-id", _config["PayOS:ClientId"]);
        client.DefaultRequestHeaders.Add("x-api-key", _config["PayOS:ApiKey"]);
        client.DefaultRequestHeaders.Add("x-checksum", signature);

        var content = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json");
        var response = await client.PostAsync("https://api-merchant.payos.vn/v2/payment-requests", content);
        var resBody = await response.Content.ReadAsStringAsync();

        Console.WriteLine("📥 Response từ PayOS:");
        Console.WriteLine(resBody);

        if (!response.IsSuccessStatusCode)
            return BadRequest("PayOS lỗi: " + resBody);

        var json = JObject.Parse(resBody);
        var data = json["data"];
        if (data == null)
            return BadRequest("Không lấy được dữ liệu từ PayOS");

        var checkoutUrl = data["checkoutUrl"]?.ToString();
        var qrCode = data["qrCode"]?.ToString();

        // 👉 Tạo ảnh QR VietQR (từ chuỗi QR trả về)
        var qrImage = $"https://api.qrserver.com/v1/create-qr-code/?size=250x250&data={Uri.EscapeDataString(qrCode)}";

        // 👉 Nếu đã có payment `pending` → cập nhật
        if (paymentPending != null)
        {
            paymentPending.PercentPaid = percentValue;
            paymentPending.PricePaid = (int)Math.Round(price * percentValue / 100);
            paymentPending.OrderCode = orderCode.ToString();
            paymentPending.QrCodeUrl = qrImage;
            paymentPending.CheckoutUrl = checkoutUrl;
            paymentPending.UpdatedAt = DateTime.Now;
        }
        else
        {
            // 👉 Chưa có → thêm mới dòng `pending`
            var newPayment = new Payment
            {
                UserId = userId.Value,
                DocumentId = document.Id,
                PercentPaid = percentValue,
                TotalPrice = price,
                PricePaid = (int)Math.Round(price * percentValue / 100),
                OrderCode = orderCode.ToString(),
                PaymentStatus = "pending",
                QrCodeUrl = qrImage,
                CheckoutUrl = checkoutUrl,
                CreatedAt = DateTime.Now,
                UpdatedAt = DateTime.Now
            };
            _context.Payments.Add(newPayment);
        }

        await _context.SaveChangesAsync();

        return Json(new
        {
            success = true,
            qrCodeUrl = qrImage,
            checkoutUrl = checkoutUrl
        });
    }

    [HttpGet("confirm-webhook-test")]
    public async Task<IActionResult> ConfirmWebhookTest()
    {
        return await ConfirmWebhook(); // Gọi lại hàm đã có sẵn
    }

    [HttpPost("confirm-webhook")]
    public async Task<IActionResult> ConfirmWebhook()
    {
        var webhookUrl = _config["PayOS:WebhookUrl"];

        var payload = new
        {
            webhookUrl = webhookUrl
        };

        var client = new HttpClient();
        client.DefaultRequestHeaders.Add("x-client-id", _config["PayOS:ClientId"]);
        client.DefaultRequestHeaders.Add("x-api-key", _config["PayOS:ApiKey"]);

        var content = new StringContent(JsonConvert.SerializeObject(payload), Encoding.UTF8, "application/json");
        var response = await client.PostAsync("https://api-merchant.payos.vn/confirm-webhook", content);
        var resBody = await response.Content.ReadAsStringAsync();

        Console.WriteLine("📡 Kết quả xác minh webhook:");
        Console.WriteLine(resBody);

        return Content(resBody, "application/json");
    }


    [HttpPost("webhook")]
    public async Task<IActionResult> Webhook()
    {
        Request.EnableBuffering(); // Cho phép đọc nhiều lần body

        using var reader = new StreamReader(Request.Body, Encoding.UTF8, leaveOpen: true);
        var body = await reader.ReadToEndAsync();
        Request.Body.Position = 0; // Reset lại để middleware khác dùng

        Console.WriteLine("📥 Webhook nhận được:");
        Console.WriteLine(body);

        try
        {
            var payload = JObject.Parse(body);
            var eventData = payload["data"] as JObject;
            var receivedSignature = payload["signature"]?.ToString();

            // ✅ Trường hợp test webhook
            if (eventData == null || eventData["orderCode"]?.ToString() == "123")
            {
                Console.WriteLine("✅ Xác minh webhook test từ PayOS");
                return Ok(new { code = "00", message = "Confirm webhook successfully" });
            }

            // ✅ Tạo chuỗi signature để xác minh
            var sortedKeys = eventData.Properties()
                .Select(p => p.Name)
                .OrderBy(name => name)
                .ToList();

            var signatureBase = new StringBuilder();
            foreach (var key in sortedKeys)
            {
                var value = eventData[key]?.ToString() ?? "";
                signatureBase.Append($"{key}={value}");
                if (key != sortedKeys.Last()) signatureBase.Append("&");
            }

            var expectedSignature = ComputeHmacSha256(signatureBase.ToString(), _config["PayOS:ChecksumKey"]);

            if (receivedSignature != expectedSignature)
            {
                Console.WriteLine("❌ Signature không hợp lệ.");
                return Unauthorized();
            }

            // ✅ Trích thông tin đơn hàng
            var orderCode = eventData["orderCode"]?.ToString();
            var codeResult = payload["code"]?.ToString();

            if (string.IsNullOrEmpty(orderCode) || string.IsNullOrEmpty(codeResult))
            {
                Console.WriteLine("❌ Thiếu orderCode hoặc code trong webhook.");
                return Ok();
            }

            // ✅ Mapping code → newStatus chuẩn hệ thống
            string newStatus = codeResult switch
            {
                "00" => "paid",
                "01" => "failed",
                "02" => "canceled",
                "03" => "pending",
                "04" => "canceled",
                _ => "pending"
            };

            var payment = await _context.Payments.FirstOrDefaultAsync(p => p.OrderCode == orderCode);

            if (payment == null)
            {
                Console.WriteLine($"⚠️ Không tìm thấy đơn: {orderCode}");
                return NotFound();
            }

            if (payment.PaymentStatus == newStatus)
            {
                Console.WriteLine($"⚠️ Đơn {orderCode} đã có trạng thái '{newStatus}', không cập nhật.");
                return Ok();
            }

            // ✅ Cập nhật trạng thái và thời gian
            payment.PaymentStatus = newStatus;
            payment.TransactionTime = DateTime.Now;
            payment.UpdatedAt = DateTime.Now;

            // ✅ Nếu là thanh toán thành công → xử lý preview hoặc xoá
            if (newStatus == "paid")
            {
                var document = await _context.Documents.FindAsync(payment.DocumentId);
                var user = await _context.Users.FindAsync(payment.UserId);

                if (document != null && user != null && !string.IsNullOrEmpty(document.FileUrl))
                {
                    var userPreviewFolder = Path.Combine("wwwroot", "payment", $"user-{user.Id}", $"document-{document.Id}");
                    var fileName = Path.GetFileName(document.FileUrl);
                    var outputPdf = Path.Combine(userPreviewFolder, fileName);
                    var sourcePdf = Path.Combine("wwwroot", document.FileUrl.TrimStart('/').Replace("/", Path.DirectorySeparatorChar.ToString()));

                    if (payment.PercentPaid >= 100)
                    {
                        if (Directory.Exists(userPreviewFolder))
                        {
                            Directory.Delete(userPreviewFolder, true);
                            Console.WriteLine("🧹 Đã xoá thư mục preview riêng vì thanh toán 100%");
                        }
                    }
                    else
                    {
                        Directory.CreateDirectory(userPreviewFolder);

                        if (System.IO.File.Exists(sourcePdf))
                        {
                            bool success = GeneratePartialPreview(sourcePdf, outputPdf, payment.PercentPaid);
                            Console.WriteLine(success ? $"✅ Tạo preview cá nhân ({fileName}) thành công" : "❌ Tạo preview thất bại");
                        }
                    }

                    SendPaymentSuccessEmail(_config, user.Email, document.Title);
                }

                if (document != null)
                {
                    document.Purchase += 1;
                    _context.Documents.Update(document);
                    await _context.SaveChangesAsync();
                }
            }
            else if (newStatus == "canceled")
            {
                Console.WriteLine($"🚫 Đơn hàng {orderCode} bị **huỷ**.");
            }
            else if (newStatus == "failed")
            {
                Console.WriteLine($"❌ Đơn hàng {orderCode} **thanh toán thất bại**.");
            }
            else
            {
                Console.WriteLine($"ℹ️ Trạng thái mới không cần xử lý thêm: {newStatus}");
            }

            await _context.SaveChangesAsync();
            Console.WriteLine($"✅ Đã cập nhật đơn hàng {orderCode} → {newStatus}");
            return Ok();
        }
        catch (Exception ex)
        {
            Console.WriteLine("❌ Lỗi xử lý webhook:");
            Console.WriteLine(ex.Message);
            return Ok(new { code = "00", message = "Fallback for malformed webhook" });
        }
    }








    private static string ComputeHmacSha256(string rawData, string key)
    {
        var keyBytes = Encoding.UTF8.GetBytes(key);
        var rawBytes = Encoding.UTF8.GetBytes(rawData);

        using (var hmac = new System.Security.Cryptography.HMACSHA256(keyBytes))
        {
            var hashBytes = hmac.ComputeHash(rawBytes);
            return BitConverter.ToString(hashBytes).Replace("-", "").ToLowerInvariant();
        }
    }

    private void SendPaymentSuccessEmail(IConfiguration config, string userEmail, string documentTitle)
    {
        var mail = new MailHelper(config);
        string subject = $"Xác nhận thanh toán thành công – {documentTitle}";

        string body = $@"
        <!DOCTYPE html>
        <html>
        <body style='font-family: Arial, sans-serif; background-color: #f8f9fa; padding: 30px;'>
          <div style='max-width:600px;margin:0 auto;background:#fff;border-radius:6px;border:1px solid #dee2e6;overflow:hidden;'>
            <div style='background:#0d6efd;color:white;padding:20px 30px;'>
              <h2 style='margin:0;font-size:20px;text-align: center'>Bạn đã thanh toán thành công</h2>
            </div>
            <div style='padding:30px;'>
              <h3 style='color:#0d6efd;'>Tài liệu: {documentTitle}</h3>
              <p>Cảm ơn bạn đã ủng hộ <strong>Thư Viện Số</strong>.</p>
              <p>Bạn có thể kiểm tra các tài liệu đã thanh toán và tải xuống tại đây:</p>
              <p style='margin-top: 20px; text-align: center;'>
                <a href='{_config["PublicUrl"]}/user/profile' style='display: inline-block; background: #0d6efd; color: white; padding: 10px 20px; border-radius: 4px; text-decoration: none;'>Truy cập tài liệu của bạn</a>
              </p>
            </div>
            <div style='background:#f1f3f5;color:#6c757d;text-align:center;padding:15px;'>
              <small>© 2025 <strong>Thư Viện Số</strong> – Email tự động, vui lòng không trả lời</small>
            </div>
          </div>
        </body>
        </html>";


        mail.Send(userEmail, subject, body);
    }

    // Build ra tài liệu theo phần trăm đã thanh toán từ tài liệu gốc
    private bool GeneratePartialPreview(string inputPdfPath, string outputPdfPath, decimal percentPaid)
    {
        try
        {
            using var input = PdfSharpCore.Pdf.IO.PdfReader.Open(inputPdfPath, PdfDocumentOpenMode.Import);
            using var output = new PdfSharpCore.Pdf.PdfDocument();

            int totalPages = input.PageCount;
            int pageCountToKeep = (int)Math.Ceiling(totalPages * (percentPaid / 100m));

            for (int i = 0; i < pageCountToKeep && i < totalPages; i++)
            {
                output.AddPage(input.Pages[i]);
            }

            output.Save(outputPdfPath);
            return true;
        }
        catch (Exception ex)
        {
            Console.WriteLine("❌ Lỗi khi tạo bản preview theo phần trăm: " + ex.Message);
            return false;
        }
    }

}
