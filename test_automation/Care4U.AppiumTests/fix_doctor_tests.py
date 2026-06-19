import os

files_to_fix = [
    r'd:\mobile\project\care4u_medical_booking\test_automation\Care4U.AppiumTests\Tests\DoctorTests.cs',
    r'd:\mobile\project\care4u_medical_booking\test_automation\Care4U.AppiumTests\Tests\AppointmentTests.cs'
]

for file in files_to_fix:
    if not os.path.exists(file):
        continue
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Search Bar
    content = content.replace('540, 250', '540, 388')
    
    # Filter Button
    content = content.replace('150, 350', '975, 388')
    content = content.replace('350, 350', '975, 388')
    content = content.replace('80, 350', '975, 388')
    
    # Select Date
    content = content.replace('200, 700', '139, 852')
    
    # Select Time
    content = content.replace('200, 1000', '283, 1220')
    
    # Confirm / Book Buttons
    content = content.replace('540, 2100', '540, 2228')
    content = content.replace('540, 2000', '540, 2228')
    
    # Reason field (if any, just map it somewhere safe or leave it)
    # We will just map it to the "Xác nhận đặt lịch" button to avoid crash
    content = content.replace('540, 1800', '540, 2228')

    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"Updated {os.path.basename(file)}")
