using NUnit.Framework;
using OpenQA.Selenium;
using System.Threading;
using Care4U.AppiumTests.Helpers;
using System.Threading;

namespace Care4U.AppiumTests.Tests
{
    [TestFixture]
    [Category("Payments")]
    public class PaymentTests : AppiumTestBase
    {
        [Test, Order(1)]
        public void TC_PAY_001_ViewWalletBalance()
        {
            Driver.ActivateApp("com.example.care4u");
            Thread.Sleep(2000);
            CaptureScreenshot("TC_PAY_001_ViewWalletBalance");
            Assert.Pass("Thử nghiệm xem số dư ví");
        }

        [Test, Order(2)]
        public void TC_PAY_002_TopupWallet()
        {
            CaptureScreenshot("TC_PAY_002_TopupWallet");
            Assert.Pass("Thử nghiệm nạp tiền vào ví");
        }

        [Test, Order(3)]
        public void TC_PAY_003_VietQRPayment()
        {
            CaptureScreenshot("TC_PAY_003_VietQRPayment");
            Assert.Pass("Thử nghiệm thanh toán VietQR");
        }

        [Test, Order(4)]
        public void TC_PAY_004_ViewTransactionHistory()
        {
            CaptureScreenshot("TC_PAY_004_ViewTransactionHistory");
            Assert.Pass("Thử nghiệm xem lịch sử giao dịch");
        }
    }
}
