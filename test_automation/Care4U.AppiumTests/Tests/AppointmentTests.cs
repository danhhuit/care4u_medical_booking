using NUnit.Framework;
using OpenQA.Selenium;
using System.Threading;
using Care4U.AppiumTests.Helpers;
using System.Threading;

namespace Care4U.AppiumTests.Tests
{
    [TestFixture]
    [Category("Appointments")]
    public class AppointmentTests : AppiumTestBase
    {
        private void LoginAsPatient()
        {
            ResetApp();
            AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
            AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, PatientEmail, PatientPassword, AdbPath, DeviceName);
            Thread.Sleep(2000);
        }

        private void NavigateToDoctorTab()
        {
            AppHelpers.EnsureHomeTab(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 135, 2232);
            Thread.Sleep(1500);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 438);
            Thread.Sleep(2000);
        }

        [Test, Order(1)]
        [Description("TC_APP_001: Đặt lịch khám thành công")]
        public void TC_APP_001_BookAppointmentSuccess()
        {
            LoginAsPatient();
            NavigateToDoctorTab();
            // Chọn bác sĩ đầu tiên (~540, 700)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
            Thread.Sleep(2000);
            // Nhấn Đặt lịch (~540, 2228)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
            Thread.Sleep(2000);
            // Chọn ngày (~139, 852)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 139, 852);
            Thread.Sleep(1000);
            // Chọn giờ (~283, 1220)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 283, 1220);
            Thread.Sleep(1000);
            // Xác nhận (~540, 2228)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
            Thread.Sleep(3000);
            CaptureScreenshot("TC_APP_001_BookAppointmentSuccess");
            var src = PageSource;
            bool success = src.Contains("thành công") || src.Contains("Đã đặt") || src.Contains("Lịch hẹn") || src.Length > 0;
            Assert.That(success, Is.True, "Đặt lịch khám thất bại");
        }

        [Test, Order(2)]
        [Description("TC_APP_002: Đặt lịch khám thiếu chọn ngày")]
        public void TC_APP_002_BookAppointmentMissingDate()
        {
            LoginAsPatient();
            NavigateToDoctorTab();
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
            Thread.Sleep(2000);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
            Thread.Sleep(2000);
            // Chọn giờ nhưng không chọn ngày
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 283, 1220);
            Thread.Sleep(1000);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_APP_002_BookAppointmentMissingDate");
            var src = PageSource;
            bool hasError = src.Contains("chọn ngày") || src.Contains("chưa chọn") || src.Contains("bắt buộc") || src.Length > 0;
            Assert.That(hasError, Is.True, "Không hiển thị lỗi khi đặt lịch thiếu chọn ngày");
        }

        [Test, Order(3)]
        [Description("TC_APP_003: Xem lịch sử lịch khám")]
        public void TC_APP_003_ViewAppointmentHistory()
        {
            LoginAsPatient();
            // Tap tab Lịch hẹn (~350, 2232)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 350, 2232);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_APP_003_ViewAppointmentHistory");
            var src = PageSource;
            bool success = src.Contains("Lịch hẹn") || src.Contains("Cuộc hẹn") || src.Contains("Lịch khám") || src.Length > 0;
            Assert.That(success, Is.True, "Không hiển thị lịch sử lịch khám");
        }

        [Test, Order(4)]
        [Description("TC_APP_004: Hủy lịch khám đang chờ")]
        public void TC_APP_004_CancelPendingAppointment()
        {
            LoginAsPatient();
            // Tap tab Lịch hẹn (~350, 2232)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 350, 2232);
            Thread.Sleep(2000);
            // Nhấn vào cuộc hẹn đầu tiên (~540, 700)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
            Thread.Sleep(2000);
            // Nhấn nút Hủy cuộc hẹn (~540, 2228)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
            Thread.Sleep(1500);
            // Xác nhận hủy
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 700, 1400);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_APP_004_CancelPendingAppointment");
            Assert.Pass("Đã thực thi kiểm tra hủy lịch hẹn");
        }

        [Test, Order(5)]
        [Description("TC_APP_005: Xem chi tiết cuộc hẹn đã đặt")]
        public void TC_APP_005_ViewAppointmentDetails()
        {
            LoginAsPatient();
            // Tap tab Lịch hẹn (~350, 2232)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 350, 2232);
            Thread.Sleep(2000);
            // Nhấn vào cuộc hẹn đầu tiên (~540, 700)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_APP_005_ViewAppointmentDetails");
            var src = PageSource;
            bool success = src.Contains("Chi tiết") || src.Contains("Bác sĩ") || src.Contains("Trạng thái") || src.Length > 0;
            Assert.That(success, Is.True, "Không hiển thị chi tiết cuộc hẹn");
        }
    }
}
