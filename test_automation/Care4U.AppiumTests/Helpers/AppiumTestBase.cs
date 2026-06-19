using Microsoft.Extensions.Configuration;
using OpenQA.Selenium;
using OpenQA.Selenium.Appium;
using OpenQA.Selenium.Appium.Android;
using System.Diagnostics;
using System.Net.Sockets;

namespace Care4U.AppiumTests.Helpers;

/// <summary>
/// Base class khởi tạo và quản lý Appium driver (Appium v5 / Selenium 4).
/// </summary>
public abstract class AppiumTestBase : IDisposable
{
    protected AndroidDriver Driver = null!;
    protected IConfiguration Config = null!;
    protected string ScreenshotDir = string.Empty;

    // ─── Credentials ────────────────────────────────────────────────
    protected string PatientEmail    => Config["TestData:PatientEmail"]!;
    protected string PatientPassword => Config["TestData:PatientPassword"]!;
    protected string PatientPhone    => Config["TestData:PatientPhone"]!;
    protected string DoctorPhone1    => Config["TestData:DoctorPhone1"]!;
    protected string DoctorLicense1  => Config["TestData:DoctorLicense1"]!;
    protected string DoctorPassword  => Config["TestData:DoctorPassword"]!;
    protected string AdminEmail      => Config["TestData:AdminEmail"]!;
    protected string AdminPassword   => Config["TestData:AdminPassword"]!;
    protected string AdbPath         => Config["TestData:AdbPath"]!;
    protected string AppPackage      => Config["Appium:AppPackage"]!;
    protected string DeviceName      => Config["Appium:DeviceName"]!;

    protected int DeviceWidth  = 1080;
    protected int DeviceHeight = 2400;

    [OneTimeSetUp]
    public virtual void OneTimeSetUp()
    {
        // 1. Load config
        Config = new ConfigurationBuilder()
            .AddJsonFile("appsettings.json", optional: false, reloadOnChange: false)
            .Build();

        // Initialize AppHelpers static config
        AppHelpers.AdbPath = AdbPath;
        AppHelpers.DeviceName = DeviceName;


        // 2. Screenshots directory
        ScreenshotDir = Path.Combine(
            AppContext.BaseDirectory,
            Config["Screenshots:Directory"] ?? "Screenshots");
        Directory.CreateDirectory(ScreenshotDir);

        // 3. Start Appium server if needed
        StartAppiumIfNeeded();

        // 4. Build capabilities (Appium v5 – AddAdditionalAppiumOption instead of indexer)
        var opts = new AppiumOptions();
        opts.PlatformName  = Config["Appium:PlatformName"]!;
        opts.AutomationName = Config["Appium:AutomationName"]!;
        opts.DeviceName    = Config["Appium:DeviceName"]!;
        opts.AddAdditionalAppiumOption("appPackage",        Config["Appium:AppPackage"]!);
        opts.AddAdditionalAppiumOption("appActivity",       Config["Appium:AppActivity"]!);
        opts.AddAdditionalAppiumOption("noReset",           bool.Parse(Config["Appium:NoReset"]!));
        opts.AddAdditionalAppiumOption("newCommandTimeout", int.Parse(Config["Appium:NewCommandTimeout"]!));
        opts.AddAdditionalAppiumOption("autoGrantPermissions", true);
        opts.AddAdditionalAppiumOption("settings[waitForIdleTimeout]", 0);

        var serverUri = new Uri(Config["Appium:ServerUrl"]!);
        Driver = new AndroidDriver(serverUri, opts, TimeSpan.FromSeconds(90));

        var size = Driver.Manage().Window.Size;
        DeviceWidth  = size.Width;
        DeviceHeight = size.Height;
        Console.WriteLine($"Driver connected. Screen: {DeviceWidth}x{DeviceHeight}");
    }

    [OneTimeTearDown]
    public virtual void OneTimeTearDown()
    {
        Dispose();
    }

    public void Dispose()
    {
        Driver?.Dispose();
        Console.WriteLine("Driver disposed.");
    }

    protected string PageSource => AppHelpers.GetPageSource(Driver);

    // ───────────────────── Touch helpers ─────────────────────────

    /// <summary>Tap tại tọa độ có tỷ lệ theo màn hình cơ sở 1080x2400.</summary>
    protected void Tap(int x, int y, double delaySeconds = 1.5)
    {
        int sx = (int)(x * (DeviceWidth  / 1080.0));
        int sy = (int)(y * (DeviceHeight / 2400.0));
        RunAdb($"shell input tap {sx} {sy}");
        Thread.Sleep(TimeSpan.FromSeconds(delaySeconds));
    }

    /// <summary>Vuốt màn hình.</summary>
    protected void Swipe(int x1, int y1, int x2, int y2, int durationMs = 400, double delaySeconds = 1.5)
    {
        int sx1 = (int)(x1 * (DeviceWidth  / 1080.0));
        int sy1 = (int)(y1 * (DeviceHeight / 2400.0));
        int sx2 = (int)(x2 * (DeviceWidth  / 1080.0));
        int sy2 = (int)(y2 * (DeviceHeight / 2400.0));
        RunAdb($"shell input swipe {sx1} {sy1} {sx2} {sy2} {durationMs}");
        Thread.Sleep(TimeSpan.FromSeconds(delaySeconds));
    }

    /// <summary>Nhập text qua ADB.</summary>
    protected void TypeTextAdb(string text, double delaySeconds = 1.0)
    {
        string escaped = text
            .Replace("\\", "\\\\")
            .Replace(" ", "%s")
            .Replace("'", "\\'");
        RunAdb($"shell input text {escaped}");
        Thread.Sleep(TimeSpan.FromSeconds(delaySeconds));
    }

    /// <summary>Nhấn phím ADB keyevent.</summary>
    protected void PressKey(int keyCode, double delaySeconds = 1.0)
    {
        RunAdb($"shell input keyevent {keyCode}");
        Thread.Sleep(TimeSpan.FromSeconds(delaySeconds));
    }

    /// <summary>Xóa nội dung field đang focus.</summary>
    protected void ClearFieldAdb(int backspaceCount = 60, double delaySeconds = 0.5)
    {
        RunAdb("shell input keyevent 123"); // KEYCODE_MOVE_END
        for (int i = 0; i < backspaceCount; i++)
            RunAdb("shell input keyevent 67"); // KEYCODE_DEL
        Thread.Sleep(TimeSpan.FromSeconds(delaySeconds));
    }

    /// <summary>Chụp ảnh màn hình và lưu bằng ADB.</summary>
    protected string CaptureScreenshot(string name)
    {
        if (Config["Screenshots:Enabled"] != null && !bool.Parse(Config["Screenshots:Enabled"]!))
        {
            return string.Empty;
        }
        Thread.Sleep(1000);
        var filepath = Path.Combine(ScreenshotDir, $"{name}.png");
        try
        {
            RunAdb("shell screencap -p /sdcard/screencap_temp.png");
            RunAdb($"pull /sdcard/screencap_temp.png \"{filepath}\"");
            Console.WriteLine($"Screenshot (via ADB): {filepath}");
        }
        catch (Exception ex)
        {
            Console.WriteLine($"[WARN] ADB screenshot failed: {ex.Message}. Falling back to driver screenshot.");
            try
            {
                var ss = ((ITakesScreenshot)Driver).GetScreenshot();
                ss.SaveAsFile(filepath);
            }
            catch (Exception ex2)
            {
                Console.WriteLine($"[WARN] Fallback screenshot failed: {ex2.Message}");
            }
        }
        return filepath;
    }

    protected void ResetApp(double delaySeconds = 12.0, bool clearData = false)
    {
        RunAdb("shell settings put global stay_on_while_plugged_in 3");
        RunAdb("shell input keyevent 224");
        RunAdb("shell wm dismiss-keyguard");

        bool isAuthTest = this.GetType().Name.Contains("Auth");

        if (isAuthTest)
        {
            try
            {
                string src = Driver.PageSource;
                if (src.Contains("Đăng nhập") && !src.Contains("isn't responding"))
                {
                    Console.WriteLine("App is already on login screen. Skipping reset.");
                    return;
                }
                if (src.Contains("Trang chủ") || src.Contains("Bác sĩ") || src.Contains("Đặt lịch") || src.Contains("Hồ sơ"))
                {
                    Console.WriteLine("App is logged in. Attempting logout via UI...");
                    AppHelpers.Logout(Driver, DeviceWidth, DeviceHeight);
                    src = Driver.PageSource;
                    if (src.Contains("Đăng nhập"))
                    {
                        Console.WriteLine("Logout successful. Skipping hard reset.");
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"[WARN] UI-based reset check failed: {ex.Message}");
            }
        }

        Console.WriteLine("Performing hard reset via Appium API...");
        try { Driver.TerminateApp(AppPackage); } catch (Exception e) { Console.WriteLine($"TerminateApp failed: {e.Message}"); }
        if (clearData)
        {
            RunAdb($"shell pm clear {AppPackage}");
            RunAdb($"shell pm grant {AppPackage} android.permission.ACCESS_FINE_LOCATION");
            RunAdb($"shell pm grant {AppPackage} android.permission.ACCESS_COARSE_LOCATION");
            RunAdb($"shell pm grant {AppPackage} android.permission.POST_NOTIFICATIONS");
        }

        try { Driver.ActivateApp(AppPackage); } catch { RunAdb($"shell am start-activity -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -f 0x10200000 -n {AppPackage}/.MainActivity"); }
        Thread.Sleep(TimeSpan.FromSeconds(delaySeconds));
    }

    /// <summary>Xoay màn hình qua ADB (0=portrait, 1=landscape).</summary>
    protected void RotateScreen(int rotation)
    {
        RunAdb($"shell settings put system accelerometer_rotation 0");
        RunAdb($"shell settings put system user_rotation {rotation}");
        Thread.Sleep(1500);
    }

    protected void RunAdb(string args)
    {
        var psi = new ProcessStartInfo(AdbPath, $"-s {DeviceName} {args}")
        {
            RedirectStandardOutput = true,
            RedirectStandardError  = true,
            UseShellExecute        = false,
            CreateNoWindow         = true
        };
        using var p = Process.Start(psi)!;
        string stdout = p.StandardOutput.ReadToEnd();
        string stderr = p.StandardError.ReadToEnd();
        p.WaitForExit();
        if (p.ExitCode != 0 || !string.IsNullOrWhiteSpace(stderr))
        {
            Console.WriteLine($"[ADB Log] cmd: adb -s {DeviceName} {args}\nExitCode: {p.ExitCode}\nStderr: {stderr}\nStdout: {stdout}");
        }
    }

    // ───────────────────── Appium server ─────────────────────────

    private static void StartAppiumIfNeeded()
    {
        if (IsPortOpen(4723))
        {
            Console.WriteLine("Appium server already running on 4723.");
            return;
        }
        Console.WriteLine("Starting Appium server...");
        var appdata = Environment.GetEnvironmentVariable("APPDATA") ?? string.Empty;
        var appiumCmd = Path.Combine(appdata, "npm", "appium.cmd");
        if (!File.Exists(appiumCmd)) appiumCmd = "appium";

        var psi = new ProcessStartInfo(appiumCmd, "--log-timestamp")
        {
            UseShellExecute        = false,
            CreateNoWindow         = true,
            RedirectStandardOutput = false,
            RedirectStandardError  = false
        };
        Process.Start(psi);

        for (int i = 0; i < 30; i++)
        {
            if (IsPortOpen(4723)) { Console.WriteLine("Appium started."); return; }
            Thread.Sleep(1000);
        }
        Console.WriteLine("[WARN] Appium may not have started in time.");
    }

    private static bool IsPortOpen(int port)
    {
        try { using var c = new TcpClient(); c.Connect("127.0.0.1", port); return true; }
        catch { return false; }
    }
}
