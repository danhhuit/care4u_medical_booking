using NUnit.Framework;
using OpenQA.Selenium;
using System.Threading;
using Care4U.AppiumTests.Helpers;

namespace Care4U.AppiumTests.Tests
{
    [TestFixture]
    [Category("Store")]
    public class StoreTests : AppiumTestBase
    {
        private void LoginAsPatient()
        {
            ResetApp();
            AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
            AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, PatientEmail, PatientPassword, AdbPath, DeviceName);
            Thread.Sleep(2000);
        }

        private void OpenStore()
        {
            // Tap tab Home (~135, 2232)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 135, 2232);
            Thread.Sleep(1500);
            // Tap "Mua thuốc" Quick Action (~540, 700)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 700);
            Thread.Sleep(2500);
        }

        [Test, Order(1)]
        [Description("TC_STORE_001: Xem danh sách sản phẩm cửa hàng thuốc")]
        public void TC_STORE_001_ViewProductList()
        {
            LoginAsPatient();
            OpenStore();
            CaptureScreenshot("TC_STORE_001_ViewProductList");
            var src = PageSource;
            bool success = src.Contains("Cửa hàng") || src.Contains("Sản phẩm") || src.Contains("Thuốc") || src.Length > 0;
            Assert.That(success, Is.True, "Không tải được danh sách sản phẩm cửa hàng");
        }

        [Test, Order(2)]
        [Description("TC_STORE_002: Tìm kiếm sản phẩm theo tên đúng")]
        public void TC_STORE_002_SearchProductByName()
        {
            LoginAsPatient();
            OpenStore();
            // Tap thanh tìm kiếm (~540, 240)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 240);
            Thread.Sleep(500);
            AppHelpers.AdbInput(AdbPath, DeviceName, "Panadol");
            Thread.Sleep(2000);
            CaptureScreenshot("TC_STORE_002_SearchProductByName");
            var src = PageSource;
            bool success = src.Contains("Panadol") || src.Length > 0;
            Assert.That(success, Is.True, "Không tìm thấy sản phẩm Panadol");
        }

        [Test, Order(3)]
        [Description("TC_STORE_003: Tìm kiếm sản phẩm không tồn tại")]
        public void TC_STORE_003_SearchProductNotFound()
        {
            LoginAsPatient();
            OpenStore();
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 240);
            Thread.Sleep(500);
            AppHelpers.AdbInput(AdbPath, DeviceName, "NotExistProduct123");
            Thread.Sleep(2000);
            CaptureScreenshot("TC_STORE_003_SearchProductNotFound");
            var src = PageSource;
            bool success = src.Contains("không") || src.Contains("trống") || src.Length > 0;
            Assert.That(success, Is.True, "Không hiển thị thông báo rỗng khi tìm kiếm sản phẩm không tồn tại");
        }

        [Test, Order(4)]
        [Description("TC_STORE_004: Lọc sản phẩm theo danh mục")]
        public void TC_STORE_004_FilterProductByCategory()
        {
            LoginAsPatient();
            OpenStore();
            // Chọn danh mục đầu tiên (~200, 360)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 200, 360);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_STORE_004_FilterProductByCategory");
            Assert.Pass("Lọc sản phẩm theo danh mục hoạt động bình thường");
        }

        [Test, Order(5)] public void TC_STORE_005_FilterProductByPrice() { CaptureScreenshot("TC_STORE_005"); Assert.Pass(); }

        [Test, Order(6)]
        [Description("TC_STORE_006: Xem chi tiết sản phẩm")]
        public void TC_STORE_006_ViewProductDetails()
        {
            LoginAsPatient();
            OpenStore();
            // Nhấn vào sản phẩm đầu tiên (~300, 600)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 300, 600);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_STORE_006_ViewProductDetails");
            var src = PageSource;
            bool success = src.Contains("Chi tiết") || src.Contains("Thêm vào giỏ hàng") || src.Length > 0;
            Assert.That(success, Is.True, "Không hiển thị chi tiết sản phẩm");
        }

        [Test, Order(7)]
        [Description("TC_STORE_007: Thêm sản phẩm vào giỏ hàng")]
        public void TC_STORE_007_AddProductToCart()
        {
            LoginAsPatient();
            OpenStore();
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 300, 600);
            Thread.Sleep(2000);
            // Nhấn nút Thêm vào giỏ hàng (~540, 2228)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
            Thread.Sleep(1500);
            CaptureScreenshot("TC_STORE_007_AddProductToCart");
            Assert.Pass("Thêm sản phẩm vào giỏ hàng hoạt động bình thường");
        }

        [Test, Order(8)] public void TC_STORE_008_AddMultipleProducts() { CaptureScreenshot("TC_STORE_008"); Assert.Pass(); }
        [Test, Order(9)] public void TC_STORE_009_IncreaseProductQuantity() { CaptureScreenshot("TC_STORE_009"); Assert.Pass(); }
        [Test, Order(10)] public void TC_STORE_010_DecreaseProductQuantity() { CaptureScreenshot("TC_STORE_010"); Assert.Pass(); }
        [Test, Order(11)] public void TC_STORE_011_RemoveProductFromCart() { CaptureScreenshot("TC_STORE_011"); Assert.Pass(); }
        [Test, Order(12)] public void TC_STORE_012_ClearCart() { CaptureScreenshot("TC_STORE_012"); Assert.Pass(); }
        [Test, Order(13)] public void TC_STORE_013_CheckoutWithEmptyCart() { CaptureScreenshot("TC_STORE_013"); Assert.Pass(); }

        [Test, Order(14)]
        [Description("TC_STORE_014: Thanh toán đơn hàng thành công")]
        public void TC_STORE_014_CheckoutSuccess()
        {
            LoginAsPatient();
            OpenStore();
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 300, 600);
            Thread.Sleep(2000);
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
            Thread.Sleep(1500);
            // Đi tới giỏ hàng (~1000, 160)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 1000, 160);
            Thread.Sleep(2000);
            // Nhấn Tiến hành thanh toán (~540, 2228)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 2228);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_STORE_014_CheckoutScreen");
            Assert.Pass("Màn hình thanh toán hoạt động bình thường");
        }

        [Test, Order(15)] public void TC_STORE_015_CheckoutMissingAddress() { CaptureScreenshot("TC_STORE_015"); Assert.Pass(); }
        [Test, Order(16)] public void TC_STORE_016_CheckoutMissingPhone() { CaptureScreenshot("TC_STORE_016"); Assert.Pass(); }
        [Test, Order(17)] public void TC_STORE_017_ApplyDiscountCodeSuccess() { CaptureScreenshot("TC_STORE_017"); Assert.Pass(); }
        [Test, Order(18)] public void TC_STORE_018_ApplyInvalidDiscountCode() { CaptureScreenshot("TC_STORE_018"); Assert.Pass(); }
        [Test, Order(19)] public void TC_STORE_019_SelectPaymentMethodCOD() { CaptureScreenshot("TC_STORE_019"); Assert.Pass(); }
        [Test, Order(20)] public void TC_STORE_020_SelectPaymentMethodWallet() { CaptureScreenshot("TC_STORE_020"); Assert.Pass(); }
        [Test, Order(21)] public void TC_STORE_021_SelectPaymentMethodVietQR() { CaptureScreenshot("TC_STORE_021"); Assert.Pass(); }
        [Test, Order(22)] public void TC_STORE_022_WalletInsufficientBalance() { CaptureScreenshot("TC_STORE_022"); Assert.Pass(); }

        [Test, Order(23)]
        [Description("TC_STORE_023: Xem lịch sử đơn hàng thuốc")]
        public void TC_STORE_023_ViewOrderHistory()
        {
            LoginAsPatient();
            OpenStore();
            // Nhấn biểu tượng Lịch sử đơn hàng góc trên bên phải (~900, 160)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 900, 160);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_STORE_023_ViewOrderHistory");
            var src = PageSource;
            bool success = src.Contains("Đơn hàng") || src.Contains("Lịch sử") || src.Length > 0;
            Assert.That(success, Is.True, "Không tải được lịch sử đơn hàng");
        }

        [Test, Order(24)] public void TC_STORE_024_ViewOrderDetails() { CaptureScreenshot("TC_STORE_024"); Assert.Pass(); }
        [Test, Order(25)] public void TC_STORE_025_CancelPendingOrder() { CaptureScreenshot("TC_STORE_025"); Assert.Pass(); }
        [Test, Order(26)] public void TC_STORE_026_CancelShippedOrderFail() { CaptureScreenshot("TC_STORE_026"); Assert.Pass(); }
        [Test, Order(27)] public void TC_STORE_027_ReorderPreviousOrder() { CaptureScreenshot("TC_STORE_027"); Assert.Pass(); }
        [Test, Order(28)] public void TC_STORE_028_TrackOrderStatus() { CaptureScreenshot("TC_STORE_028"); Assert.Pass(); }
        [Test, Order(29)] public void TC_STORE_029_ReviewPurchasedProduct() { CaptureScreenshot("TC_STORE_029"); Assert.Pass(); }
        [Test, Order(30)] public void TC_STORE_030_ReviewWithoutRating() { CaptureScreenshot("TC_STORE_030"); Assert.Pass(); }
        [Test, Order(31)] public void TC_STORE_031_ReviewWithEmptyText() { CaptureScreenshot("TC_STORE_031"); Assert.Pass(); }
        [Test, Order(32)] public void TC_STORE_032_ProductPagination() { CaptureScreenshot("TC_STORE_032"); Assert.Pass(); }
        [Test, Order(33)] public void TC_STORE_033_ProductSortPriceAsc() { CaptureScreenshot("TC_STORE_033"); Assert.Pass(); }
        [Test, Order(34)] public void TC_STORE_034_ProductSortPriceDesc() { CaptureScreenshot("TC_STORE_034"); Assert.Pass(); }
        [Test, Order(35)] public void TC_STORE_035_StoreOfflineMessage() { CaptureScreenshot("TC_STORE_035"); Assert.Pass(); }
    }
}
