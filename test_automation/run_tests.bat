@echo off
echo ============================================
echo  Chay 100 Testcase Care4U (C# + NUnit)
echo ============================================
echo.
echo Kiem tra Appium dang chay tren cong 4723...
netstat -ano | findstr ":4723" | findstr "LISTENING" > nul
if errorlevel 1 (
    echo [LOI] Appium chua chay! Hay chay start_appium.bat truoc.
    pause
    exit /b 1
)
echo [OK] Appium dang chay.
echo.
echo Kiem tra emulator...
D:\Android\Sdk\platform-tools\adb.exe devices
echo.
echo Bat dau chay test...
cd /d d:\mobile\project\care4u_medical_booking\test_automation\Care4U.AppiumTests
dotnet test --logger "console;verbosity=detailed" 2>&1
echo.
echo ============================================
echo  Hoan thanh! Xem anh chup tai:
echo  bin\Debug\net8.0\Screenshots\
echo ============================================
pause
