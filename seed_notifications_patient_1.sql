INSERT INTO notifications (id, user_id, title, body, type, ref_type, ref_id, is_read, read_at, created_at)
SELECT gen_random_uuid(), p.user_id, 'Đặt lịch thành công', 'Lịch khám của bạn đã được đặt thành công trên Care4U.', 'confirmed', 'appointment', NULL, false, NULL, NOW()
FROM patients p
WHERE p.id = 1;

INSERT INTO notifications (id, user_id, title, body, type, ref_type, ref_id, is_read, read_at, created_at)
SELECT gen_random_uuid(), p.user_id, 'Thanh toán đơn hàng', 'Đơn hàng của bạn đã được ghi nhận và đang xử lý.', 'order', 'order', NULL, false, NULL, NOW()
FROM patients p
WHERE p.id = 1;
