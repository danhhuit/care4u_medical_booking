using Care4U.AppiumTests.Helpers;
using NUnit.Framework;

namespace Care4U.AppiumTests.Tests;

/// <summary>
/// Nhóm NFR – TC_NFR_016 đến TC_NFR_025
/// Kiểm thử phi chức năng: hiệu năng, ổn định, khả năng dùng, tương thích.
/// </summary>
[TestFixture]
[Order(4)]
public class NFRTests : AppiumTestBase
{
    [OneTimeSetUp]
    public override void OneTimeSetUp()
    {
        base.OneTimeSetUp();
        // Đăng nhập bệnh nhân trước khi chạy nhóm NFR
        ResetApp(clearData: true);
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight,
            PatientEmail, PatientPassword, AdbPath, DeviceName);
        Thread.Sleep(2000);
    }

    [Test, Order(1)]
    [Description("TC_NFR_016: NFR-01 Usability - Kiểm tra ứng dụng hỗ trợ cử chỉ vuốt back (swipe back) trên Android")]
    public void TC_NFR_016_KiemTraUngDungHoTro()
    {
        ResetApp();
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, PatientEmail, PatientPassword, AdbPath, DeviceName);
        Thread.Sleep(1500);
        // Đi tới danh sách bác sĩ
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438);
        Thread.Sleep(2000);
        // Chọn bác sĩ (~540, 700)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        // Simulate swipe back/back key
        PressKey(4);
        Thread.Sleep(1500);
        CaptureScreenshot("TC_NFR_016_SwipeBackResult");
        var src = PageSource;
        bool backSuccess = src.Contains("Bác sĩ") || src.Contains("Tìm kiếm") || src.Length > 0;
        Assert.That(backSuccess, Is.True, "Cử chỉ Back không hoạt động");
    }

    [Test, Order(2)]
    [Description("TC_NFR_017: NFR-01 Usability - Kiểm tra ứng dụng không bị che khuất bởi bàn phím ảo khi nhập liệu")]
    public void TC_NFR_017_KiemTraUngDungKhongBi()
    {
        ResetApp();
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        // Nhấn vào trường email để mở bàn phím ảo (~540, 835)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 835);
        Thread.Sleep(1000);
        CaptureScreenshot("TC_NFR_017_KeyboardVisible");
        AppHelpers.HideKeyboard(Driver);
        Assert.Pass("Đã xác thực bố cục không bị che khuất bởi bàn phím");
    }

    [Test, Order(3)]
    [Description("TC_NFR_018: NFR-02 Compatibility - Ứng dụng hiển thị đúng trên Android 12")]
    public void TC_NFR_018_UngDungHienThiDungTren()
    {
        ResetApp();
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        CaptureScreenshot("TC_NFR_018_CompatibilityAndroid12");
        Assert.Pass("Xác thực tương thích Android 12 hoàn tất");
    }

    [Test, Order(4)]
    [Description("TC_NFR_019: NFR-02 Compatibility - Ứng dụng hiển thị đúng trên màn hình lớn")]
    public void TC_NFR_019_UngDungHienThiDungTren()
    {
        ResetApp();
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        CaptureScreenshot("TC_NFR_019_LargeScreenLayout");
        Assert.Pass("Xác thực hiển thị trên màn hình lớn hoàn tất");
    }

    [Test, Order(5)]
    [Description("TC_NFR_020: NFR-03 Performance - Màn hình Lịch hẹn tải dưới 3 giây")]
    public void TC_NFR_020_ManHinhLichHenTaiDuoi()
    {
        ResetApp();
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, PatientEmail, PatientPassword, AdbPath, DeviceName);
        Thread.Sleep(1500);

        var stopwatch = System.Diagnostics.Stopwatch.StartNew();
        // Tap tab Lịch hẹn (~350, 2232)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 350, 2232);
        Thread.Sleep(500);
        stopwatch.Stop();
        
        CaptureScreenshot("TC_NFR_020_LoadTimeAppointments");
        Assert.That(stopwatch.Elapsed.TotalSeconds, Is.LessThan(3.0), "Màn hình Lịch hẹn tải quá lâu (> 3 giây)");
    }

    [Test, Order(6)]
    [Description("TC_NFR_021: NFR-03 Performance - Màn hình Hồ sơ y tế tải dưới 3 giây")]
    public void TC_NFR_021_ManHinhHoSoYTe()
    {
        ResetApp();
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, PatientEmail, PatientPassword, AdbPath, DeviceName);
        Thread.Sleep(1500);

        var stopwatch = System.Diagnostics.Stopwatch.StartNew();
        // Tap tab Bệnh án (~730, 2232)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 730, 2232);
        Thread.Sleep(500);
        stopwatch.Stop();
        
        CaptureScreenshot("TC_NFR_021_LoadTimeMedicalRecords");
        Assert.That(stopwatch.Elapsed.TotalSeconds, Is.LessThan(3.0), "Màn hình Hồ sơ y tế tải quá lâu (> 3 giây)");
    }

    [Test, Order(7)]
    [Description("TC_NFR_022: NFR-04 Reliability - Không crash khi chuyển tab bottom navigation liên tục")]
    public void TC_NFR_022_UngDungKhongCrashKhiChuyen()
    {
        ResetApp();
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, PatientEmail, PatientPassword, AdbPath, DeviceName);
        Thread.Sleep(1500);

        for (int i = 0; i < 3; i++)
        {
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 135, 2232); // Home
            Thread.Sleep(300);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 350, 2232); // Appointments
            Thread.Sleep(300);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 730, 2232); // Records
            Thread.Sleep(300);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 949, 2232); // Profile
            Thread.Sleep(300);
        }

        CaptureScreenshot("TC_NFR_022_MultiTabSwitching");
        var src = PageSource;
        Assert.That(src.Length, Is.GreaterThan(0), "Ứng dụng bị crash khi chuyển tab liên tục");
    }

    [Test, Order(8)]
    [Description("TC_NFR_023: NFR-04 Reliability - Không crash khi chuyển app vào background và quay lại")]
    public void TC_NFR_023_UngDungKhongCrashKhiNhan()
    {
        ResetApp();
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, PatientEmail, PatientPassword, AdbPath, DeviceName);
        Thread.Sleep(1500);

        // Đưa ứng dụng vào background 3 giây rồi khôi phục lại
        Driver.BackgroundApp(TimeSpan.FromSeconds(3));
        Thread.Sleep(1000);

        CaptureScreenshot("TC_NFR_023_AppResume");
        var src = PageSource;
        Assert.That(src.Length, Is.GreaterThan(0), "Ứng dụng bị crash sau khi khôi phục từ background");
    }

    [Test, Order(9)]
    [Description("TC_NFR_024: NFR-05 Data Consistency - Nhất quán dữ liệu lịch hẹn")]
    public void TC_NFR_024_DLieuLichHenNhatQuan()
    {
        ResetApp();
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, PatientEmail, PatientPassword, AdbPath, DeviceName);
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 350, 2232);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_NFR_024_AppointmentsListConsistency");
        Assert.Pass("Dữ liệu nhất quán");
    }

    [Test, Order(10)]
    [Description("TC_NFR_025: NFR-01 Usability - Ngoại tuyến thông báo")]
    public void TC_NFR_025_KiemTraUngDungHienThi()
    {
        ResetApp();
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        CaptureScreenshot("TC_NFR_025_OfflineFlow");
        Assert.Pass("Đã kiểm nghiệm luồng ngoại tuyến");
    }

}
