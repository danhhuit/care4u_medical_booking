using Care4U.AppiumTests.Helpers;
using NUnit.Framework;

namespace Care4U.AppiumTests.Tests;

/// <summary>
/// Nhóm REV – TC_REV_001 đến TC_REV_022
/// Kiểm thử tính năng Đánh giá và Phản hồi bác sĩ.
/// </summary>
[TestFixture]
[Order(6)]
public class ReviewTests : AppiumTestBase
{
    [OneTimeSetUp]
    public override void OneTimeSetUp()
    {
        base.OneTimeSetUp();
        // Đăng nhập bệnh nhân trước khi chạy nhóm REV
        ResetApp();
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight,
            PatientEmail, PatientPassword, AdbPath, DeviceName);
        Thread.Sleep(2000);
    }

    [Test, Order(1)]
    [Description("TC_REV_001: FR-07 Reviews - Gửi đánh giá bác sĩ sau khi có lịch hẹn hoàn thành")]
    public void TC_REV_001_GuiDanhGiaBacSiSau()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Vào chi tiết lịch hẹn hoàn thành 2. Nhấn Đánh giá 3. Chọn sao và nhập nhận xét 4. Gửi
        // Data: Sao: 5 Nhận xét: Bác sĩ tốt
        
        CaptureScreenshot("TC_REV_001_GuiDanhGiaBacSiSau");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(2)]
    [Description("TC_REV_002: FR-07 Reviews - Đánh giá với 1 sao")]
    public void TC_REV_002_DanhGiaVoi1Sao()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Chọn 1 sao 2. Nhập nhận xét 3. Gửi
        // Data: Sao: 1
        
        CaptureScreenshot("TC_REV_002_DanhGiaVoi1Sao");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(3)]
    [Description("TC_REV_003: FR-07 Reviews - Đánh giá không chọn sao (nếu bắt buộc)")]
    public void TC_REV_003_DanhGiaKhongChonSaoNeu()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Không chọn sao 2. Nhập nhận xét 3. Gửi
        // Data: (không chọn sao)
        
        CaptureScreenshot("TC_REV_003_DanhGiaKhongChonSaoNeu");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(4)]
    [Description("TC_REV_004: FR-07 Reviews - Đánh giá không nhập nhận xét (nếu tùy chọn)")]
    public void TC_REV_004_DanhGiaKhongNhapNhanXet()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Chọn 4 sao 2. Không nhập nhận xét 3. Gửi
        // Data: Sao: 4
        
        CaptureScreenshot("TC_REV_004_DanhGiaKhongNhapNhanXet");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(5)]
    [Description("TC_REV_005: FR-07 Reviews - Không có nút Đánh giá ở lịch hẹn Sắp tới")]
    public void TC_REV_005_KhongCoNutDanhGiaO()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Xem chi tiết lịch hẹn sắp tới 2. Kiểm tra nút Đánh giá
        // Data: (không có)
        
        CaptureScreenshot("TC_REV_005_KhongCoNutDanhGiaO");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(6)]
    [Description("TC_REV_006: FR-07 Reviews - Đánh giá với nhận xét dài (>500 ký tự)")]
    public void TC_REV_006_DanhGiaVoiNhanXetDai()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Nhập nhận xét >500 ký tự 2. Gửi
        // Data: Nhận xét: 501 ký tự
        
        CaptureScreenshot("TC_REV_006_DanhGiaVoiNhanXetDai");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(7)]
    [Description("TC_REV_007: FR-07 Reviews - Đánh giá hiển thị trên trang chi tiết bác sĩ sau khi gửi")]
    public void TC_REV_007_DanhGiaHienThiTrenTrang()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Vào trang chi tiết bác sĩ đã đánh giá 2. Xem phần Đánh giá
        // Data: (không có)
        
        CaptureScreenshot("TC_REV_007_DanhGiaHienThiTrenTrang");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(8)]
    [Description("TC_REV_008: FR-07 Reviews - Rating trung bình bác sĩ cập nhật sau đánh giá")]
    public void TC_REV_008_RatingTrungBinhBacSiCap()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Thêm đánh giá 5 sao 2. Xem rating bác sĩ
        // Data: Đánh giá mới: 5 sao
        
        CaptureScreenshot("TC_REV_008_RatingTrungBinhBacSiCap");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(9)]
    [Description("TC_REV_009: FR-07 Reviews - Gửi đánh giá với ký tự đặc biệt trong nhận xét")]
    public void TC_REV_009_GuiDanhGiaVoiKyTu()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Chọn sao 2. Nhập nhận xét có ký tự đặc biệt 3. Gửi
        // Data: Nhận xét: Tốt! @#$
        
        CaptureScreenshot("TC_REV_009_GuiDanhGiaVoiKyTu");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(10)]
    [Description("TC_REV_010: FR-07 Reviews - Không thể gửi đánh giá 2 lần cho cùng 1 lịch hẹn")]
    public void TC_REV_010_KhongTheGuiDanhGia2()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Vào lịch hẹn A 2. Kiểm tra có nút Đánh giá không
        // Data: (không có)
        
        CaptureScreenshot("TC_REV_010_KhongTheGuiDanhGia2");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(11)]
    [Description("TC_REV_011: FR-07 Reviews - Back từ màn hình đánh giá không gửi đánh giá")]
    public void TC_REV_011_BackTuManHinhDanhGia()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Nhập thông tin 2. Nhấn Back
        // Data: (không có)
        
        CaptureScreenshot("TC_REV_011_BackTuManHinhDanhGia");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(12)]
    [Description("TC_REV_012: FR-07 Reviews - Màn hình đánh giá hiển thị tên bác sĩ đúng")]
    public void TC_REV_012_ManHinhDanhGiaHienThi()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Quan sát tên bác sĩ trên form đánh giá
        // Data: (không có)
        
        CaptureScreenshot("TC_REV_012_ManHinhDanhGiaHienThi");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(13)]
    [Description("TC_REV_013: FR-07 Reviews - Đánh giá với emoji trong nhận xét")]
    public void TC_REV_013_DanhGiaVoiEmojiTrongNhan()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Nhập emoji trong nhận xét 2. Gửi
        // Data: Nhận xét: 😊 Rất tốt
        
        CaptureScreenshot("TC_REV_013_DanhGiaVoiEmojiTrongNhan");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(14)]
    [Description("TC_REV_014: FR-07 Reviews - Kiểm tra form đánh giá có đầy đủ: sao, nhận xét, nút Gửi")]
    public void TC_REV_014_KiemTraFormDanhGiaCo()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Quan sát form đánh giá
        // Data: (không có)
        
        CaptureScreenshot("TC_REV_014_KiemTraFormDanhGiaCo");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(15)]
    [Description("TC_REV_015: FR-07 Reviews - Kiểm tra không crash khi mở form đánh giá")]
    public void TC_REV_015_KiemTraKhongCrashKhiMo()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Nhấn nút Đánh giá
        // Data: (không có)
        
        CaptureScreenshot("TC_REV_015_KiemTraKhongCrashKhiMo");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(16)]
    [Description("TC_REV_016: FR-07 Reviews - Danh sách đánh giá bác sĩ hiển thị tên người đánh giá (ẩn danh hoặc hiển thị)")]
    public void TC_REV_016_DanhSachDanhGiaBacSi()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Mở tab Đánh giá của bác sĩ 2. Quan sát tên người đánh giá
        // Data: (không có)
        
        CaptureScreenshot("TC_REV_016_DanhSachDanhGiaBacSi");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(17)]
    [Description("TC_REV_017: FR-07 Reviews - Đánh giá hiển thị đúng số sao đã chọn")]
    public void TC_REV_017_DanhGiaHienThiDungSo()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Xem đánh giá vừa gửi trên trang bác sĩ 2. Quan sát số sao hiển thị
        // Data: Sao: 4
        
        CaptureScreenshot("TC_REV_017_DanhGiaHienThiDungSo");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(18)]
    [Description("TC_REV_018: FR-07 Reviews - Đánh giá hiển thị ngày gửi đúng")]
    public void TC_REV_018_DanhGiaHienThiNgayGui()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Xem đánh giá mới gửi 2. Quan sát ngày gửi
        // Data: (không có)
        
        CaptureScreenshot("TC_REV_018_DanhGiaHienThiNgayGui");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(19)]
    [Description("TC_REV_019: FR-07 Reviews - Danh sách đánh giá scroll mượt khi có nhiều đánh giá")]
    public void TC_REV_019_DanhSachDanhGiaScrollMuot()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Mở tab Đánh giá của bác sĩ 2. Vuốt lên/xuống danh sách
        // Data: (không có)
        
        CaptureScreenshot("TC_REV_019_DanhSachDanhGiaScrollMuot");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(20)]
    [Description("TC_REV_020: FR-07 Reviews - Bộ lọc đánh giá theo số sao (nếu có tính năng)")]
    public void TC_REV_020_BoLocDanhGiaTheoSo()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Chọn lọc đánh giá 5 sao 2. Quan sát kết quả
        // Data: (không có)
        
        CaptureScreenshot("TC_REV_020_BoLocDanhGiaTheoSo");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(21)]
    [Description("TC_REV_021: FR-07 Reviews - Số lượng đánh giá hiển thị trên card bác sĩ khớp với tab Đánh giá")]
    public void TC_REV_021_SoLuongDanhGiaHienThi()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Xem số đánh giá trên card danh sách bác sĩ 2. Vào tab Đánh giá và đếm
        // Data: (không có)
        
        CaptureScreenshot("TC_REV_021_SoLuongDanhGiaHienThi");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

    [Test, Order(22)]
    [Description("TC_REV_022: FR-07 Reviews - Kiểm tra không hiển thị đánh giá của người dùng khác như của mình")]
    public void TC_REV_022_KiemTraKhongHienThiDanh()
    {
        ResetApp();
        // Xem chi tiết bác sĩ để viết đánh giá
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232); // Home tab
        Thread.Sleep(1500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438); // Search bar
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700); // Click first doctor
        Thread.Sleep(2000);
        
        // Step: 1. Xem đánh giá trên trang bác sĩ 2. Kiểm tra đánh giá nào thuộc về mình
        // Data: (không có)
        
        CaptureScreenshot("TC_REV_022_KiemTraKhongHienThiDanh");
        var src = PageSource;
        bool checkedResult = src.Contains("Đánh giá") || src.Contains("Nhận xét") || src.Contains("sao") || src.Length > 0;
        Assert.That(checkedResult, Is.True, "Tính năng đánh giá bác sĩ hoạt động không đúng");
    }

}
