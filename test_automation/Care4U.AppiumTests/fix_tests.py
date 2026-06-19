import re

auth_file = r'd:\mobile\project\care4u_medical_booking\test_automation\Care4U.AppiumTests\Tests\AuthTests.cs'

with open(auth_file, 'r', encoding='utf-8') as f:
    content = f.read()

# Replace LoginPatientSuccess
content = re.sub(
    r'(public void TC_AUTH_008_LoginPatientSuccess\(\)\s*\{[^{}]*ResetApp\(\);[^{}]*)CaptureScreenshot',
    r'\1AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, Config["TestData:PatientEmail"], Config["TestData:PatientPassword"], AdbPath, DeviceName);\n        CaptureScreenshot',
    content
)

# Replace LoginWrongPassword
content = re.sub(
    r'(public void TC_AUTH_009_LoginWrongPassword\(\)\s*\{[^{}]*ResetApp\(\);[^{}]*)CaptureScreenshot',
    r'\1AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, Config["TestData:PatientEmail"], "wrongpass", AdbPath, DeviceName);\n        CaptureScreenshot',
    content
)

# Replace LoginNonExistentEmail
content = re.sub(
    r'(public void TC_AUTH_010_LoginNonExistentEmail\(\)\s*\{[^{}]*ResetApp\(\);[^{}]*)CaptureScreenshot',
    r'\1AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, "nonexistent@gmail.com", "123456", AdbPath, DeviceName);\n        CaptureScreenshot',
    content
)

# Replace LoginEmptyForm
content = re.sub(
    r'(public void TC_AUTH_011_LoginEmptyForm\(\)\s*\{[^{}]*ResetApp\(\);[^{}]*)CaptureScreenshot',
    r'\1AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, "", "", AdbPath, DeviceName);\n        CaptureScreenshot',
    content
)

# Replace LoginMissingEmail
content = re.sub(
    r'(public void TC_AUTH_012_LoginMissingEmail\(\)\s*\{[^{}]*ResetApp\(\);[^{}]*)CaptureScreenshot',
    r'\1AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, "", "123456", AdbPath, DeviceName);\n        CaptureScreenshot',
    content
)

# Replace LoginMissingPassword
content = re.sub(
    r'(public void TC_AUTH_013_LoginMissingPassword\(\)\s*\{[^{}]*ResetApp\(\);[^{}]*)CaptureScreenshot',
    r'\1AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, Config["TestData:PatientEmail"], "", AdbPath, DeviceName);\n        CaptureScreenshot',
    content
)

# Replace LoginInvalidEmailFormat
content = re.sub(
    r'(public void TC_AUTH_014_LoginInvalidEmailFormat\(\)\s*\{[^{}]*ResetApp\(\);[^{}]*)CaptureScreenshot',
    r'\1AppHelpers.LoginPatient(Driver, DeviceWidth, DeviceHeight, "invalid-email-format", "123456", AdbPath, DeviceName);\n        CaptureScreenshot',
    content
)

with open(auth_file, 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated AuthTests.cs")
