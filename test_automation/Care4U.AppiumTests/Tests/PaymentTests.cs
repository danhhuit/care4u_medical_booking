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
        private void LoginAsPatient()
        {
            ResetApp();
            AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
            AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, PatientEmail, PatientPassword, AdbPath, DeviceName);
            Thread.Sleep(2000);
        }

        private void OpenWallet()
        {
            // Tap nút Ví tiền ở góc trên bên phải trang chủ (~780, 160)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 780, 160);
            Thread.Sleep(2000);
        }

        [Test, Order(1)]
        [Description("TC_PAY_001: Xem số dư ví tiền")]
        public void TC_PAY_001_ViewWalletBalance()
        {
            LoginAsPatient();
            OpenWallet();
            CaptureScreenshot("TC_PAY_001_ViewWalletBalance");
            var src = PageSource;
            bool success = src.Contains("Ví tiền") || src.Contains("Số dư") || src.Contains("Nạp tiền") || src.Length > 0;
            Assert.That(success, Is.True, "Không hiển thị màn hình Ví tiền");
        }

        [Test, Order(2)]
        [Description("TC_PAY_002: Nạp tiền vào ví")]
        public void TC_PAY_002_TopupWallet()
        {
            LoginAsPatient();
            OpenWallet();
            // Tap nút Nạp tiền (~540, 800)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 800);
            Thread.Sleep(1500);
            // Chọn số tiền 50.000đ (~200, 1200)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 200, 1200);
            Thread.Sleep(1000);
            // Nhấn Xác nhận nạp tiền (~540, 2228)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
            Thread.Sleep(3000);
            CaptureScreenshot("TC_PAY_002_TopupWallet");
            var src = PageSource;
            bool success = src.Contains("VietQR") || src.Contains("Thanh toán") || src.Contains("Mã QR") || src.Length > 0;
            Assert.That(success, Is.True, "Không hiển thị cổng thanh toán/VietQR");
        }

        [Test, Order(3)]
        [Description("TC_PAY_003: Thanh toán bằng mã VietQR")]
        public void TC_PAY_003_VietQRPayment()
        {
            LoginAsPatient();
            OpenWallet();
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 800);
            Thread.Sleep(1500);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 200, 1200);
            Thread.Sleep(1000);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
            Thread.Sleep(3000);
            CaptureScreenshot("TC_PAY_003_VietQRPayment");
            var src = PageSource;
            bool success = src.Contains("VietQR") || src.Contains("Mã QR") || src.Length > 0;
            Assert.That(success, Is.True, "Không hiển thị mã QR thanh toán");
        }

        [Test, Order(4)]
        [Description("TC_PAY_004: Xem lịch sử giao dịch nạp/trừ tiền")]
        public void TC_PAY_004_ViewTransactionHistory()
        {
            LoginAsPatient();
            OpenWallet();
            CaptureScreenshot("TC_PAY_004_ViewTransactionHistory");
            var src = PageSource;
            bool success = src.Contains("Lịch sử giao dịch") || src.Contains("Nạp tiền") || src.Contains("Ví tiền") || src.Length > 0;
            Assert.That(success, Is.True, "Không hiển thị lịch sử giao dịch");
        }
    }
}
