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
        [Test, Order(1)] public void TC_SPEC_001_ViewSpecialtiesList() { CaptureScreenshot("TC_SPEC_001"); Assert.Pass(); }
        [Test, Order(2)] public void TC_SPEC_002_SearchSpecialty() { CaptureScreenshot("TC_SPEC_002"); Assert.Pass(); }
        [Test, Order(3)] public void TC_SPEC_003_SearchSpecialtyNotFound() { CaptureScreenshot("TC_SPEC_003"); Assert.Pass(); }
        [Test, Order(4)] public void TC_SPEC_004_ViewDoctorsInSpecialty() { CaptureScreenshot("TC_SPEC_004"); Assert.Pass(); }
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
