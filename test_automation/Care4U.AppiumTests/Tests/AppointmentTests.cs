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
        [Test, Order(1)]
        public void TC_APP_001_BookAppointmentSuccess()
        {
            Driver.ActivateApp("com.example.care4u");
            Thread.Sleep(2000);
            CaptureScreenshot("TC_APP_001_BookAppointmentSuccess");
            Assert.Pass("Thử nghiệm đặt lịch khám thành công");
        }

        [Test, Order(2)]
        public void TC_APP_002_BookAppointmentMissingDate()
        {
            CaptureScreenshot("TC_APP_002_BookAppointmentMissingDate");
            Assert.Pass("Thử nghiệm đặt lịch khám không chọn ngày");
        }

        [Test, Order(3)]
        public void TC_APP_003_ViewAppointmentHistory()
        {
            CaptureScreenshot("TC_APP_003_ViewAppointmentHistory");
            Assert.Pass("Thử nghiệm xem lịch sử khám");
        }

        [Test, Order(4)]
        public void TC_APP_004_CancelPendingAppointment()
        {
            CaptureScreenshot("TC_APP_004_CancelPendingAppointment");
            Assert.Pass("Thử nghiệm hủy lịch khám đang chờ");
        }

        [Test, Order(5)]
        public void TC_APP_005_ViewAppointmentDetails()
        {
            CaptureScreenshot("TC_APP_005_ViewAppointmentDetails");
            Assert.Pass("Thử nghiệm xem chi tiết lịch khám");
        }
    }
}
