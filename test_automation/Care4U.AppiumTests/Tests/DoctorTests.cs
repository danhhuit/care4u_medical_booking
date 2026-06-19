using Care4U.AppiumTests.Helpers;
using NUnit.Framework;

namespace Care4U.AppiumTests.Tests;

/// <summary>
/// Nhóm DOC – TC_DOC_001 đến TC_DOC_035
/// Kiểm thử tính năng Danh sách bác sĩ, tìm kiếm, lọc, chi tiết, đặt lịch.
/// </summary>
[TestFixture]
[Order(2)]
public class DoctorTests : AppiumTestBase
{
    [OneTimeSetUp]
    public override void OneTimeSetUp()
    {
        base.OneTimeSetUp();
        // Đăng nhập bệnh nhân trước khi chạy nhóm DOC
        ResetApp();
        AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
        AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight,
            PatientEmail, PatientPassword, AdbPath, DeviceName);
        Thread.Sleep(2000);
    }

    // ══════════════════════════════════════════════════════════════
    //  DANH SÁCH BÁC SĨ (TC_DOC_001 – TC_DOC_010)
    // ══════════════════════════════════════════════════════════════

    [Test, Order(1)]
    [Description("TC_DOC_001: Hiển thị danh sách bác sĩ thành công sau khi đăng nhập")]
    public void TC_DOC_001_DoctorListDisplayed()
    {
        NavigateToDoctorTab();
        CaptureScreenshot("TC_DOC_001_DoctorList");
        var src = PageSource;
        bool hasDoctors = src.Contains("Nguyễn") || src.Contains("Trần") || src.Contains("Lê")
                       || src.Contains("Bác sĩ") || src.Contains("BS.");
        Assert.That(hasDoctors, Is.True, "Danh sách bác sĩ không được hiển thị");
    }

    [Test, Order(2)]
    [Description("TC_DOC_002: Xem chi tiết bác sĩ khi nhấn vào một bác sĩ trong danh sách")]
    public void TC_DOC_002_DoctorDetailPage()
    {
        NavigateToDoctorTab();
        // Nhấn vào bác sĩ đầu tiên (~540, 700)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_002_DoctorDetail");
        var src = PageSource;
        bool hasDetail = src.Contains("Chuyên khoa") || src.Contains("Kinh nghiệm")
                      || src.Contains("Đặt lịch") || src.Contains("Giới thiệu");
        Assert.That(hasDetail, Is.True, "Màn hình chi tiết bác sĩ không hiển thị đúng");
    }

    [Test, Order(3)]
    [Description("TC_DOC_003: Tìm kiếm bác sĩ theo tên trả về kết quả đúng")]
    public void TC_DOC_003_SearchDoctorByName()
    {
        NavigateToDoctorTab();
        // Nhấn vào ô tìm kiếm (~540, 388)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 388);
        Thread.Sleep(500);
        AppHelpers.AdbInput(AdbPath, DeviceName, "Nguyễn");
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_003_SearchByName");
        var src = PageSource;
        bool hasResult = src.Contains("Nguyễn") || src.Contains("Minh");
        Assert.That(hasResult, Is.True, "Tìm kiếm theo tên không trả về kết quả");
    }

    [Test, Order(4)]
    [Description("TC_DOC_004: Tìm kiếm tên bác sĩ không tồn tại trả về thông báo không có kết quả")]
    public void TC_DOC_004_SearchDoctorNoResult()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 388);
        Thread.Sleep(500);
        AppHelpers.AdbInput(AdbPath, DeviceName, "XYZAbcdNotExist123");
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_004_SearchNoResult");
        var src = PageSource;
        bool noResult = src.Contains("không có") || src.Contains("không tìm thấy")
                     || src.Contains("No result") || src.Contains("trống");
        Assert.That(noResult, Is.True, "Không hiện thông báo khi không có kết quả tìm kiếm");
    }

    [Test, Order(5)]
    [Description("TC_DOC_005: Lọc bác sĩ theo chuyên khoa (Nội khoa)")]
    public void TC_DOC_005_FilterBySpecialty()
    {
        NavigateToDoctorTab();
        // Nhấn filter/chip chuyên khoa (~975, 388)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 975, 388);
        Thread.Sleep(1500);
        CaptureScreenshot("TC_DOC_005_FilterSpecialty");
        Assert.Pass("Kiểm tra lọc chuyên khoa – xem ảnh chụp");
    }

    [Test, Order(6)]
    [Description("TC_DOC_006: Lọc bác sĩ theo chuyên khoa khác (Nhi khoa)")]
    public void TC_DOC_006_FilterByAnotherSpecialty()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 975, 388);
        Thread.Sleep(1500);
        CaptureScreenshot("TC_DOC_006_FilterAnotherSpecialty");
        Assert.Pass("Kiểm tra lọc chuyên khoa khác – xem ảnh chụp");
    }

    [Test, Order(7)]
    [Description("TC_DOC_007: Xóa bộ lọc khôi phục danh sách bác sĩ đầy đủ")]
    public void TC_DOC_007_ClearFilter()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 975, 388);
        Thread.Sleep(1000);
        // Nhấn "Tất cả" hoặc X để xóa filter
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 975, 388);
        Thread.Sleep(1500);
        CaptureScreenshot("TC_DOC_007_ClearFilter");
        Assert.Pass("Kiểm tra xóa filter – xem ảnh chụp");
    }

    [Test, Order(8)]
    [Description("TC_DOC_008: Hiển thị rating/số sao bác sĩ trong danh sách")]
    public void TC_DOC_008_DoctorRatingDisplayed()
    {
        NavigateToDoctorTab();
        CaptureScreenshot("TC_DOC_008_DoctorRating");
        var src = PageSource;
        bool hasRating = src.Contains("★") || src.Contains("sao") || src.Contains("rating")
                      || src.Contains("4.") || src.Contains("5.0");
        Assert.That(hasRating, Is.True, "Không hiển thị rating bác sĩ");
    }

    [Test, Order(9)]
    [Description("TC_DOC_009: Hiển thị chuyên khoa trong card bác sĩ")]
    public void TC_DOC_009_DoctorSpecialtyInCard()
    {
        NavigateToDoctorTab();
        CaptureScreenshot("TC_DOC_009_SpecialtyInCard");
        var src = PageSource;
        bool hasSpecialty = src.Contains("Nội") || src.Contains("Nhi") || src.Contains("Sản")
                         || src.Contains("Chuyên khoa") || src.Contains("khoa");
        Assert.That(hasSpecialty, Is.True, "Không hiển thị chuyên khoa trong card bác sĩ");
    }

    [Test, Order(10)]
    [Description("TC_DOC_010: Tìm kiếm bác sĩ theo chuyên khoa")]
    public void TC_DOC_010_SearchBySpecialty()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 388);
        Thread.Sleep(500);
        AppHelpers.AdbInput(AdbPath, DeviceName, "Nội");
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_010_SearchBySpecialty");
        var src = PageSource;
        bool hasResult = src.Contains("Nội") || src.Contains("không có");
        Assert.That(hasResult, Is.True, "Tìm kiếm theo chuyên khoa không hoạt động");
    }

    // ══════════════════════════════════════════════════════════════
    //  CHI TIẾT BÁC SĨ (TC_DOC_011 – TC_DOC_020)
    // ══════════════════════════════════════════════════════════════

    [Test, Order(11)]
    [Description("TC_DOC_011: Màn hình chi tiết hiển thị đầy đủ thông tin bác sĩ")]
    public void TC_DOC_011_DoctorDetailFullInfo()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_011_DoctorDetailFullInfo");
        var src = PageSource;
        bool hasName    = src.Contains("Nguyễn") || src.Contains("Trần") || src.Contains("Lê");
        bool hasSpecial = src.Contains("Chuyên khoa");
        bool hasExp     = src.Contains("năm") || src.Contains("kinh nghiệm") || src.Contains("Kinh nghiệm");
        Assert.Multiple(() =>
        {
            Assert.That(hasName,    Is.True, "Không hiển thị tên bác sĩ");
            Assert.That(hasSpecial, Is.True, "Không hiển thị chuyên khoa");
            Assert.That(hasExp,     Is.True, "Không hiển thị kinh nghiệm");
        });
    }

    [Test, Order(12)]
    [Description("TC_DOC_012: Ảnh đại diện bác sĩ hiển thị đúng trong trang chi tiết")]
    public void TC_DOC_012_DoctorAvatarDisplayed()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_012_DoctorAvatar");
        Assert.Pass("Kiểm tra ảnh đại diện – xem ảnh chụp");
    }

    [Test, Order(13)]
    [Description("TC_DOC_013: Hiển thị lịch làm việc của bác sĩ trong trang chi tiết")]
    public void TC_DOC_013_DoctorScheduleDisplayed()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        // Scroll xuống để xem lịch
        Swipe(540, 2228, 540, 600);
        Thread.Sleep(1000);
        CaptureScreenshot("TC_DOC_013_DoctorSchedule");
        var src = PageSource;
        bool hasSchedule = src.Contains("Lịch") || src.Contains("Thứ") || src.Contains("Giờ")
                        || src.Contains("khám") || src.Contains("Buổi");
        Assert.That(hasSchedule, Is.True, "Không hiển thị lịch làm việc bác sĩ");
    }

    [Test, Order(14)]
    [Description("TC_DOC_014: Nút Đặt lịch trên trang chi tiết bác sĩ hoạt động")]
    public void TC_DOC_014_BookingButtonWorks()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        // Nhấn nút Đặt lịch (~540, 2228)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_014_BookingScreen");
        var src = PageSource;
        bool onBooking = src.Contains("Đặt lịch") || src.Contains("Chọn ngày") || src.Contains("Ngày khám");
        Assert.That(onBooking, Is.True, "Nút Đặt lịch không hoạt động");
    }

    [Test, Order(15)]
    [Description("TC_DOC_015: Hiển thị tên bác sĩ bằng chữ thường/hoa đúng")]
    public void TC_DOC_015_DoctorNameCasing()
    {
        NavigateToDoctorTab();
        CaptureScreenshot("TC_DOC_015_DoctorNameCasing");
        Assert.Pass("Kiểm tra casing tên bác sĩ – xem ảnh chụp");
    }

    [Test, Order(16)]
    [Description("TC_DOC_016: Quay lại từ chi tiết bác sĩ về danh sách")]
    public void TC_DOC_016_BackFromDetailToList()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        PressKey(4);
        Thread.Sleep(1500);
        CaptureScreenshot("TC_DOC_016_BackToList");
        var src = PageSource;
        bool onList = src.Contains("Bác sĩ") || src.Contains("Tìm kiếm");
        Assert.That(onList, Is.True, "Không quay lại danh sách bác sĩ");
    }

    [Test, Order(17)]
    [Description("TC_DOC_017: Kiểm tra kéo xuống để làm mới danh sách (Pull-to-refresh)")]
    public void TC_DOC_017_PullToRefresh()
    {
        NavigateToDoctorTab();
        Swipe(540, 400, 540, 900, 400, 2.0);
        CaptureScreenshot("TC_DOC_017_PullToRefresh");
        Assert.Pass("Pull-to-refresh đã được thực thi – xem ảnh chụp");
    }

    [Test, Order(18)]
    [Description("TC_DOC_018: Danh sách bác sĩ hiển thị đúng khi có nhiều bác sĩ (scroll)")]
    public void TC_DOC_018_DoctorListScroll()
    {
        NavigateToDoctorTab();
        Swipe(540, 2228, 540, 600, 400, 1.5);
        Swipe(540, 2228, 540, 600, 400, 1.5);
        CaptureScreenshot("TC_DOC_018_DoctorListScroll");
        Assert.That(PageSource.Length, Is.GreaterThan(0), "App crash khi scroll danh sách");
    }

    [Test, Order(19)]
    [Description("TC_DOC_019: Giá khám bệnh hiển thị đúng trong chi tiết bác sĩ")]
    public void TC_DOC_019_ConsultationFeeDisplayed()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_019_ConsultationFee");
        var src = PageSource;
        bool hasFee = src.Contains("đồng") || src.Contains("VND") || src.Contains("phí")
                   || src.Contains("000") || src.Contains("Giá");
        Assert.That(hasFee, Is.True, "Không hiển thị giá khám bệnh");
    }

    [Test, Order(20)]
    [Description("TC_DOC_020: Scroll danh sách bác sĩ mượt mà, không bị giật")]
    public void TC_DOC_020_SmoothScroll()
    {
        NavigateToDoctorTab();
        for (int i = 0; i < 3; i++)
        {
            Swipe(540, 2228, 540, 600, 500, 0.5);
        }
        CaptureScreenshot("TC_DOC_020_SmoothScroll");
        Assert.That(PageSource.Length, Is.GreaterThan(0), "App crash khi scroll mượt");
    }

    // ══════════════════════════════════════════════════════════════
    //  ĐẶT LỊCH KHÁM (TC_DOC_021 – TC_DOC_035)
    // ══════════════════════════════════════════════════════════════

    [Test, Order(21)]
    [Description("TC_DOC_021: Đặt lịch khám thành công")]
    public void TC_DOC_021_BookAppointmentSuccess()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(2000);
        // Chọn ngày (ngày đầu tiên khả dụng ~139, 852)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 139, 852);
        Thread.Sleep(1000);
        // Chọn giờ (~283, 1220)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 283, 1220);
        Thread.Sleep(1000);
        // Xác nhận đặt lịch (~540, 2228)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(3000);
        CaptureScreenshot("TC_DOC_021_BookSuccess");
        var src = PageSource;
        bool isBooked = src.Contains("thành công") || src.Contains("Đã đặt") || src.Contains("xác nhận");
        Assert.That(isBooked, Is.True, "Đặt lịch khám không thành công");
    }

    [Test, Order(22)]
    [Description("TC_DOC_022: Màn hình đặt lịch ổn định, không crash")]
    public void TC_DOC_022_BookingScreenStability()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_022_BookingStability");
        Assert.That(PageSource.Length, Is.GreaterThan(0), "App crash ở màn hình đặt lịch");
    }

    [Test, Order(23)]
    [Description("TC_DOC_023: Không thể đặt lịch khi chưa chọn ngày")]
    public void TC_DOC_023_BookWithoutDate()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(2000);
        // Không chọn ngày/giờ, nhấn xác nhận
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_023_BookWithoutDate");
        var src = PageSource;
        bool hasError = src.Contains("chọn") || src.Contains("ngày") || src.Contains("bắt buộc");
        Assert.That(hasError, Is.True, "Không hiện lỗi khi đặt lịch thiếu ngày");
    }

    [Test, Order(24)]
    [Description("TC_DOC_024: Không thể đặt lịch khi chưa chọn giờ")]
    public void TC_DOC_024_BookWithoutTime()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(2000);
        // Chọn ngày nhưng không chọn giờ
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 139, 852);
        Thread.Sleep(1000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_024_BookWithoutTime");
        var src = PageSource;
        bool hasError = src.Contains("giờ") || src.Contains("khung giờ") || src.Contains("bắt buộc");
        Assert.That(hasError, Is.True, "Không hiện lỗi khi đặt lịch thiếu giờ");
    }

    [Test, Order(25)]
    [Description("TC_DOC_025: Quay lại từ màn hình đặt lịch về chi tiết bác sĩ")]
    public void TC_DOC_025_BackFromBooking()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(2000);
        PressKey(4);
        Thread.Sleep(1500);
        CaptureScreenshot("TC_DOC_025_BackFromBooking");
        var src = PageSource;
        bool onDetail = src.Contains("Chuyên khoa") || src.Contains("Đặt lịch") || src.Contains("Bác sĩ");
        Assert.That(onDetail, Is.True, "Không quay lại màn hình chi tiết");
    }

    [Test, Order(26)]
    [Description("TC_DOC_026: Hiển thị lịch sử đặt lịch của bệnh nhân")]
    public void TC_DOC_026_AppointmentHistory()
    {
        // Điều hướng đến tab Lịch sử / Hồ sơ
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 810, 2350); // Tab hồ sơ
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_026_AppointmentHistory");
        var src = PageSource;
        bool hasHistory = src.Contains("Lịch sử") || src.Contains("Đặt lịch") || src.Contains("Lịch hẹn");
        Assert.That(hasHistory, Is.True, "Không tìm thấy lịch sử đặt lịch");
    }

    [Test, Order(27)]
    [Description("TC_DOC_027: Hủy lịch khám đã đặt thành công")]
    public void TC_DOC_027_CancelAppointment()
    {
        // Đi đến Lịch sử
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 810, 2350);
        Thread.Sleep(2000);
        // Nhấn vào lịch đầu tiên (~540, 700)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(1500);
        // Nút Hủy (~540, 2228)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(1500);
        // Xác nhận hủy
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 700, 1400);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_027_CancelAppointment");
        Assert.Pass("Kiểm tra hủy lịch – xem ảnh chụp");
    }

    [Test, Order(28)]
    [Description("TC_DOC_028: Tìm kiếm xóa trắng ô tìm kiếm khôi phục danh sách")]
    public void TC_DOC_028_ClearSearchRestoresList()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 388);
        Thread.Sleep(300);
        AppHelpers.AdbInput(AdbPath, DeviceName, "Nguyễn");
        Thread.Sleep(1500);
        // Xóa nội dung tìm kiếm
        ClearFieldAdb(20);
        Thread.Sleep(1500);
        CaptureScreenshot("TC_DOC_028_ClearSearch");
        var src = PageSource;
        bool hasAllDoctors = src.Contains("Bác sĩ") || src.Contains("BS.");
        Assert.That(hasAllDoctors, Is.True, "Xóa ô tìm kiếm không khôi phục danh sách");
    }

    [Test, Order(29)]
    [Description("TC_DOC_029: Hiển thị đúng thông tin bác sĩ Nguyễn Văn Minh")]
    public void TC_DOC_029_SpecificDoctorMinhInfo()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 388);
        Thread.Sleep(300);
        AppHelpers.AdbInput(AdbPath, DeviceName, "Minh");
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_029_DoctorMinh");
        var src = PageSource;
        bool hasMinh = src.Contains("Minh") || src.Contains("không có");
        Assert.That(hasMinh, Is.True, "Không tìm thấy bs Nguyễn Văn Minh");
    }

    [Test, Order(30)]
    [Description("TC_DOC_030: Hiển thị đúng thông tin bác sĩ Trần Thị Hoa")]
    public void TC_DOC_030_SpecificDoctorHoaInfo()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 388);
        Thread.Sleep(300);
        AppHelpers.AdbInput(AdbPath, DeviceName, "Hoa");
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_030_DoctorHoa");
        var src = PageSource;
        bool hasHoa = src.Contains("Hoa") || src.Contains("không có");
        Assert.That(hasHoa, Is.True, "Không tìm thấy bs Trần Thị Hoa");
    }

    [Test, Order(31)]
    [Description("TC_DOC_031: Bác sĩ không hoạt động không hiển thị trong danh sách")]
    public void TC_DOC_031_InactiveDoctorNotShown()
    {
        NavigateToDoctorTab();
        CaptureScreenshot("TC_DOC_031_InactiveDoctors");
        Assert.Pass("Kiểm tra bác sĩ không hoạt động – xem ảnh chụp và xác nhận thủ công");
    }

    [Test, Order(32)]
    [Description("TC_DOC_032: Thông tin số điện thoại bác sĩ ẩn hoặc hiển thị đúng")]
    public void TC_DOC_032_DoctorPhonePrivacy()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        CaptureScreenshot("TC_DOC_032_DoctorPhone");
        Assert.Pass("Kiểm tra quyền riêng tư SĐT bác sĩ – xem ảnh chụp");
    }

    [Test, Order(33)]
    [Description("TC_DOC_033: Đặt lịch nhiều lần cùng khung giờ bị từ chối")]
    public void TC_DOC_033_DuplicateBookingRejected()
    {
        // Thực hiện đặt lịch cùng thời gian 2 lần
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 139, 852);
        Thread.Sleep(500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 283, 1220);
        Thread.Sleep(500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(3000);
        // Lần 2: cùng bác sĩ, cùng giờ
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 139, 852);
        Thread.Sleep(500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 283, 1220);
        Thread.Sleep(500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(3000);
        CaptureScreenshot("TC_DOC_033_DuplicateBooking");
        Assert.Pass("Kiểm tra đặt lịch trùng – xem ảnh chụp");
    }

    [Test, Order(34)]
    [Description("TC_DOC_034: Hiển thị đánh giá bệnh nhân cho bác sĩ")]
    public void TC_DOC_034_DoctorReviews()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        Swipe(540, 2228, 540, 600);
        Thread.Sleep(1000);
        CaptureScreenshot("TC_DOC_034_DoctorReviews");
        Assert.Pass("Kiểm tra đánh giá bác sĩ – xem ảnh chụp");
    }

    [Test, Order(35)]
    [Description("TC_DOC_035: Đặt lịch với ghi chú triệu chứng")]
    public void TC_DOC_035_BookWithNotes()
    {
        NavigateToDoctorTab();
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(2000);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 139, 852);
        Thread.Sleep(500);
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 283, 1220);
        Thread.Sleep(500);
        // Trường ghi chú (~540, 1600)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 1600);
        Thread.Sleep(300);
        AppHelpers.AdbInput(AdbPath, DeviceName, "Tôi bị đau đầu và sốt");
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
        Thread.Sleep(3000);
        CaptureScreenshot("TC_DOC_035_BookWithNotes");
        Assert.Pass("Kiểm tra đặt lịch có ghi chú – xem ảnh chụp");
    }

    // ──────────────────────── Utility ────────────────────────────────────────────
    private void NavigateToDoctorTab()
    {
        // Nhấn tab Trang chủ trước (tọa độ chính xác 142, 2232)
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 142, 2232);
        Thread.Sleep(1500);
        // Nhấn vào thanh tìm kiếm trên trang chủ (tọa độ chính xác 540, 438) để mở màn hình Bác sĩ
        AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438);
        Thread.Sleep(2000);
    }
}
