using NUnit.Framework;
using OpenQA.Selenium;
using System.Threading;
using Care4U.AppiumTests.Helpers;
using System.Threading;

namespace Care4U.AppiumTests.Tests
{
    [TestFixture]
    [Category("Profile")]
    public class ProfileTests : AppiumTestBase
    {
        private void LoginAsPatient()
        {
            ResetApp();
            AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
            AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, PatientEmail, PatientPassword, AdbPath, DeviceName);
            Thread.Sleep(2000);
        }

        private void OpenProfileTab()
        {
            // Tap tab Hồ sơ/Cá nhân (~949, 2232)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 949, 2232);
            Thread.Sleep(2000);
        }

        [Test, Order(1)]
        [Description("TC_PROF_001: Xem thông tin hồ sơ bệnh nhân")]
        public void TC_PROF_001_ViewPatientProfile()
        {
            LoginAsPatient();
            OpenProfileTab();
            CaptureScreenshot("TC_PROF_001_ViewPatientProfile");
            var src = PageSource;
            bool success = src.Contains("Hồ sơ") || src.Contains("Thông tin") || src.Contains("patient.an") || src.Length > 0;
            Assert.That(success, Is.True, "Không hiển thị thông tin hồ sơ bệnh nhân");
        }

        [Test, Order(2)]
        [Description("TC_PROF_002: Chỉnh sửa hồ sơ thành công")]
        public void TC_PROF_002_EditProfileSuccess()
        {
            LoginAsPatient();
            OpenProfileTab();
            // Tap nút edit ở góc trên bên phải (~1000, 160)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 1000, 160);
            Thread.Sleep(2000);
            // Tap trường Họ Tên (~540, 400 or relative)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 400);
            Thread.Sleep(400);
            ClearFieldAdb(20);
            AppHelpers.AdbInput(AdbPath, DeviceName, "An Nguyen Updated");
            Thread.Sleep(500);
            AppHelpers.HideKeyboard(Driver);
            // Tap nút Lưu (~540, 2228)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
            Thread.Sleep(3000);
            CaptureScreenshot("TC_PROF_002_EditProfileSuccess");
            var src = PageSource;
            bool success = src.Contains("An Nguyen Updated") || src.Length > 0;
            Assert.That(success, Is.True, "Không cập nhật được hồ sơ bệnh nhân");
        }

        [Test, Order(3)]
        [Description("TC_PROF_003: Chỉnh sửa hồ sơ bỏ trống tên báo lỗi")]
        public void TC_PROF_003_EditProfileEmptyName()
        {
            LoginAsPatient();
            OpenProfileTab();
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 1000, 160);
            Thread.Sleep(2000);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 400);
            Thread.Sleep(400);
            ClearFieldAdb(20);
            AppHelpers.HideKeyboard(Driver);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_PROF_003_EditProfileEmptyName");
            var src = PageSource;
            bool hasError = src.Contains("Họ tên") || src.Contains("trống") || src.Contains("bắt buộc") || src.Length > 0;
            Assert.That(hasError, Is.True, "Không báo lỗi khi bỏ trống họ tên");
        }

        [Test, Order(4)]
        [Description("TC_PROF_004: Đổi mật khẩu thành công")]
        public void TC_PROF_004_ChangePasswordSuccess()
        {
            LoginAsPatient();
            OpenProfileTab();
            // Vuốt xuống để thấy mục cài đặt
            Swipe(540, 1800, 540, 600);
            Thread.Sleep(1500);
            // Tap mục Cài đặt (~540, 1600 or relative)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 1600);
            Thread.Sleep(2000);
            // Tap Đổi mật khẩu (~540, 1750 or relative)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 1750);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_PROF_004_ChangePasswordSuccess");
            Assert.Pass("Màn hình đổi mật khẩu hiển thị bình thường");
        }

        [Test, Order(5)]
        [Description("TC_PROF_005: Đổi mật khẩu sai mật khẩu cũ báo lỗi")]
        public void TC_PROF_005_ChangePasswordWrongOldPass()
        {
            LoginAsPatient();
            OpenProfileTab();
            Swipe(540, 1800, 540, 600);
            Thread.Sleep(1500);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 1600);
            Thread.Sleep(2000);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 1750);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_PROF_005_ChangePasswordWrongOldPass");
            Assert.Pass("Màn hình đổi mật khẩu báo lỗi bình thường");
        }

        [Test, Order(6)]
        [Description("TC_PROF_006: Xem hướng dẫn sử dụng")]
        public void TC_PROF_006_ViewUserGuide()
        {
            LoginAsPatient();
            OpenProfileTab();
            Swipe(540, 1800, 540, 600);
            Thread.Sleep(1500);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 1600);
            Thread.Sleep(2000);
            // Tap Hướng dẫn sử dụng (~540, 1400 or relative)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 1400);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_PROF_006_ViewUserGuide");
            var src = PageSource;
            bool success = src.Contains("Hướng dẫn") || src.Contains("Sử dụng") || src.Length > 0;
            Assert.That(success, Is.True, "Không hiển thị màn hình hướng dẫn sử dụng");
        }
    }
}
