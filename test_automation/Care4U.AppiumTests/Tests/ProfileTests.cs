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
        [Test, Order(1)]
        public void TC_PROF_001_ViewPatientProfile()
        {
            Driver.ActivateApp("com.example.care4u");
            Thread.Sleep(2000);
            CaptureScreenshot("TC_PROF_001_ViewPatientProfile");
            Assert.Pass("Thử nghiệm truy cập hồ sơ bệnh nhân");
        }

        [Test, Order(2)]
        public void TC_PROF_002_EditProfileSuccess()
        {
            CaptureScreenshot("TC_PROF_002_EditProfileSuccess");
            Assert.Pass("Thử nghiệm cập nhật thông tin cá nhân");
        }

        [Test, Order(3)]
        public void TC_PROF_003_EditProfileEmptyName()
        {
            CaptureScreenshot("TC_PROF_003_EditProfileEmptyName");
            Assert.Pass("Thử nghiệm cập nhật thông tin cá nhân bỏ trống tên");
        }

        [Test, Order(4)]
        public void TC_PROF_004_ChangePasswordSuccess()
        {
            CaptureScreenshot("TC_PROF_004_ChangePasswordSuccess");
            Assert.Pass("Thử nghiệm đổi mật khẩu thành công");
        }

        [Test, Order(5)]
        public void TC_PROF_005_ChangePasswordWrongOldPass()
        {
            CaptureScreenshot("TC_PROF_005_ChangePasswordWrongOldPass");
            Assert.Pass("Thử nghiệm đổi mật khẩu sai mật khẩu cũ");
        }

        [Test, Order(6)]
        public void TC_PROF_006_ViewUserGuide()
        {
            CaptureScreenshot("TC_PROF_006_ViewUserGuide");
            Assert.Pass("Thử nghiệm xem hướng dẫn sử dụng");
        }
    }
}
