$ErrorActionPreference = "Continue"

Write-Host "Running all test cases via Appium..."
dotnet test D:\mobile\project\care4u_medical_booking\test_automation\Care4U.AppiumTests\Care4U.AppiumTests.csproj --logger "trx;LogFileName=test_results.trx"

Write-Host "Generating Excel report..."
$TrxFile = "D:\mobile\project\care4u_medical_booking\test_automation\Care4U.AppiumTests\TestResults\test_results.trx"
$ExcelFile = "D:\mobile\project\care4u_medical_booking\test_automation\Care4U_TestCases.xlsx"

python D:\mobile\project\care4u_medical_booking\test_automation\export_excel.py $TrxFile $ExcelFile

Write-Host "Done! The results are saved to $ExcelFile"
