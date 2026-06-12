INSERT INTO medicines (name, generic_name, brand_name, drug_code, category, dosage_form, strength, manufacturer, description, usage_instructions, side_effects, contraindications, storage_conditions, price, unit, requires_rx, is_active, image_url, created_at, updated_at)
SELECT 'Paracetamol 500mg', 'Paracetamol', 'CarePara', 'MED-001', 'Pain relief', 'Tablet', '500mg', 'Care4U Pharma', 'Pain and fever medicine', 'Use as prescribed by doctor', NULL, NULL, 'Store in dry place', 1500, 'tablet', false, true, NULL, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM medicines WHERE drug_code = 'MED-001');

INSERT INTO medicines (name, generic_name, brand_name, drug_code, category, dosage_form, strength, manufacturer, description, usage_instructions, side_effects, contraindications, storage_conditions, price, unit, requires_rx, is_active, image_url, created_at, updated_at)
SELECT 'Amoxicillin 500mg', 'Amoxicillin', 'CareAmox', 'MED-002', 'Antibiotic', 'Capsule', '500mg', 'Care4U Pharma', 'Antibiotic medicine', 'Use as prescribed by doctor', NULL, NULL, 'Store in dry place', 2500, 'capsule', true, true, NULL, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM medicines WHERE drug_code = 'MED-002');

INSERT INTO medicines (name, generic_name, brand_name, drug_code, category, dosage_form, strength, manufacturer, description, usage_instructions, side_effects, contraindications, storage_conditions, price, unit, requires_rx, is_active, image_url, created_at, updated_at)
SELECT 'Vitamin C 500mg', 'Ascorbic Acid', 'CareVitC', 'MED-003', 'Vitamin', 'Tablet', '500mg', 'Care4U Pharma', 'Vitamin supplement', 'Use after meal', NULL, NULL, 'Store in dry place', 1200, 'tablet', false, true, NULL, NOW(), NOW()
WHERE NOT EXISTS (SELECT 1 FROM medicines WHERE drug_code = 'MED-003');
