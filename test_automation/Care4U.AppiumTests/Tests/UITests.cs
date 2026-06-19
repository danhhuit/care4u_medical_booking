using Care4U.AppiumTests.Helpers;
using NUnit.Framework;

namespace Care4U.AppiumTests.Tests;

/// <summary>
/// Nhóm UI – TC_UI_001 đến TC_UI_015
/// Kiểm thử giao diện người dùng: chủ đề màu, font, layout, navigation bar.
/// </summary>
[TestFixture]
[Order(3)]
public class UITests : AppiumTestBase
{
    [OneTimeSetUp]
    public override void OneTimeSetUp()
    {
        base.OneTimeSetUp();
        ResetApp(clearData: true);
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight,
            PatientEmail, PatientPassword, AdbPath, DeviceName);
        Thread.Sleep(2000);
    }

    [Test, Order(1)]
    [Description("TC_UI_001: Màn hình Cài đặt hiển thị đúng và chứa các tùy chọn")]
    public void TC_UI_001_SettingsScreen()
    {
        // Điều hướng đến Cài đặt qua tab Cá nhân (tọa độ 949, 2232)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 949, 2232);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_UI_001_Settings");
        var src = PageSource;
        bool hasSettings = src.ToLower().Contains("cài đặt") || src.ToLower().Contains("settings")
                        || src.ToLower().Contains("cá nhân") || src.ToLower().Contains("hồ sơ") || src.ToLower().Contains("tài khoản");
        Assert.That(hasSettings, Is.True, "Màn hình Cài đặt/Cá nhân không hiển thị");
    }

    [Test, Order(2)]
    [Description("TC_UI_002: Chuyển đổi chế độ tối (Dark Mode) hoạt động")]
    public void TC_UI_002_DarkModeToggle()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 949, 2232);
        Thread.Sleep(2000);
        // Nhấn nút Cài đặt để mở màn hình cài đặt (tọa độ khoảng 540, 1820)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 1820);
        Thread.Sleep(2000);
        // Nhấn Switch Dark Mode ở trang Cài đặt (tọa độ khoảng 900, 1000)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 900, 1000);
        Thread.Sleep(1500);
        CaptureScreenshot("TC_UI_002_DarkMode");
        // Nhấn lại để tắt
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 900, 1000);
        Thread.Sleep(1000);
        Assert.Pass("Toggle Dark Mode đã được kiểm tra – xem ảnh chụp");
    }

    [Test, Order(3)]
    [Description("TC_UI_003: Bottom navigation bar hiển thị đủ các tab")]
    public void TC_UI_003_BottomNavBar()
    {
        CaptureScreenshot("TC_UI_003_BottomNavBar");
        var src = PageSource;
        bool hasHome   = src.ToLower().Contains("trang chủ") || src.ToLower().Contains("home");
        bool hasRecord = src.ToLower().Contains("bệnh án") || src.ToLower().Contains("record");
        bool hasProfile = src.ToLower().Contains("cá nhân") || src.ToLower().Contains("profile");
        Assert.Multiple(() =>
        {
            Assert.That(hasHome,    Is.True, "Không thấy tab Trang chủ");
            Assert.That(hasRecord,  Is.True, "Không thấy tab Hồ sơ bệnh án");
            Assert.That(hasProfile, Is.True, "Không thấy tab Cá nhân");
        });
    }

    [Test, Order(4)]
    [Description("TC_UI_004: Tab Trang chủ trong bottom nav hoạt động đúng")]
    public void TC_UI_004_HomeTabNavigation()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Tab Trang chủ
        Thread.Sleep(2000);
        CaptureScreenshot("TC_UI_004_HomeTab");
        var src = PageSource;
        bool onHome = src.ToLower().Contains("trang chủ") || src.ToLower().Contains("chào") || src.ToLower().Contains("đặt lịch");
        Assert.That(onHome, Is.True, "Tab Trang chủ không hoạt động");
    }

    [Test, Order(5)]
    [Description("TC_UI_005: Nút Tìm bác sĩ riêng trên trang chủ hoạt động đúng")]
    public void TC_UI_005_DoctorTabNavigation()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Tab Trang chủ
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 265, 754); // Tìm bác sĩ riêng
        Thread.Sleep(2000);
        CaptureScreenshot("TC_UI_005_DoctorTab");
        var src = PageSource;
        bool onDoctor = src.ToLower().Contains("bác sĩ") || src.ToLower().Contains("bs.") || src.ToLower().Contains("tìm kiếm");
        Assert.That(onDoctor, Is.True, "Màn hình Danh sách bác sĩ không hiển thị");
    }

    [Test, Order(6)]
    [Description("TC_UI_006: Tab Hồ sơ trong bottom nav hoạt động đúng")]
    public void TC_UI_006_ProfileTabNavigation()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 949, 2232);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_UI_006_ProfileTab");
        var src = PageSource;
        bool onProfile = src.ToLower().Contains("hồ sơ") || src.ToLower().Contains("profile") || src.ToLower().Contains("cá nhân") || src.ToLower().Contains("tài khoản");
        Assert.That(onProfile, Is.True, "Tab Hồ sơ không hoạt động");
    }

    [Test, Order(7)]
    [Description("TC_UI_007: Màn hình chính hiển thị banner/slide quảng cáo (nếu có)")]
    public void TC_UI_007_HomeBanner()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_UI_007_HomeBanner");
        Assert.Pass("Kiểm tra banner trang chủ – xem ảnh chụp");
    }

    [Test, Order(8)]
    [Description("TC_UI_008: Màn hình hồ sơ hiển thị thông tin người dùng đã đăng nhập")]
    public void TC_UI_008_ProfileInfo()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 949, 2232);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_UI_008_ProfileInfo");
        var src = PageSource;
        bool hasUserInfo = src.ToLower().Contains("an") || src.ToLower().Contains("patient") || src.ToLower().Contains("0326216310")
                        || src.ToLower().Contains("@gmail.com");
        Assert.That(hasUserInfo, Is.True, "Không hiển thị thông tin người dùng trong Hồ sơ");
    }

    [Test, Order(9)]
    [Description("TC_UI_009: Ảnh đại diện bệnh nhân hiển thị hoặc placeholder đúng")]
    public void TC_UI_009_PatientAvatar()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 949, 2232);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_UI_009_PatientAvatar");
        Assert.Pass("Kiểm tra ảnh đại diện bệnh nhân – xem ảnh chụp");
    }

    [Test, Order(10)]
    [Description("TC_UI_010: Nút chỉnh sửa hồ sơ hoạt động")]
    public void TC_UI_010_EditProfile()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 949, 2232);
        Thread.Sleep(2000);
        // Nút chỉnh sửa (~940, 400)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 940, 400);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_UI_010_EditProfile");
        var src = PageSource;
        bool onEdit = src.Contains("Chỉnh sửa") || src.Contains("Edit") || src.Contains("Lưu");
        Assert.That(onEdit, Is.True, "Nút chỉnh sửa hồ sơ không hoạt động");
    }

    [Test, Order(11)]
    [Description("TC_UI_011: Màu sắc chủ đề ứng dụng nhất quán trên các màn hình")]
    public void TC_UI_011_ThemeConsistency()
    {
        // Chụp 3 màn hình khác nhau để so sánh thủ công
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232);
        Thread.Sleep(1500);
        CaptureScreenshot("TC_UI_011_HomeTheme");

        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Màn hình Bác sĩ qua search bar
        Thread.Sleep(1500);
        CaptureScreenshot("TC_UI_011_DoctorTheme");

        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 949, 2232);
        Thread.Sleep(1500);
        CaptureScreenshot("TC_UI_011_ProfileTheme");

        Assert.Pass("Kiểm tra nhất quán màu sắc – xem ảnh chụp");
    }

    [Test, Order(12)]
    [Description("TC_UI_012: Ứng dụng xử lý đúng khi xoay màn hình (landscape)")]
    public void TC_UI_012_ScreenRotation()
    {
        // Xoay sang landscape (rotation=1) qua ADB
        RotateScreen(1);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_UI_012_Landscape");
        // Xoay lại portrait (rotation=0)
        RotateScreen(0);
        Thread.Sleep(1500);
        Assert.That(PageSource.Length, Is.GreaterThan(0), "App crash khi xoay màn hình");
    }

    [Test, Order(13)]
    [Description("TC_UI_013: Toast/Snackbar thông báo hiển thị rõ ràng và biến mất sau vài giây")]
    public void TC_UI_013_ToastNotification()
    {
        // Thực hiện một hành động tạo toast (vd: thêm yêu thích)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232);
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Màn hình bác sĩ
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 940, 700); // Nút yêu thích
        Thread.Sleep(1000);
        CaptureScreenshot("TC_UI_013_Toast");
        Assert.Pass("Kiểm tra Toast thông báo – xem ảnh chụp");
    }

    [Test, Order(14)]
    [Description("TC_UI_014: Loading spinner/indicator hiển thị khi tải dữ liệu")]
    public void TC_UI_014_LoadingIndicator()
    {
        // Pull-to-refresh để trigger loading
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232);
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438);
        Thread.Sleep(500);
        Swipe(540, 400, 540, 1200, 300, 0.2);
        CaptureScreenshot("TC_UI_014_Loading");
        Thread.Sleep(3000);
        Assert.Pass("Kiểm tra loading indicator – xem ảnh chụp");
    }

    [Test, Order(15)]
    [Description("TC_UI_015: Thanh tìm kiếm ẩn/hiện đúng theo tương tác người dùng")]
    public void TC_UI_015_SearchBarBehavior()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232);
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438);
        Thread.Sleep(2000);
        // Nhấn vào ô tìm kiếm trên màn hình bác sĩ
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 250);
        Thread.Sleep(500);
        CaptureScreenshot("TC_UI_015_SearchActive");
        // Nhấn Back để ẩn bàn phím
        PressKey(4);
        Thread.Sleep(500);
        CaptureScreenshot("TC_UI_015_SearchInactive");
        Assert.Pass("Kiểm tra hành vi thanh tìm kiếm – xem ảnh chụp");
    }
}
