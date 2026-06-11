# Sơ đồ tuần tự (Sequence Diagram) - Đồ án Care4U

Tài liệu này chứa các sơ đồ tuần tự (Sequence Diagram) chi tiết cho 2 chức năng được giao:
1. **Xem Hồ sơ y tế & Kết quả khám** (Nguyễn Vương Hồng Vỹ)
2. **Thanh toán điện tử - Ví Care4U** (Nguyễn Thành Danh)

Các sơ đồ được vẽ bằng mã **Mermaid** để bạn có thể dễ dàng sao chép trực tiếp vào báo cáo, hoặc xuất ra file ảnh (PNG/SVG) thông qua các công cụ trực quan (như Draw.io, Mermaid Live Editor, hoặc Markdown Viewer).

---

## 1. Sơ đồ tuần tự: Xem Hồ sơ y tế & Kết quả khám (Nguyễn Vương Hồng Vỹ)

### Mô tả luồng hoạt động:
1. **Bệnh nhân** mở màn hình *Lịch sử khám bệnh* (History Screen) trên ứng dụng di động.
2. Giao diện (UI) yêu cầu **Controller** tải danh sách lịch sử khám bệnh của người dùng.
3. **Controller** gọi phương thức từ lớp **Client (Dio / Database)** để truy xuất dữ liệu.
4. **Client** gửi truy vấn đến cơ sở dữ liệu nội bộ **SQLite (sqflite)** hoặc gọi API của **Server Backend** nếu có kết nối mạng.
5. **SQLite/Server** trả về danh sách các đợt khám (mã đợt khám, ngày khám, tên bác sĩ, chẩn đoán sơ bộ).
6. **Controller** cập nhật trạng thái giao diện (State Management).
7. **UI** hiển thị danh sách đợt khám trực quan cho bệnh nhân.
8. **Bệnh nhân** nhấn chọn vào một đợt khám cụ thể để xem chi tiết.
9. **UI** yêu cầu **Controller** lấy thông tin chi tiết đợt khám y tế được chọn.
10. **Controller** thông qua **Client** truy vấn thông tin chi tiết (kết luận chẩn đoán, các chỉ số sinh hiệu, kết quả cận lâm sàng như xét nghiệm máu/siêu âm, và toa thuốc).
11. **SQLite/Server** trả về toàn bộ dữ liệu chi tiết của bệnh án điện tử.
12. **Controller** cập nhật trạng thái UI.
13. **UI** hiển thị đầy đủ thông tin chẩn đoán, chỉ số xét nghiệm và đơn thuốc cho bệnh nhân.

### Sơ đồ Mermaid:

```mermaid
sequenceDiagram
    autonumber
    actor Patient as Bệnh nhân
    participant UI as Giao diện (HistoryScreen / ProfileScreen)
    participant Ctrl as Controller (MedicalRecordController)
    participant Client as Database / API Client (Dio / SQLite)
    participant DB as SQLite DB / Server Backend

    %% Luồng 1: Tải danh sách lịch sử khám
    Patient->>UI: 1. Chọn chức năng "Lịch sử khám"
    activate UI
    UI->>Ctrl: 2. Gọi fetchMedicalHistory(patientId)
    activate Ctrl
    Ctrl->>Client: 3. Gọi getMedicalRecords(patientId)
    activate Client
    Client->>DB: 4. Truy vấn danh sách đợt khám
    activate DB
    DB-->>Client: 5. Trả về mảng dữ liệu đợt khám (List<RecordModel>)
    deactivate DB
    Client-->>Ctrl: 6. Trả về danh sách đợt khám
    deactivate Client
    Ctrl->>Ctrl: 7. Cập nhật state (notifyListeners)
    UI-->>Patient: 8. Hiển thị danh sách các đợt khám
    deactivate Ctrl
    deactivate UI

    %% Luồng 2: Xem chi tiết một đợt khám
    Patient->>UI: 9. Nhấn chọn một đợt khám cụ thể
    activate UI
    UI->>Ctrl: 10. Gọi fetchRecordDetail(recordId)
    activate Ctrl
    Ctrl->>Client: 11. Gọi getRecordDetail(recordId)
    activate Client
    Client->>DB: 12. Truy vấn chi tiết bệnh án, cận lâm sàng & đơn thuốc
    activate DB
    DB-->>Client: 13. Trả về chi tiết bản ghi (RecordDetailModel)
    deactivate DB
    Client-->>Ctrl: 14. Trả về chi tiết bản ghi
    deactivate Client
    Ctrl->>Ctrl: 15. Cập nhật chi tiết trong state
    UI-->>Patient: 16. Hiển thị kết luận, kết quả xét nghiệm & đơn thuốc
    deactivate Ctrl
    deactivate UI
```

---

## 2. Sơ đồ tuần tự: Thanh toán điện tử - Ví Care4U (Nguyễn Thành Danh)

### Mô tả luồng hoạt động:
Sơ đồ mô tả luồng thanh toán hóa đơn (phí đặt lịch hoặc mua đơn thuốc) bằng **Ví điện tử Care4U**. Hệ thống hỗ trợ tự động kích hoạt luồng **Nạp tiền (Top-up)** nếu số dư ví của bệnh nhân không đủ để giao dịch.

1. **Bệnh nhân** nhấn "Xác nhận và Thanh toán" trên màn hình thanh toán dịch vụ.
2. **UI** yêu cầu **Payment Controller** xử lý thanh toán hóa đơn.
3. **Controller** gọi API của hệ thống để kiểm tra số dư ví Care4U hiện tại của bệnh nhân.
4. **Server Backend** truy xuất cơ sở dữ liệu và trả về số dư ví.
5. **Rẽ nhánh điều kiện**:
   - **Trường hợp A: Số dư ĐỦ để thanh toán**:
     1. **Controller** gửi yêu cầu thực hiện giao dịch trừ tiền (`debitWallet`).
     2. **Server Backend** cập nhật trừ tiền ví, lưu lịch sử giao dịch và đánh dấu hóa đơn đã thanh toán thành công trong database.
     3. **Server** trả về biên lai giao dịch thành công.
     4. **Controller** cập nhật state và **UI** hiển thị thông báo thanh toán thành công kèm biên lai cho bệnh nhân.
   - **Trường hợp B: Số dư KHÔNG ĐỦ (Tự động kích hoạt luồng Nạp tiền)**:
     1. **Controller** phát hiện thiếu hụt số dư, thông báo lỗi và yêu cầu nạp tiền.
     2. **UI** hiển thị hộp thoại thông báo và điều hướng bệnh nhân sang màn hình nạp tiền.
     3. **Bệnh nhân** nhập số tiền nạp, chọn phương thức nạp (ví dụ: MoMo) và nhấn xác nhận.
     4. **Controller** gọi API Backend khởi tạo nạp tiền.
     5. **Server Backend** liên kết với cổng thanh toán đối tác (Momo API) để tạo yêu cầu nạp tiền và nhận về liên kết thanh toán (Momo Payment URL).
     6. **UI** mở trình duyệt/webview dẫn người dùng đến Cổng thanh toán Momo.
     7. **Bệnh nhân** xác thực và hoàn tất nạp tiền trên hệ thống Momo.
     8. **Cổng thanh toán Momo** cập nhật trạng thái và gọi webhook thông báo cho **Server Backend** của Care4U.
     9. **Server Backend** xác nhận nạp tiền, cộng số dư ví trong CSDL và trả kết quả thành công về cho ứng dụng.
     10. **Controller** cập nhật lại số dư ví mới trên ứng dụng và tiếp tục thực hiện lại luồng thanh toán hóa đơn ban đầu.

### Sơ đồ Mermaid:

```mermaid
sequenceDiagram
    autonumber
    actor Patient as Bệnh nhân
    participant UI as Giao diện (PaymentUI / TopupUI)
    participant Ctrl as Controller (PaymentController)
    participant Server as Server Backend Care4U
    participant Partner as Cổng thanh toán (Momo API)
    participant DB as Database

    Patient->>UI: 1. Nhấn nút "Xác nhận thanh toán"
    activate UI
    UI->>Ctrl: 2. Yêu cầu thanh toán hóa đơn (invoiceId)
    activate Ctrl
    Ctrl->>Server: 3. Kiểm tra số dư ví (patientId)
    activate Server
    Server->>DB: 4. Đọc thông tin ví
    activate DB
    DB-->>Server: 5. Trả về thông tin số dư ví (balance)
    deactivate DB
    Server-->>Ctrl: 6. Trả về số dư hiện tại
    deactivate Server

    alt Trường hợp 1: Số dư ĐỦ (balance >= invoice.amount)
        Ctrl->>Server: 7. Gọi thực hiện giao dịch debitWallet(invoiceId)
        activate Server
        Server->>DB: 8. Trừ tiền ví, cập nhật hóa đơn & lưu lịch sử giao dịch
        activate DB
        DB-->>Server: 9. Xác nhận cập nhật thành công
        deactivate DB
        Server-->>Ctrl: 10. Trả về kết quả giao dịch (Transaction Receipt)
        deactivate Server
        Ctrl->>Ctrl: 11. Cập nhật trạng thái ví & hóa đơn trong state
        UI-->>Patient: 12. Hiển thị Biên lai thanh toán thành công
        
    else Trường hợp 2: Số dư KHÔNG ĐỦ (balance < invoice.amount)
        Ctrl-->>UI: 7. Trả về thông báo lỗi "Số dư không đủ"
        UI-->>Patient: 8. Hiển thị thông báo & mở màn hình nạp tiền
        Patient->>UI: 9. Nhập số tiền nạp & Chọn Momo -> Nhấn "Nạp tiền"
        UI->>Ctrl: 10. Yêu cầu nạp tiền (amount, Momo)
        Ctrl->>Server: 11. Gọi initiateTopup(amount, Momo)
        activate Server
        Server->>Partner: 12. Gửi yêu cầu tạo giao dịch thanh toán
        activate Partner
        Partner-->>Server: 13. Trả về thông tin thanh toán & paymentUrl
        deactivate Partner
        Server-->>Ctrl: 14. Trả về link thanh toán (paymentUrl)
        deactivate Server
        Ctrl->>UI: 15. Điều hướng Webview mở paymentUrl
        Patient->>Partner: 16. Nhập OTP/Mật khẩu xác thực giao dịch trên Momo
        activate Partner
        Partner->>Server: 17. Gọi Webhook/Callback thông báo nạp thành công
        activate Server
        Server->>DB: 18. Cộng tiền ví & lưu lịch sử nạp tiền
        activate DB
        DB-->>Server: 19. Xác nhận nạp thành công
        deactivate DB
        Server-->>Partner: 20. Phản hồi xác nhận webhook
        deactivate Server
        Partner-->>Patient: 21. Hiển thị màn hình thành công & quay lại Care4U
        deactivate Partner
        
        %% Tiếp tục thanh toán sau khi nạp thành công
        Ctrl->>Server: 22. Kiểm tra lại giao dịch và thực hiện debitWallet(invoiceId)
        activate Server
        Server->>DB: 23. Trừ tiền ví mới, cập nhật hóa đơn & lưu giao dịch
        activate DB
        DB-->>Server: 24. Xác nhận cập nhật thành công
        deactivate DB
        Server-->>Ctrl: 25. Trả về kết quả giao dịch (Transaction Receipt)
        deactivate Server
        Ctrl->>Ctrl: 26. Cập nhật trạng thái ví & hóa đơn trong state
        UI-->>Patient: 27. Hiển thị Biên lai thanh toán thành công
    end
    deactivate Ctrl
    deactivate UI
```

---

## Hướng dẫn sao chép và xuất ảnh sơ đồ:
1. **Sao chép mã**: Chọn phần mã nằm giữa cặp dấu \`\`\`mermaid ở trên.
2. **Vẽ online trực quan**: Truy cập [Mermaid Live Editor](https://mermaid.live/), dán đoạn mã vào ô bên trái. Sơ đồ sẽ hiển thị ngay lập tức ở khung bên phải.
3. **Xuất file**: Bạn có thể xuất dưới dạng file ảnh PNG hoặc SVG trực tiếp từ Mermaid Live Editor để chèn vào tài liệu báo cáo của nhóm.
