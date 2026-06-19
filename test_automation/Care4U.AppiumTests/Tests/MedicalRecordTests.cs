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
        [Test, Order(1)]
        public void TC_MED_001_ViewMedicalRecordList()
        {
            Driver.ActivateApp("com.example.care4u");
            Thread.Sleep(2000);
            CaptureScreenshot("TC_MED_001_ViewMedicalRecordList");
            Assert.Pass("Thử nghiệm xem danh sách bệnh án");
        }

        [Test, Order(2)]
        public void TC_MED_002_ViewPrescriptionList()
        {
            CaptureScreenshot("TC_MED_002_ViewPrescriptionList");
            Assert.Pass("Thử nghiệm xem danh sách đơn thuốc");
        }

        [Test, Order(3)]
        public void TC_MED_003_ViewPrescriptionDetails()
        {
            CaptureScreenshot("TC_MED_003_ViewPrescriptionDetails");
            Assert.Pass("Thử nghiệm xem chi tiết đơn thuốc");
        }

        [Test, Order(4)]
        public void TC_MED_004_DoctorCreateMedicalRecord()
        {
            CaptureScreenshot("TC_MED_004_DoctorCreateMedicalRecord");
            Assert.Pass("Thử nghiệm bác sĩ tạo bệnh án");
        }

        [Test, Order(5)]
        public void TC_MED_005_DoctorCreatePrescription()
        {
            CaptureScreenshot("TC_MED_005_DoctorCreatePrescription");
            Assert.Pass("Thử nghiệm bác sĩ tạo đơn thuốc");
        }
    }
}
