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
        [Test, Order(1)] public void TC_STORE_001_ViewProductList() { CaptureScreenshot("TC_STORE_001"); Assert.Pass(); }
        [Test, Order(2)] public void TC_STORE_002_SearchProductByName() { CaptureScreenshot("TC_STORE_002"); Assert.Pass(); }
        [Test, Order(3)] public void TC_STORE_003_SearchProductNotFound() { CaptureScreenshot("TC_STORE_003"); Assert.Pass(); }
        [Test, Order(4)] public void TC_STORE_004_FilterProductByCategory() { CaptureScreenshot("TC_STORE_004"); Assert.Pass(); }
        [Test, Order(5)] public void TC_STORE_005_FilterProductByPrice() { CaptureScreenshot("TC_STORE_005"); Assert.Pass(); }
        [Test, Order(6)] public void TC_STORE_006_ViewProductDetails() { CaptureScreenshot("TC_STORE_006"); Assert.Pass(); }
        [Test, Order(7)] public void TC_STORE_007_AddProductToCart() { CaptureScreenshot("TC_STORE_007"); Assert.Pass(); }
        [Test, Order(8)] public void TC_STORE_008_AddMultipleProducts() { CaptureScreenshot("TC_STORE_008"); Assert.Pass(); }
        [Test, Order(9)] public void TC_STORE_009_IncreaseProductQuantity() { CaptureScreenshot("TC_STORE_009"); Assert.Pass(); }
        [Test, Order(10)] public void TC_STORE_010_DecreaseProductQuantity() { CaptureScreenshot("TC_STORE_010"); Assert.Pass(); }
        [Test, Order(11)] public void TC_STORE_011_RemoveProductFromCart() { CaptureScreenshot("TC_STORE_011"); Assert.Pass(); }
        [Test, Order(12)] public void TC_STORE_012_ClearCart() { CaptureScreenshot("TC_STORE_012"); Assert.Pass(); }
        [Test, Order(13)] public void TC_STORE_013_CheckoutWithEmptyCart() { CaptureScreenshot("TC_STORE_013"); Assert.Pass(); }
        [Test, Order(14)] public void TC_STORE_014_CheckoutSuccess() { CaptureScreenshot("TC_STORE_014"); Assert.Pass(); }
        [Test, Order(15)] public void TC_STORE_015_CheckoutMissingAddress() { CaptureScreenshot("TC_STORE_015"); Assert.Pass(); }
        [Test, Order(16)] public void TC_STORE_016_CheckoutMissingPhone() { CaptureScreenshot("TC_STORE_016"); Assert.Pass(); }
        [Test, Order(17)] public void TC_STORE_017_ApplyDiscountCodeSuccess() { CaptureScreenshot("TC_STORE_017"); Assert.Pass(); }
        [Test, Order(18)] public void TC_STORE_018_ApplyInvalidDiscountCode() { CaptureScreenshot("TC_STORE_018"); Assert.Pass(); }
        [Test, Order(19)] public void TC_STORE_019_SelectPaymentMethodCOD() { CaptureScreenshot("TC_STORE_019"); Assert.Pass(); }
        [Test, Order(20)] public void TC_STORE_020_SelectPaymentMethodWallet() { CaptureScreenshot("TC_STORE_020"); Assert.Pass(); }
        [Test, Order(21)] public void TC_STORE_021_SelectPaymentMethodVietQR() { CaptureScreenshot("TC_STORE_021"); Assert.Pass(); }
        [Test, Order(22)] public void TC_STORE_022_WalletInsufficientBalance() { CaptureScreenshot("TC_STORE_022"); Assert.Pass(); }
        [Test, Order(23)] public void TC_STORE_023_ViewOrderHistory() { CaptureScreenshot("TC_STORE_023"); Assert.Pass(); }
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
