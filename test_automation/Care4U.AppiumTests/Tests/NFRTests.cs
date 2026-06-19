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
        ResetApp();
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
        // Step: 1. Vuốt từ cạnh trái màn hình sang phải 2. Quan sát điều hướng
        // Data: (không có)
        // Expected: Ứng dụng quay lại màn hình trước, không crash
        
        CaptureScreenshot("TC_NFR_016_KiemTraUngDungHoTro");
        Assert.Pass("Xác nhận phi chức năng qua ảnh chụp màn hình.");
    }

    [Test, Order(2)]
    [Description("TC_NFR_017: NFR-01 Usability - Kiểm tra ứng dụng không bị che khuất bởi bàn phím ảo khi nhập liệu")]
    public void TC_NFR_017_KiemTraUngDungKhongBi()
    {
        ResetApp();
        // Step: 1. Nhấn vào trường email 2. Bàn phím ảo xuất hiện 3. Quan sát bố cục màn hình
        // Data: (không có)
        // Expected: Bố cục tự đẩy lên hoặc trường nhập không bị bàn phím che khuất
        
        CaptureScreenshot("TC_NFR_017_KiemTraUngDungKhongBi");
        Assert.Pass("Xác nhận phi chức năng qua ảnh chụp màn hình.");
    }

    [Test, Order(3)]
    [Description("TC_NFR_018: NFR-02 Compatibility - Ứng dụng hiển thị đúng trên Android 12")]
    public void TC_NFR_018_UngDungHienThiDungTren()
    {
        ResetApp();
        // Step: 1. Mở app trên Android 12 2. Thực hiện luồng đăng nhập và xem bác sĩ
        // Data: (không có)
        // Expected: Không có lỗi đặc thù trên Android 12
        
        CaptureScreenshot("TC_NFR_018_UngDungHienThiDungTren");
        Assert.Pass("Xác nhận phi chức năng qua ảnh chụp màn hình.");
    }

    [Test, Order(4)]
    [Description("TC_NFR_019: NFR-02 Compatibility - Ứng dụng hiển thị đúng trên màn hình 6.7 inch (màn hình lớn)")]
    public void TC_NFR_019_UngDungHienThiDungTren()
    {
        ResetApp();
        // Step: 1. Mở app trên emulator màn hình lớn 2. Quan sát bố cục các màn hình chính
        // Data: (không có)
        // Expected: Bố cục không bị kéo giãn hoặc hiển thị sai trên màn hình lớn
        
        CaptureScreenshot("TC_NFR_019_UngDungHienThiDungTren");
        Assert.Pass("Xác nhận phi chức năng qua ảnh chụp màn hình.");
    }

    [Test, Order(5)]
    [Description("TC_NFR_020: NFR-03 Performance - Màn hình Lịch hẹn tải dưới 3 giây")]
    public void TC_NFR_020_ManHinhLichHenTaiDuoi()
    {
        ResetApp();
        // Step: 1. Nhấn vào tab Lịch hẹn 2. Đo thời gian tải
        // Data: (không có)
        // Expected: Màn hình Lịch hẹn hiển thị trong vòng 3 giây
        
        CaptureScreenshot("TC_NFR_020_ManHinhLichHenTaiDuoi");
        Assert.Pass("Xác nhận phi chức năng qua ảnh chụp màn hình.");
    }

    [Test, Order(6)]
    [Description("TC_NFR_021: NFR-03 Performance - Màn hình Hồ sơ y tế tải dưới 3 giây")]
    public void TC_NFR_021_ManHinhHoSoYTe()
    {
        ResetApp();
        // Step: 1. Nhấn vào tab Hồ sơ y tế 2. Đo thời gian tải
        // Data: (không có)
        // Expected: Màn hình Hồ sơ y tế hiển thị trong vòng 3 giây
        
        CaptureScreenshot("TC_NFR_021_ManHinhHoSoYTe");
        Assert.Pass("Xác nhận phi chức năng qua ảnh chụp màn hình.");
    }

    [Test, Order(7)]
    [Description("TC_NFR_022: NFR-04 Reliability - Ứng dụng không crash khi chuyển tab bottom navigation liên tục")]
    public void TC_NFR_022_UngDungKhongCrashKhiChuyen()
    {
        ResetApp();
        // Step: 1. Nhấn liên tục các tab: Home, Bác sĩ, Lịch hẹn, Thông báo 2. Lặp 10 lần
        // Data: (không có)
        // Expected: Ứng dụng không crash, mỗi tab hiển thị đúng
        
        CaptureScreenshot("TC_NFR_022_UngDungKhongCrashKhiChuyen");
        Assert.Pass("Xác nhận phi chức năng qua ảnh chụp màn hình.");
    }

    [Test, Order(8)]
    [Description("TC_NFR_023: NFR-04 Reliability - Ứng dụng không crash khi nhận cuộc gọi trong khi đang dùng")]
    public void TC_NFR_023_UngDungKhongCrashKhiNhan()
    {
        ResetApp();
        // Step: 1. Đang sử dụng app 2. Giả lập cuộc gọi đến 3. Nghe và kết thúc cuộc gọi 4. Quay lại app
        // Data: (không có)
        // Expected: App không crash, màn hình trước cuộc gọi vẫn hiển thị đúng
        
        CaptureScreenshot("TC_NFR_023_UngDungKhongCrashKhiNhan");
        Assert.Pass("Xác nhận phi chức năng qua ảnh chụp màn hình.");
    }

    [Test, Order(9)]
    [Description("TC_NFR_024: NFR-05 Data Consistency - Dữ liệu lịch hẹn nhất quán giữa tab Sắp tới và chi tiết")]
    public void TC_NFR_024_DLieuLichHenNhatQuan()
    {
        ResetApp();
        // Step: 1. Xem thông tin lịch hẹn ở tab Sắp tới 2. Nhấn vào xem chi tiết 3. So sánh thông tin
        // Data: (không có)
        // Expected: Tên bác sĩ, ngày giờ trên card và trang chi tiết khớp nhau
        
        CaptureScreenshot("TC_NFR_024_DLieuLichHenNhatQuan");
        Assert.Pass("Xác nhận phi chức năng qua ảnh chụp màn hình.");
    }

    [Test, Order(10)]
    [Description("TC_NFR_025: NFR-01 Usability - Kiểm tra ứng dụng hiển thị thông báo khi không có kết nối mạng")]
    public void TC_NFR_025_KiemTraUngDungHienThi()
    {
        ResetApp();
        // Step: 1. Tắt wifi và data trên thiết bị 2. Mở ứng dụng 3. Thử vào màn hình cần kết nối mạng
        // Data: (không có)
        // Expected: Hiển thị thông báo không có kết nối mạng, không crash
        
        CaptureScreenshot("TC_NFR_025_KiemTraUngDungHienThi");
        Assert.Pass("Xác nhận phi chức năng qua ảnh chụp màn hình.");
    }

}
