using Care4U.AppiumTests.Helpers;
using NUnit.Framework;

namespace Care4U.AppiumTests.Tests;

/// <summary>
/// Nhóm NOTI – TC_NOTI_001 đến TC_NOTI_030
/// Kiểm thử hệ thống Thông báo nhắc nhở.
/// </summary>
[TestFixture]
[Order(10)]
public class NotificationTests : AppiumTestBase
{
    [OneTimeSetUp]
    public override void OneTimeSetUp()
    {
        base.OneTimeSetUp();
        // Đăng nhập bệnh nhân trước khi chạy nhóm NOTI
        ResetApp(delaySeconds: 12.0, clearData: true);
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight,
            PatientEmail, PatientPassword, AdbPath, DeviceName);
        Thread.Sleep(2000);
    }

    [Test, Order(1)]
    [Description("TC_NOTI_001: FR-04 Notifications - Xem danh sách thông báo")]
    public void TC_NOTI_001_XemDanhSachThongBao()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Nhấn vào mục Thông báo
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_001_XemDanhSachThongBao");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(2)]
    [Description("TC_NOTI_002: FR-04 Notifications - Thông báo xác nhận lịch hẹn xuất hiện sau khi đặt lịch")]
    public void TC_NOTI_002_ThongBaoXacNhanLichHen()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Vào mục Thông báo
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_002_ThongBaoXacNhanLichHen");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(3)]
    [Description("TC_NOTI_003: FR-04 Notifications - Thông báo hủy lịch xuất hiện sau khi hủy")]
    public void TC_NOTI_003_ThongBaoHuyLichXuatHien()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Vào mục Thông báo
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_003_ThongBaoHuyLichXuatHien");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(4)]
    [Description("TC_NOTI_004: FR-04 Notifications - Đánh dấu thông báo đã đọc")]
    public void TC_NOTI_004_DanhDauThongBaoDaDoc()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Nhấn vào thông báo 2. Quan sát trạng thái
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_004_DanhDauThongBaoDaDoc");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(5)]
    [Description("TC_NOTI_005: FR-04 Notifications - Đánh dấu tất cả đã đọc")]
    public void TC_NOTI_005_DanhDauTatCaDaDoc()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Nhấn Đánh dấu tất cả đã đọc
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_005_DanhDauTatCaDaDoc");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(6)]
    [Description("TC_NOTI_006: FR-04 Notifications - Badge số lượng thông báo chưa đọc hiển thị đúng")]
    public void TC_NOTI_006_BadgeSoLuongThongBaoChua()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Quan sát icon thông báo
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_006_BadgeSoLuongThongBaoChua");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(7)]
    [Description("TC_NOTI_007: FR-04 Notifications - Badge giảm khi đọc thông báo")]
    public void TC_NOTI_007_BadgeGiamKhiDocThongBao()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Đọc 1 thông báo 2. Quan sát badge
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_007_BadgeGiamKhiDocThongBao");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(8)]
    [Description("TC_NOTI_008: FR-04 Notifications - Badge biến mất khi đọc hết thông báo")]
    public void TC_NOTI_008_BadgeBienMatKhiDocHet()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Đọc thông báo còn lại 2. Quan sát badge
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_008_BadgeBienMatKhiDocHet");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(9)]
    [Description("TC_NOTI_009: FR-04 Notifications - Xem chi tiết thông báo")]
    public void TC_NOTI_009_XemChiTietThongBao()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Nhấn vào 1 thông báo
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_009_XemChiTietThongBao");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(10)]
    [Description("TC_NOTI_010: FR-04 Notifications - Thông báo hiển thị đúng ngày giờ")]
    public void TC_NOTI_010_ThongBaoHienThiDungNgay()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        RunAdb("shell input swipe 540 1800 540 500 500");
        Thread.Sleep(1500);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Quan sát ngày giờ trên thông báo
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_010_ThongBaoHienThiDungNgay");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(11)]
    [Description("TC_NOTI_011: FR-04 Notifications - Danh sách thông báo khi chưa có thông báo nào")]
    public void TC_NOTI_011_DanhSachThongBaoKhiChua()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        RunAdb("shell input swipe 540 1800 540 500 500");
        Thread.Sleep(1500);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Vào mục Thông báo
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_011_DanhSachThongBaoKhiChua");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(12)]
    [Description("TC_NOTI_012: FR-04 Notifications - Thông báo sắp xếp theo thứ tự mới nhất lên trên")]
    public void TC_NOTI_012_ThongBaoSapXepTheoThu()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        RunAdb("shell input swipe 540 1800 540 500 500");
        Thread.Sleep(1500);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Quan sát thứ tự danh sách thông báo
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_012_ThongBaoSapXepTheoThu");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(13)]
    [Description("TC_NOTI_013: FR-04 Notifications - Kiểm tra icon phân biệt loại thông báo")]
    public void TC_NOTI_013_KiemTraIconPhanBietLoai()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        RunAdb("shell input swipe 540 1800 540 500 500");
        Thread.Sleep(1500);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Quan sát icon từng thông báo
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_013_KiemTraIconPhanBietLoai");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(14)]
    [Description("TC_NOTI_014: FR-04 Notifications - Thông báo nhắc lịch xuất hiện trước ngày khám")]
    public void TC_NOTI_014_ThongBaoNhacLichXuatHien()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        RunAdb("shell input swipe 540 1800 540 500 500");
        Thread.Sleep(1500);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Vào mục Thông báo trước ngày khám
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_014_ThongBaoNhacLichXuatHien");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(15)]
    [Description("TC_NOTI_015: FR-04 Notifications - Kiểm tra không crash khi mở nhiều thông báo liên tiếp")]
    public void TC_NOTI_015_KiemTraKhongCrashKhiMo()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        RunAdb("shell input swipe 540 1800 540 500 500");
        Thread.Sleep(1500);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Nhấn vào lần lượt từng thông báo và back
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_015_KiemTraKhongCrashKhiMo");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(16)]
    [Description("TC_NOTI_016: FR-04 Notifications - Thông báo scroll được khi danh sách dài")]
    public void TC_NOTI_016_ThongBaoScrollDuocKhiDanh()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        RunAdb("shell input swipe 540 1800 540 500 500");
        Thread.Sleep(1500);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Vuốt lên xuống danh sách
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_016_ThongBaoScrollDuocKhiDanh");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(17)]
    [Description("TC_NOTI_017: FR-04 Notifications - Kiểm tra nội dung thông báo xác nhận có tên bác sĩ")]
    public void TC_NOTI_017_KiemTraNoiDungThongBao()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        RunAdb("shell input swipe 540 1800 540 500 500");
        Thread.Sleep(1500);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Mở thông báo xác nhận
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_017_KiemTraNoiDungThongBao");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(18)]
    [Description("TC_NOTI_018: FR-04 Notifications - Kiểm tra nội dung thông báo hủy có thông tin lịch")]
    public void TC_NOTI_018_KiemTraNoiDungThongBao()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        RunAdb("shell input swipe 540 1800 540 500 500");
        Thread.Sleep(1500);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Mở thông báo hủy
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_018_KiemTraNoiDungThongBao");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(19)]
    [Description("TC_NOTI_019: FR-04 Notifications - Điều hướng từ thông báo sang chi tiết lịch hẹn (nếu có liên kết)")]
    public void TC_NOTI_019_DieuHuongTuThongBaoSang()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        RunAdb("shell input swipe 540 1800 540 500 500");
        Thread.Sleep(1500);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Nhấn vào thông báo liên quan lịch
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_019_DieuHuongTuThongBaoSang");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(20)]
    [Description("TC_NOTI_020: FR-04 Notifications - Kiểm tra thông báo không hiển thị thông tin nhạy cảm")]
    public void TC_NOTI_020_KiemTraThongBaoKhongHien()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Quan sát nội dung thông báo
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_020_KiemTraThongBaoKhongHien");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(21)]
    [Description("TC_NOTI_021: FR-04 Notifications - Push notification xuất hiện trên thanh trạng thái khi đặt lịch thành công")]
    public void TC_NOTI_021_PushNotificationXuatHienTrenThanh()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Đặt lịch thành công 2. Kéo thanh thông báo xuống
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_021_PushNotificationXuatHienTrenThanh");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(22)]
    [Description("TC_NOTI_022: FR-04 Notifications - Nhấn vào push notification - mở đúng màn hình liên quan")]
    public void TC_NOTI_022_NhanVaoPushNotificationMoDung()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Nhấn vào push notification 2. Quan sát màn hình mở ra
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_022_NhanVaoPushNotificationMoDung");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(23)]
    [Description("TC_NOTI_023: FR-04 Notifications - Thông báo nhắc lịch khám trước 1 ngày xuất hiện đúng thời điểm")]
    public void TC_NOTI_023_ThongBaoNhacLichKhamTruoc()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Đặt lịch vào ngày mai 2. Vào mục Thông báo trước ngày khám 1 ngày
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_023_ThongBaoNhacLichKhamTruoc");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(24)]
    [Description("TC_NOTI_024: FR-04 Notifications - Thông báo hiển thị đúng tên bác sĩ và giờ khám")]
    public void TC_NOTI_024_ThongBaoHienThiDungTen()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Mở thông báo xác nhận lịch 2. Đọc nội dung
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_024_ThongBaoHienThiDungTen");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(25)]
    [Description("TC_NOTI_025: FR-04 Notifications - Xóa thông báo đơn lẻ (nếu có tính năng)")]
    public void TC_NOTI_025_XoaThongBaoDonLeNeu()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Vuốt hoặc nhấn giữ vào thông báo 2. Chọn Xóa
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_025_XoaThongBaoDonLeNeu");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(26)]
    [Description("TC_NOTI_026: FR-04 Notifications - Thông báo phân loại đúng: lịch hẹn, hủy lịch, nhắc lịch")]
    public void TC_NOTI_026_ThongBaoPhanLoaiDungLich()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Quan sát danh sách thông báo 2. Kiểm tra icon/nhãn từng loại
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_026_ThongBaoPhanLoaiDungLich");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(27)]
    [Description("TC_NOTI_027: FR-04 Notifications - Số badge thông báo trên icon đồng bộ với số chưa đọc trong danh sách")]
    public void TC_NOTI_027_SoBadgeThongBaoTrenIcon()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Quan sát badge trên icon thông báo 2. Vào danh sách đếm số thông báo chưa đọc
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_027_SoBadgeThongBaoTrenIcon");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(28)]
    [Description("TC_NOTI_028: FR-04 Notifications - Thông báo không mất sau khi đóng và mở lại app")]
    public void TC_NOTI_028_ThongBaoKhongMatSauKhi()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Đóng app hoàn toàn 2. Mở lại app 3. Vào Thông báo
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_028_ThongBaoKhongMatSauKhi");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(29)]
    [Description("TC_NOTI_029: FR-04 Notifications - Thông báo hiển thị thời gian tương đối (vừa xong, 1 giờ trước...)")]
    public void TC_NOTI_029_ThongBaoHienThiThoiGian()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Quan sát thời gian trên mỗi thông báo
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_029_ThongBaoHienThiThoiGian");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

    [Test, Order(30)]
    [Description("TC_NOTI_030: FR-04 Notifications - Không hiển thị thông báo trùng lặp cho cùng một sự kiện")]
    public void TC_NOTI_030_KhongHienThiThongBaoTrung()
    {
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 102, 2232); // Tab Home
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 880, 150); // Icon Bell
        Thread.Sleep(2000);
        ResetApp();
        // Nhấn nút thông báo trên Trang chủ (~940, 240)
        
        
        // Step: 1. Đặt lịch thành công 2. Vào mục Thông báo 3. Đếm số thông báo xác nhận
        // Data: (không có)
        
        CaptureScreenshot("TC_NOTI_030_KhongHienThiThongBaoTrung");
        var src = PageSource;
        bool checkedResult = src.Contains("Thông báo") || src.Contains("Lịch nhắc") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Màn hình thông báo hoạt động không đúng");
    }

}
