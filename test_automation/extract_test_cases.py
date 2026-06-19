import os
import re
import openpyxl

def extract_test_cases(tests_dir, output_excel):
    # Regex to match void TC_...
    pattern = re.compile(r'void\s+(TC_[A-Za-z0-9_]+)\s*\(')
    
    test_cases = []
    
    for root, dirs, files in os.walk(tests_dir):
        for file in files:
            if file.endswith('.cs'):
                file_path = os.path.join(root, file)
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    matches = pattern.findall(content)
                    for match in matches:
                        test_cases.append(match)
                        
    print(f"Extracted {len(test_cases)} test cases.")
    
    # Create Excel
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = "Test Cases"
    
    # Add Header
    ws.append(["Test Case ID", "Actual Result", "Status (PASS/FAIL)"])
    
    # Add Rows
    for tc in test_cases:
        ws.append([tc, "", ""])
        
    # Auto-adjust column widths
    for col in ws.columns:
        max_length = 0
        column = col[0].column_letter
        for cell in col:
            try:
                if len(str(cell.value)) > max_length:
                    max_length = len(cell.value)
            except:
                pass
        adjusted_width = (max_length + 2)
        ws.column_dimensions[column].width = adjusted_width
        
    wb.save(output_excel)
    print(f"Excel file saved to {output_excel}")

if __name__ == "__main__":
    tests_dir = r"d:\mobile\project\care4u_medical_booking\test_automation\Care4U.AppiumTests\Tests"
    output_excel = r"d:\mobile\project\care4u_medical_booking\test_automation\Care4U_TestCases.xlsx"
    extract_test_cases(tests_dir, output_excel)
