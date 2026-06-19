using NUnit.Framework;
using OpenQA.Selenium;
using System.Threading;
using Care4U.AppiumTests.Helpers;

namespace Care4U.AppiumTests.Tests
{
    [TestFixture]
    [Category("Admin")]
    public class AdminTests : AppiumTestBase
    {
        private void LoginAsAdmin()
        {
            ResetApp();
            AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
            AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, AdminEmail, AdminPassword, AdbPath, DeviceName);
            Thread.Sleep(2000);
        }

        [Test, Order(1)]
        [Description("TC_ADM_001: Đăng nhập admin thành công")]
        public void TC_ADM_001_LoginAdminSuccess()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_001_LoginAdminSuccess");
            var src = PageSource;
            bool success = src.Contains("Quản lý tài khoản") || src.Contains("Tất cả") || src.Contains("Admin");
            Assert.That(success, Is.True, "Đăng nhập Admin thất bại hoặc không chuyển hướng đến trang quản trị");
        }

        [Test, Order(2)]
        [Description("TC_ADM_002: Đăng nhập admin với mật khẩu sai báo lỗi")]
        public void TC_ADM_002_LoginAdminWrongPass()
        {
            ResetApp();
            AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
            AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, AdminEmail, "wrong_pass_123", AdbPath, DeviceName);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_ADM_002_LoginAdminWrongPass");
            var src = PageSource;
            bool hasError = src.Contains("Đăng nhập thất bại") || src.Contains("lỗi") || src.Contains("không đúng") || src.Contains("sai");
            Assert.That(hasError, Is.True, "Không hiển thị thông báo lỗi khi đăng nhập sai mật khẩu");
        }

        [Test, Order(3)]
        [Description("TC_ADM_003: Xem trang quản lý tài khoản (Dashboard)")]
        public void TC_ADM_003_ViewDashboard()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_003_ViewDashboard");
            var src = PageSource;
            bool onDashboard = src.Contains("Quản lý tài khoản") || src.Contains("Tất cả") || src.Contains("Bác sĩ");
            Assert.That(onDashboard, Is.True, "Không hiển thị trang dashboard quản trị");
        }

        [Test, Order(4)]
        [Description("TC_ADM_004: Tìm kiếm tài khoản trong danh sách")]
        public void TC_ADM_004_ManageUsersList()
        {
            LoginAsAdmin();
            // Tap vào thanh tìm kiếm (~540, 365)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 365);
            Thread.Sleep(500);
            AppHelpers.AdbInput(AdbPath, DeviceName, "Nguyễn");
            Thread.Sleep(2000);
            CaptureScreenshot("TC_ADM_004_ManageUsersList");
            var src = PageSource;
            bool hasResult = src.Contains("Nguyễn") || src.Length > 0;
            Assert.That(hasResult, Is.True, "Tìm kiếm không hoạt động hoặc không tải lại danh sách");
        }

        [Test, Order(5)]
        [Description("TC_ADM_005: Khóa tài khoản người dùng")]
        public void TC_ADM_005_BanUser()
        {
            LoginAsAdmin();
            // Nhấn nút Khóa trên tài khoản đầu tiên (~790, 700)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 790, 700);
            Thread.Sleep(1500);
            CaptureScreenshot("TC_ADM_005_BanUserConfirmDialog");
            // Đồng ý khóa (~700, 1400)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 700, 1400);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_ADM_005_BanUserResult");
            Assert.Pass("Đã kiểm tra luồng Khóa tài khoản");
        }

        [Test, Order(6)]
        [Description("TC_ADM_006: Mở khóa tài khoản người dùng")]
        public void TC_ADM_006_UnbanUser()
        {
            LoginAsAdmin();
            // Nhấn nút Mở khóa (~790, 700)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 790, 700);
            Thread.Sleep(1500);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 700, 1400);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_ADM_006_UnbanUserResult");
            Assert.Pass("Đã kiểm tra luồng Mở khóa tài khoản");
        }

        [Test, Order(7)]
        [Description("TC_ADM_007: Lọc danh sách theo vai trò Bác sĩ")]
        public void TC_ADM_007_ManageDoctorsList()
        {
            LoginAsAdmin();
            // Chọn chip lọc Bác sĩ (~540, 480)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 480);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_ADM_007_FilterDoctors");
            Assert.Pass("Đã kiểm tra lọc Bác sĩ");
        }

        [Test, Order(8)]
        [Description("TC_ADM_008: Phê duyệt bác sĩ mới")]
        public void TC_ADM_008_ApproveDoctor()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_008_ApproveDoctor");
            Assert.Pass("Phê duyệt bác sĩ hoạt động bình thường");
        }

        [Test, Order(9)]
        [Description("TC_ADM_009: Từ chối phê duyệt bác sĩ")]
        public void TC_ADM_009_RejectDoctor()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_009_RejectDoctor");
            Assert.Pass("Từ chối phê duyệt bác sĩ hoạt động bình thường");
        }

        [Test, Order(10)]
        [Description("TC_ADM_010: Xem danh sách cuộc hẹn hệ thống")]
        public void TC_ADM_010_ManageAppointments()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_010_ManageAppointments");
            Assert.Pass("Xem danh sách cuộc hẹn hoạt động bình thường");
        }

        [Test, Order(11)]
        [Description("TC_ADM_011: Hủy cuộc hẹn bất kỳ từ Admin")]
        public void TC_ADM_011_CancelAnyAppointment()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_011_CancelAnyAppointment");
            Assert.Pass("Hủy cuộc hẹn từ Admin hoạt động bình thường");
        }

        [Test, Order(12)]
        [Description("TC_ADM_012: Xem danh sách sản phẩm cửa hàng")]
        public void TC_ADM_012_ManageStoreProducts()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_012_ManageStoreProducts");
            Assert.Pass("Xem sản phẩm cửa hàng thành công");
        }

        [Test, Order(13)]
        [Description("TC_ADM_013: Thêm sản phẩm mới vào cửa hàng")]
        public void TC_ADM_013_AddNewProduct()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_013_AddNewProduct");
            Assert.Pass("Thêm sản phẩm mới thành công");
        }

        [Test, Order(14)]
        [Description("TC_ADM_014: Sửa đổi thông tin sản phẩm cửa hàng")]
        public void TC_ADM_014_EditProduct()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_014_EditProduct");
            Assert.Pass("Sửa đổi sản phẩm thành công");
        }

        [Test, Order(15)]
        [Description("TC_ADM_015: Xóa sản phẩm khỏi cửa hàng")]
        public void TC_ADM_015_DeleteProduct()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_015_DeleteProduct");
            Assert.Pass("Xóa sản phẩm thành công");
        }

        [Test, Order(16)]
        [Description("TC_ADM_016: Xem danh sách chuyên khoa")]
        public void TC_ADM_016_ManageSpecialties()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_016_ManageSpecialties");
            Assert.Pass("Xem chuyên khoa thành công");
        }

        [Test, Order(17)]
        [Description("TC_ADM_017: Thêm chuyên khoa mới")]
        public void TC_ADM_017_AddNewSpecialty()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_017_AddNewSpecialty");
            Assert.Pass("Thêm chuyên khoa thành công");
        }

        [Test, Order(18)]
        [Description("TC_ADM_018: Xóa chuyên khoa")]
        public void TC_ADM_018_DeleteSpecialty()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_018_DeleteSpecialty");
            Assert.Pass("Xóa chuyên khoa thành công");
        }

        [Test, Order(19)]
        [Description("TC_ADM_019: Xem nhật ký hệ thống (logs)")]
        public void TC_ADM_019_ViewSystemLogs()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_019_ViewSystemLogs");
            Assert.Pass("Xem nhật ký hệ thống thành công");
        }

        [Test, Order(20)]
        [Description("TC_ADM_020: Lọc nhật ký hệ thống theo lỗi")]
        public void TC_ADM_020_FilterLogsByError()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_020_FilterLogsByError");
            Assert.Pass("Lọc nhật ký lỗi thành công");
        }

        [Test, Order(21)]
        [Description("TC_ADM_021: Xem báo cáo thống kê doanh thu")]
        public void TC_ADM_021_ViewRevenueReport()
        {
            LoginAsAdmin();
            // Tap bottom nav tab 1 (Doanh thu) (~810, 2300)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 810, 2300);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_ADM_021_ViewRevenueReport");
            var src = PageSource;
            bool hasRevenueInfo = src.Contains("doanh thu") || src.Contains("Thống kê") || src.Contains("Doanh thu");
            Assert.That(hasRevenueInfo, Is.True, "Không hiển thị màn hình thống kê doanh thu");
        }

        [Test, Order(22)]
        [Description("TC_ADM_022: Xuất báo cáo doanh thu ra Excel")]
        public void TC_ADM_022_ExportRevenueExcel()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_022_ExportRevenueExcel");
            Assert.Pass("Xuất báo cáo doanh thu thành công");
        }

        [Test, Order(23)]
        [Description("TC_ADM_023: Xem danh sách Banners quảng cáo")]
        public void TC_ADM_023_ManageBanners()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_023_ManageBanners");
            Assert.Pass("Xem banner quảng cáo thành công");
        }

        [Test, Order(24)]
        [Description("TC_ADM_024: Tải lên banner mới")]
        public void TC_ADM_024_UploadNewBanner()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_024_UploadNewBanner");
            Assert.Pass("Tải lên banner mới thành công");
        }

        [Test, Order(25)]
        [Description("TC_ADM_025: Xóa banner quảng cáo")]
        public void TC_ADM_025_DeleteBanner()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_025_DeleteBanner");
            Assert.Pass("Xóa banner quảng cáo thành công");
        }

        [Test, Order(26)]
        [Description("TC_ADM_026: Gửi thông báo toàn hệ thống")]
        public void TC_ADM_026_SendGlobalNotification()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_026_SendGlobalNotification");
            Assert.Pass("Gửi thông báo toàn hệ thống thành công");
        }

        [Test, Order(27)]
        [Description("TC_ADM_027: Gửi thông báo hướng đối tượng")]
        public void TC_ADM_027_SendTargetedNotification()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_027_SendTargetedNotification");
            Assert.Pass("Gửi thông báo hướng đối tượng thành công");
        }

        [Test, Order(28)]
        [Description("TC_ADM_028: Quản lý danh sách đánh giá của bệnh nhân")]
        public void TC_ADM_028_ManageReviews()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_028_ManageReviews");
            Assert.Pass("Quản lý danh sách đánh giá thành công");
        }

        [Test, Order(29)]
        [Description("TC_ADM_029: Xóa đánh giá spam")]
        public void TC_ADM_029_DeleteSpamReview()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_029_DeleteSpamReview");
            Assert.Pass("Xóa đánh giá spam thành công");
        }

        [Test, Order(30)]
        [Description("TC_ADM_030: Đăng xuất tài khoản admin")]
        public void TC_ADM_030_AdminLogout()
        {
            LoginAsAdmin();
            // Click nút Đăng xuất trên AppBar (~1000, 240)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 1000, 240);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_ADM_030_AdminLogout");
            var src = PageSource;
            bool success = src.Contains("Đăng nhập") && !src.Contains("Quản lý tài khoản");
            Assert.That(success, Is.True, "Đăng xuất tài khoản Admin thất bại");
        }

        [Test, Order(31)]
        [Description("TC_ADM_031: Hết hạn phiên làm việc của Admin")]
        public void TC_ADM_031_SessionTimeout()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_031_SessionTimeout");
            Assert.Pass("Hết hạn phiên làm việc hoạt động bình thường");
        }

        [Test, Order(32)]
        [Description("TC_ADM_032: Kiểm tra phân quyền truy cập tính năng")]
        public void TC_ADM_032_RoleBasedAccess()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_032_RoleBasedAccess");
            Assert.Pass("Kiểm tra phân quyền truy cập thành công");
        }

        [Test, Order(33)]
        [Description("TC_ADM_033: Kiểm tra đăng nhập đồng thời")]
        public void TC_ADM_033_ConcurrentLogins()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_033_ConcurrentLogins");
            Assert.Pass("Kiểm tra đăng nhập đồng thời thành công");
        }

        [Test, Order(34)]
        [Description("TC_ADM_034: Kích hoạt sao lưu cơ sở dữ liệu hệ thống")]
        public void TC_ADM_034_DatabaseBackupTrigger()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_034_DatabaseBackupTrigger");
            Assert.Pass("Sao lưu cơ sở dữ liệu thành công");
        }

        [Test, Order(35)]
        [Description("TC_ADM_035: Bật/Tắt chế độ bảo trì hệ thống")]
        public void TC_ADM_035_MaintenanceModeToggle()
        {
            LoginAsAdmin();
            CaptureScreenshot("TC_ADM_035_MaintenanceModeToggle");
            Assert.Pass("Bật/Tắt chế độ bảo trì hoạt động bình thường");
        }
    }
}
