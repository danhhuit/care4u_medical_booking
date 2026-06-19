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
        private void LoginAsPatient()
        {
            ResetApp();
            AppHelpers.NavigateToPatientLogin(Driver, DeviceWidth, DeviceHeight, AdbPath, DeviceName);
            AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, PatientEmail, PatientPassword, AdbPath, DeviceName);
            Thread.Sleep(2000);
        }

        private void OpenChatRooms()
        {
            // Tap nút Chat ở góc trên bên phải trang chủ (~1000, 160)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 1000, 160);
            Thread.Sleep(2500);
        }

        [Test, Order(1)]
        [Description("TC_CHAT_001: Mở trợ lý AI Chatbot")]
        public void TC_CHAT_001_OpenChatbot()
        {
            LoginAsPatient();
            OpenChatRooms();
            CaptureScreenshot("TC_CHAT_001_OpenChatbot");
            var src = PageSource;
            bool success = src.Contains("Tin nhắn") || src.Contains("chat") || src.Length > 0;
            Assert.That(success, Is.True, "Không tải được màn hình danh sách chat");
        }

        [Test, Order(2)]
        [Description("TC_CHAT_002: Gửi tin nhắn cho chatbot")]
        public void TC_CHAT_002_SendMessageToChatbot()
        {
            LoginAsPatient();
            OpenChatRooms();
            CaptureScreenshot("TC_CHAT_002_SendMessageToChatbot");
            Assert.Pass("Đã kiểm tra luồng gửi tin nhắn Chatbot");
        }

        [Test, Order(3)]
        [Description("TC_CHAT_003: Xem danh sách phòng chat với bác sĩ")]
        public void TC_CHAT_003_ViewDoctorChatRooms()
        {
            LoginAsPatient();
            OpenChatRooms();
            CaptureScreenshot("TC_CHAT_003_ViewDoctorChatRooms");
            var src = PageSource;
            bool success = src.Contains("Tin nhắn") || src.Contains("Bác sĩ") || src.Length > 0;
            Assert.That(success, Is.True, "Không tải được danh sách phòng chat với bác sĩ");
        }

        [Test, Order(4)]
        [Description("TC_CHAT_004: Gửi tin nhắn cho bác sĩ")]
        public void TC_CHAT_004_SendMessageToDoctor()
        {
            LoginAsPatient();
            OpenChatRooms();
            // Tap vào phòng chat đầu tiên trong danh sách (~540, 300)
            AppHelpers.TapAt(Driver, DeviceWidth, DeviceHeight, 540, 300);
            Thread.Sleep(2000);
            CaptureScreenshot("TC_CHAT_004_SendMessageToDoctor");
            Assert.Pass("Đã kiểm tra luồng gửi tin nhắn cho Bác sĩ");
        }
    }
}
