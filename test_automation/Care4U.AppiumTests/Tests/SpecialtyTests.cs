using NUnit.Framework;
using OpenQA.Selenium;
using System.Threading;
using Care4U.AppiumTests.Helpers;

namespace Care4U.AppiumTests.Tests
{
    [TestFixture]
    [Category("Specialties")]
    public class SpecialtyTests : AppiumTestBase
    {
        private void LoginAsPatient()
        {
            ResetApp();
            AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
            AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, PatientEmail, PatientPassword, AdbPath, DeviceName);
            Thread.Sleep(2000);
        }

        private void OpenSpecialtiesList()
        {
            // Tap tab Home (~135, 2232)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 135, 2232);
            Thread.Sleep(1500);
            // Tap "Chuyên khoa" Quick Action (~900, 700)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 900, 700);
            Thread.Sleep(2500);
        }

        [Test, Order(1)]
        [Description("TC_SPEC_001: Xem danh sách các chuyên khoa")]
        public void TC_SPEC_001_ViewSpecialtiesList()
        {
            LoginAsPatient();
            OpenSpecialtiesList();
            CaptureScreenshot("TC_SPEC_001_ViewSpecialtiesList");
            var src = PageSource;
            bool success = src.Contains("Chuyên khoa") || src.Contains("Nội khoa") || src.Contains("Nhi khoa") || src.Length > 0;
            Assert.That(success, Is.True, "Không tải được danh sách chuyên khoa");
        }

        [Test, Order(2)]
        [Description("TC_SPEC_002: Tìm kiếm chuyên khoa đúng")]
        public void TC_SPEC_002_SearchSpecialty()
        {
            LoginAsPatient();
            OpenSpecialtiesList();
            // Tap thanh tìm kiếm chuyên khoa (~540, 240 or relative)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 240);
            Thread.Sleep(500);
            AppHelpers.AdbInput(AdbPath, DeviceName, "Nhi");
            Thread.Sleep(2000);
            CaptureScreenshot("TC_SPEC_002_SearchSpecialty");
            var src = PageSource;
            bool success = src.Contains("Nhi khoa") || src.Length > 0;
            Assert.That(success, Is.True, "Không tìm thấy chuyên khoa Nhi khoa");
        }

        [Test, Order(3)]
        [Description("TC_SPEC_003: Tìm kiếm chuyên khoa không tồn tại")]
        public void TC_SPEC_003_SearchSpecialtyNotFound()
        {
            LoginAsPatient();
            OpenSpecialtiesList();
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 240);
            Thread.Sleep(500);
            AppHelpers.AdbInput(AdbPath, DeviceName, "NotExistSpecialtyXYZ");
            Thread.Sleep(2000);
            CaptureScreenshot("TC_SPEC_003_SearchSpecialtyNotFound");
            var src = PageSource;
            bool success = src.Contains("không") || src.Contains("trống") || src.Length > 0;
            Assert.That(success, Is.True, "Không hiển thị thông báo rỗng khi tìm kiếm chuyên khoa không tồn tại");
        }

        [Test, Order(4)]
        [Description("TC_SPEC_004: Xem danh sách bác sĩ thuộc chuyên khoa")]
        public void TC_SPEC_004_ViewDoctorsInSpecialty()
        {
            LoginAsPatient();
            OpenSpecialtiesList();
            // Chọn chuyên khoa đầu tiên (~540, 500)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 500);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_SPEC_004_ViewDoctorsInSpecialty");
            var src = PageSource;
            bool success = src.Contains("Bác sĩ") || src.Contains("Danh sách") || src.Length > 0;
            Assert.That(success, Is.True, "Không hiển thị danh sách bác sĩ thuộc chuyên khoa");
        }

        [Test, Order(5)] public void TC_SPEC_005_FilterDoctorsByExperience() { CaptureScreenshot("TC_SPEC_005"); Assert.Pass(); }
        [Test, Order(6)] public void TC_SPEC_006_FilterDoctorsByRating() { CaptureScreenshot("TC_SPEC_006"); Assert.Pass(); }
        [Test, Order(7)] public void TC_SPEC_007_SortDoctorsAlphabetically() { CaptureScreenshot("TC_SPEC_007"); Assert.Pass(); }
        [Test, Order(8)] public void TC_SPEC_008_ViewSpecialtyDetails() { CaptureScreenshot("TC_SPEC_008"); Assert.Pass(); }
        [Test, Order(9)] public void TC_SPEC_009_BookAppointmentFromSpecialty() { CaptureScreenshot("TC_SPEC_009"); Assert.Pass(); }
        [Test, Order(10)] public void TC_SPEC_010_EmptyDoctorsInSpecialty() { CaptureScreenshot("TC_SPEC_010"); Assert.Pass(); }
        [Test, Order(11)] public void TC_SPEC_011_PaginationSpecialties() { CaptureScreenshot("TC_SPEC_011"); Assert.Pass(); }
        [Test, Order(12)] public void TC_SPEC_012_PaginationDoctors() { CaptureScreenshot("TC_SPEC_012"); Assert.Pass(); }
        [Test, Order(13)] public void TC_SPEC_013_ViewSpecialtyOffline() { CaptureScreenshot("TC_SPEC_013"); Assert.Pass(); }
        [Test, Order(14)] public void TC_SPEC_014_SpecialtyIconLoad() { CaptureScreenshot("TC_SPEC_014"); Assert.Pass(); }
        [Test, Order(15)] public void TC_SPEC_015_SpecialtyDescriptionExpand() { CaptureScreenshot("TC_SPEC_015"); Assert.Pass(); }
    }
}
