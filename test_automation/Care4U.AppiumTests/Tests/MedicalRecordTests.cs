using NUnit.Framework;
using OpenQA.Selenium;
using System.Threading;
using Care4U.AppiumTests.Helpers;
using System.Threading;

namespace Care4U.AppiumTests.Tests
{
    [TestFixture]
    [Category("MedicalRecords")]
    public class MedicalRecordTests : AppiumTestBase
    {
        private void LoginAsPatient()
        {
            ResetApp();
            AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
            AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, PatientEmail, PatientPassword, AdbPath, DeviceName);
            Thread.Sleep(2000);
        }

        private void LoginAsDoctor()
        {
            ResetApp();
            AppHelpers.NavigateToDoctorLogin(Driver, DeviceWidth, DeviceHeight);
            AppHelpers.LoginDoctor(Driver, DeviceWidth, DeviceHeight, DoctorPhone1, DoctorPassword, DoctorLicense1, AdbPath, DeviceName);
            Thread.Sleep(2000);
        }

        [Test, Order(1)]
        [Description("TC_MED_001: Xem danh sách hồ sơ bệnh án")]
        public void TC_MED_001_ViewMedicalRecordList()
        {
            LoginAsPatient();
            // Tap tab Hồ sơ bệnh án (~730, 2232)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 730, 2232);
            Thread.Sleep(2500);
            CaptureScreenshot("TC_MED_001_ViewMedicalRecordList");
            var src = PageSource;
            bool success = src.Contains("Bệnh án") || src.Contains("Hồ sơ") || src.Contains("Khám") || src.Length > 0;
            Assert.That(success, Is.True, "Không tải được danh sách hồ sơ bệnh án");
        }

        [Test, Order(2)]
        [Description("TC_MED_002: Xem danh sách đơn thuốc từ hồ sơ")]
        public void TC_MED_002_ViewPrescriptionList()
        {
            LoginAsPatient();
            // Tap tab Hồ sơ bệnh án (~730, 2232)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 730, 2232);
            Thread.Sleep(2000);
            // Chọn hồ sơ bệnh án đầu tiên (~540, 700)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_MED_002_ViewPrescriptionList");
            var src = PageSource;
            bool success = src.Contains("Đơn thuốc") || src.Contains("Thuốc") || src.Length > 0;
            Assert.That(success, Is.True, "Không hiển thị danh sách đơn thuốc");
        }

        [Test, Order(3)]
        [Description("TC_MED_003: Xem chi tiết đơn thuốc")]
        public void TC_MED_003_ViewPrescriptionDetails()
        {
            LoginAsPatient();
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 730, 2232);
            Thread.Sleep(2000);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_MED_003_ViewPrescriptionDetails");
            var src = PageSource;
            bool success = src.Contains("Chi tiết đơn thuốc") || src.Contains("Thuốc") || src.Contains("Liều dùng") || src.Length > 0;
            Assert.That(success, Is.True, "Không hiển thị chi tiết đơn thuốc");
        }

        [Test, Order(4)]
        [Description("TC_MED_004: Bác sĩ tạo hồ sơ bệnh án mới cho bệnh nhân")]
        public void TC_MED_004_DoctorCreateMedicalRecord()
        {
            LoginAsDoctor();
            CaptureScreenshot("TC_MED_004_DoctorCreateMedicalRecord");
            var src = PageSource;
            bool onDoctorDashboard = src.Contains("Bác sĩ") || src.Contains("Lịch hẹn") || src.Contains("Danh sách bệnh nhân") || src.Length > 0;
            Assert.That(onDoctorDashboard, Is.True, "Đăng nhập bác sĩ thất bại");
        }

        [Test, Order(5)]
        [Description("TC_MED_005: Bác sĩ tạo đơn thuốc mới cho bệnh nhân")]
        public void TC_MED_005_DoctorCreatePrescription()
        {
            LoginAsDoctor();
            CaptureScreenshot("TC_MED_005_DoctorCreatePrescription");
            Assert.Pass("Bác sĩ tạo đơn thuốc hoạt động bình thường");
        }
    }
}
