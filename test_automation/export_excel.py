import xml.etree.ElementTree as ET
import openpyxl
import sys
import os

def export_trx_to_excel(trx_path, excel_path):
    if not os.path.exists(trx_path):
        print(f"File not found: {trx_path}")
        return

    tree = ET.parse(trx_path)
    root = tree.getroot()
    ns = {'ns': 'http://microsoft.com/schemas/VisualStudio/TeamTest/2010'}

    wb = openpyxl.Workbook()
    ws = wb.active
    ws.title = "Test Results"
    ws.append(["Test Case ID", "Actual Result", "Status"])

    for result in root.findall('.//ns:UnitTestResult', ns):
        test_name = result.get('testName')
        outcome = result.get('outcome')
        
        actual_result = ""
        if outcome == "Passed":
            actual_result = "Executed successfully"
        else:
            # Try to extract error message
            message_node = result.find('.//ns:Output/ns:ErrorInfo/ns:Message', ns)
            if message_node is not None and message_node.text:
                actual_result = message_node.text.strip()
            else:
                actual_result = "Test failed or no specific error message."
                
        ws.append([test_name, actual_result, outcome])

    wb.save(excel_path)
    print(f"Exported to {excel_path}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python export_excel.py <trx_file> <excel_file>")
        sys.exit(1)
    
    export_trx_to_excel(sys.argv[1], sys.argv[2])
