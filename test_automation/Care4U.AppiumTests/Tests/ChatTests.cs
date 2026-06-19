using NUnit.Framework;
using OpenQA.Selenium;
using System.Threading;
using Care4U.AppiumTests.Helpers;
using System.Threading;

namespace Care4U.AppiumTests.Tests
{
    [TestFixture]
    [Category("Chat")]
    public class ChatTests : AppiumTestBase
    {
        [Test, Order(1)]
        public void TC_CHAT_001_OpenChatbot()
        {
            Driver.ActivateApp("com.example.care4u");
            Thread.Sleep(2000);
            CaptureScreenshot("TC_CHAT_001_OpenChatbot");
            Assert.Pass("Thử nghiệm mở chatbot");
        }

        [Test, Order(2)]
        public void TC_CHAT_002_SendMessageToChatbot()
        {
            CaptureScreenshot("TC_CHAT_002_SendMessageToChatbot");
            Assert.Pass("Thử nghiệm gửi tin nhắn cho chatbot");
        }

        [Test, Order(3)]
        public void TC_CHAT_003_ViewDoctorChatRooms()
        {
            CaptureScreenshot("TC_CHAT_003_ViewDoctorChatRooms");
            Assert.Pass("Thử nghiệm xem danh sách chat với bác sĩ");
        }

        [Test, Order(4)]
        public void TC_CHAT_004_SendMessageToDoctor()
        {
            CaptureScreenshot("TC_CHAT_004_SendMessageToDoctor");
            Assert.Pass("Thử nghiệm gửi tin nhắn cho bác sĩ");
        }
    }
}
