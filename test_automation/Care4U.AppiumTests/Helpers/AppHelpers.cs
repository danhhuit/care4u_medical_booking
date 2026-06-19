using OpenQA.Selenium.Appium.Android;

namespace Care4U.AppiumTests.Helpers;

/// <summary>
/// Các hàm tiện ích điều hướng và tương tác với giao diện Care4U.
/// Sử dụng mobile:clickGesture (Appium v5 / UiAutomator2).
/// </summary>
public static class AppHelpers
{
    public static string AdbPath { get; set; } = "adb.exe";
    public static string DeviceName { get; set; } = "emulator-5554";

    private static void RunAdb(string args)
    {
        var psi = new System.Diagnostics.ProcessStartInfo(AdbPath, $"-s {DeviceName} {args}")
        {
            UseShellExecute        = false,
            CreateNoWindow         = true,
            RedirectStandardOutput = true,
            RedirectStandardError  = true
        };
        using var p = System.Diagnostics.Process.Start(psi)!;
        p.WaitForExit();
    }

    public static string GetPageSource(AndroidDriver d)
    {
        try
        {
            string src = d.PageSource;
            if (src.Contains("isn't responding") || src.Contains("Wait"))
            {
                Console.WriteLine("[WARN] ANR detected! Tapping 'Wait' button...");
                RunAdb("shell input tap 540 1391");
                Thread.Sleep(1500);
                src = d.PageSource;
            }
            return src;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[WARN] PageSource call failed: {ex.Message}");
            return "";
        }
    }

    // ─── Navigation ──────────────────────────────────────────────
    
    /// <summary>Chờ splash xong và điều hướng đến màn hình Đăng nhập bệnh nhân.</summary>
    public static void NavigateToPatientLogin(AndroidDriver d, int w, int h, string adb, string device)
    {
        var sw = System.Diagnostics.Stopwatch.StartNew();
        while (sw.Elapsed.TotalSeconds < 40)
        {
            if (GetPageSource(d).Contains("Đăng nhập")) break;
            Thread.Sleep(2000);
        }
        Thread.Sleep(1500); // Đợi màn hình ổn định
    }

    /// <summary>Điều hướng đến màn hình Đăng ký từ màn hình Đăng nhập.</summary>
    public static void NavigateToRegister(AndroidDriver d, int w, int h)
    {
        var sw = System.Diagnostics.Stopwatch.StartNew();
        while (sw.Elapsed.TotalSeconds < 40)
        {
            if (GetPageSource(d).Contains("Đăng nhập")) break;
            Thread.Sleep(2000);
        }
        Thread.Sleep(1500); // Đợi màn hình ổn định
        TapAt(d, w, h, 708, 1565); // Tọa độ chính xác nút "Đăng kí ngay"
        Thread.Sleep(2500);
    }

    /// <summary>Điều hướng đến màn hình Đăng nhập bác sĩ (nút "Đăng nhập Bác sĩ").</summary>
    public static void NavigateToDoctorLogin(AndroidDriver d, int w, int h)
    {
        var sw = System.Diagnostics.Stopwatch.StartNew();
        while (sw.Elapsed.TotalSeconds < 40)
        {
            if (GetPageSource(d).Contains("Đăng nhập")) break;
            Thread.Sleep(2000);
        }
        Thread.Sleep(1500); // Đợi màn hình ổn định
        TapAt(d, w, h, 540, 1438); // Tọa độ chính xác nút "Đăng nhập với tư cách Bác sĩ"
        Thread.Sleep(2500);
    }

    /// <summary>Đảm bảo ứng dụng đang ở màn hình Trang chủ bằng cách nhấn Back nếu đang ở màn hình sâu.</summary>
    public static void EnsureHomeTab(AndroidDriver d, int w, int h, string adb, string device)
    {
        for (int i = 0; i < 4; i++)
        {
            try
            {
                string src = GetPageSource(d);
                if (src.Contains("Tìm bác sĩ riêng"))
                {
                    break;
                }
            }
            catch
            {
                // Ignored
            }
            // Gửi keyevent BACK
            var psi = new System.Diagnostics.ProcessStartInfo(adb, $"-s {device} shell input keyevent 4")
            {
                UseShellExecute        = false,
                CreateNoWindow         = true,
                RedirectStandardOutput = true,
                RedirectStandardError  = true
            };
            using var p = System.Diagnostics.Process.Start(psi)!;
            p.WaitForExit();
            Thread.Sleep(1000);
        }
        TapAt(d, w, h, 142, 2232); // Tap tab Trang chủ
        Thread.Sleep(1500);
    }

    // ─── Đăng nhập bệnh nhân ──────────────────────────────────────

    /// <summary>Đăng nhập bệnh nhân bằng email và mật khẩu.</summary>
    public static void LoginPatient(AndroidDriver d, int w, int h,
                                    string email, string password,
                                    string adb, string device)
    {
        TapAt(d, w, h, 540, 835); Thread.Sleep(400); // Tọa độ chính xác trường Email/SĐT
        AdbInput(adb, device, email);

        TapAt(d, w, h, 540, 1010); Thread.Sleep(400); // Tọa độ chính xác trường Mật khẩu
        AdbInput(adb, device, password);

        HideKeyboard(d);
        TapAt(d, w, h, 540, 1270); // Tọa độ chính xác nút Đăng nhập
        Thread.Sleep(4000);
    }

    /// <summary>Đăng nhập bệnh nhân bằng SĐT và mật khẩu.</summary>
    public static void LoginPatientByPhone(AndroidDriver d, int w, int h,
                                           string phone, string password,
                                           string adb, string device)
    {
        TapAt(d, w, h, 540, 835); Thread.Sleep(400);
        AdbInput(adb, device, phone);

        TapAt(d, w, h, 540, 1010); Thread.Sleep(400);
        AdbInput(adb, device, password);

        HideKeyboard(d);
        TapAt(d, w, h, 540, 1270);
        Thread.Sleep(4000);
    }

    // ─── Đăng ký ──────────────────────────────────────────────────

    /// <summary>Điền form đăng ký và nhấn nút Đăng ký.</summary>
    public static void FillRegisterForm(AndroidDriver d, int w, int h,
                                        string fullName, string email, string phone,
                                        string password, string confirmPassword,
                                        string adb, string device)
    {
        if (!string.IsNullOrEmpty(fullName))
        {
            TapAt(d, w, h, 540, 822); Thread.Sleep(300); // Tọa độ chính xác Họ Tên
            AdbInput(adb, device, fullName);
        }
        if (!string.IsNullOrEmpty(email))
        {
            TapAt(d, w, h, 540, 1003); Thread.Sleep(300); // Tọa độ chính xác Email
            AdbInput(adb, device, email);
        }
        if (!string.IsNullOrEmpty(phone))
        {
            TapAt(d, w, h, 540, 1184); Thread.Sleep(300); // Tọa độ chính xác SĐT
            AdbInput(adb, device, phone);
        }
        if (!string.IsNullOrEmpty(password))
        {
            TapAt(d, w, h, 540, 1359); Thread.Sleep(300); // Tọa độ chính xác Mật khẩu
            AdbInput(adb, device, password);
        }
        if (!string.IsNullOrEmpty(confirmPassword))
        {
            TapAt(d, w, h, 540, 1527); Thread.Sleep(300); // Tọa độ chính xác Nhập lại Mật khẩu
            AdbInput(adb, device, confirmPassword);
        }
        HideKeyboard(d);
        TapAt(d, w, h, 540, 1716); // Tọa độ chính xác nút Đăng ký
        Thread.Sleep(1200);
    }

    // ─── Đăng nhập bác sĩ ─────────────────────────────────────────

    /// <summary>Đăng nhập bác sĩ với SĐT + mật khẩu + mã chứng chỉ.</summary>
    public static void LoginDoctor(AndroidDriver d, int w, int h,
                                   string phone, string password, string license,
                                   string adb, string device)
    {
        TapAt(d, w, h, 540, 1030); Thread.Sleep(300); // Tọa độ chính xác SĐT Bác sĩ
        AdbInput(adb, device, phone);

        TapAt(d, w, h, 540, 1211); Thread.Sleep(300); // Tọa độ chính xác mã chứng chỉ
        AdbInput(adb, device, license);

        TapAt(d, w, h, 540, 1386); Thread.Sleep(300); // Tọa độ chính xác Mật khẩu Bác sĩ
        AdbInput(adb, device, password);

        HideKeyboard(d);
        TapAt(d, w, h, 540, 1645); // Tọa độ chính xác nút Đăng nhập Bác sĩ
        Thread.Sleep(4000);
    }

    // ─── Đăng xuất ────────────────────────────────────────────────

    /// <summary>Logout từ màn hình Home qua Drawer.</summary>
    public static void Logout(AndroidDriver d, int w, int h)
    {
        // 1. Thử mở drawer bằng nút hamburger (tọa độ chính xác 105, 241)
        TapAt(d, w, h, 105, 241);
        Thread.Sleep(1500);
        
        // Thử nhấn nút đăng xuất trong drawer (tọa độ 540, 2250)
        TapAt(d, w, h, 540, 2250);
        Thread.Sleep(2500);

        // 2. Nếu vẫn còn ở màn hình chính (chưa về Đăng nhập), dùng fallback qua Tab Cá Nhân
        string src = GetPageSource(d);
        if (!src.Contains("Đăng nhập") && !src.Contains("Login"))
        {
            // Tap tab Cá Nhân (tọa độ chính xác 949, 2232)
            TapAt(d, w, h, 949, 2232);
            Thread.Sleep(2000);

            // Vuốt xuống để thấy nút Đăng xuất ở cuối qua ADB
            int startX = (int)(540 * (w / 1080.0));
            int startY = (int)(1800 * (h / 2400.0));
            int endX = (int)(540 * (w / 1080.0));
            int endY = (int)(600 * (h / 2400.0));
            RunAdb($"shell input swipe {startX} {startY} {endX} {endY} 400");
            Thread.Sleep(1500);

            // Nhấn nút Đăng xuất ở tab Cá nhân (tọa độ khoảng 540, 2250)
            TapAt(d, w, h, 540, 2250);
            Thread.Sleep(3000);
        }
    }

    // ─── Utility ──────────────────────────────────────────────────

    /// <summary>Nhấn tọa độ có tỷ lệ màn hình qua ADB.</summary>
    public static void TapAt(AndroidDriver d, int w, int h, int baseX, int baseY)
    {
        int sx = (int)(baseX * (w / 1080.0));
        int sy = (int)(baseY * (h / 2400.0));
        RunAdb($"shell input tap {sx} {sy}");
    }

    /// <summary>Nhập text qua ADB input text.</summary>
    public static void AdbInput(string adb, string device, string text)
    {
        string escaped = text
            .Replace("\\", "\\\\")
            .Replace(" ", "%s")
            .Replace("'", "\\'")
            .Replace("(", "\\(")
            .Replace(")", "\\)")
            .Replace("&", "\\&");

        var psi = new System.Diagnostics.ProcessStartInfo(adb, $"-s {device} shell input text {escaped}")
        {
            UseShellExecute        = false,
            CreateNoWindow         = true,
            RedirectStandardOutput = true,
            RedirectStandardError  = true
        };
        using var p = System.Diagnostics.Process.Start(psi)!;
        p.WaitForExit();
    }

    /// <summary>Ẩn bàn phím ảo nếu đang hiển thị.</summary>
    public static void HideKeyboard(AndroidDriver d)
    {
        try
        {
            d.HideKeyboard();
            Thread.Sleep(500);
        }
        catch
        {
            // Bàn phím đã ẩn hoặc không thể ẩn
        }
    }
}
