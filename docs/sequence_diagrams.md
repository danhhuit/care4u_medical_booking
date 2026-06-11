# Sơ đồ tuần tự (Sequence Diagram) - Đồ án Care4U

Tài liệu này chứa các sơ đồ tuần tự (Sequence Diagram) chi tiết cho 2 chức năng được giao:
1. **Xem Hồ sơ y tế & Kết quả khám** (Nguyễn Vương Hồng Vỹ)
2. **Thanh toán điện tử - Ví Care4U** (Nguyễn Thành Danh)

Để giải quyết vấn đề không mở được định dạng Mermaid, tài liệu này cung cấp **cả 2 định dạng mã: Mermaid và PlantUML**, kèm theo hướng dẫn sử dụng các trang web thay thế miễn phí, trực quan và không lỗi.

---

## CÁC TRANG WEB THAY THẾ ĐỂ VẼ/XUẤT SƠ ĐỒ (KHÔNG CẦN CÀI ĐẶT)

Nếu không sử dụng được Mermaid Live Editor, bạn hãy sử dụng các trang sau:
1. **SequenceDiagram.org** (Khuyên dùng - Cực kỳ mượt và dễ dùng):
   * URL: https://sequencediagram.org/
   * Cách dùng: Truy cập trang web, copy toàn bộ mã trong phần **Mã PlantUML** bên dưới và dán vào khung soạn thảo bên trái. Sơ đồ sẽ được tự động vẽ trực quan bên phải ngay lập tức. Bạn có thể nhấn **Export** trên thanh menu để tải ảnh PNG/SVG về máy.
2. **PlantUML Online Server**:
   * URL: http://www.plantuml.com/plantuml/
   * Cách dùng: Truy cập trang web, dán mã PlantUML vào ô văn bản và nhấn **Submit**. Trang web sẽ trả về file ảnh sơ đồ để bạn tải về.
3. **Draw.io (diagrams.net)**:
   * URL: https://app.diagrams.net/
   * Cách dùng: Tạo một file vẽ mới, chọn menu **Arrange** -> **Insert** -> **Advanced** -> **PlantUML...** (hoặc **Mermaid...**), dán đoạn mã tương ứng vào và nhấn **Insert**. Draw.io sẽ tự vẽ thành các đối tượng kéo thả để bạn chỉnh sửa tùy ý.

---

## 1. Sơ đồ tuần tự: Xem Hồ sơ y tế & Kết quả khám (Nguyễn Vương Hồng Vỹ)

### Mã PlantUML (Dán vào sequencediagram.org hoặc PlantUML Server):
```plantuml
@startuml
autonumber
skinparam BoxPadding 10
skinparam ParticipantPadding 10

actor "Bệnh nhân" as Patient
participant "Giao diện (HistoryScreen)" as UI
participant "Controller (MedicalRecordController)" as Ctrl
participant "Dio / SQLite Client" as Client
database "SQLite DB / Server" as DB

Patient -> UI : Chọn chức năng "Lịch sử khám"
activate UI
UI -> Ctrl : Gọi fetchMedicalHistory(patientId)
activate Ctrl
Ctrl -> Client : Gọi getMedicalRecords(patientId)
activate Client
Client -> DB : Truy vấn danh sách đợt khám
activate DB
DB --> Client : Trả về danh sách đợt khám (List<RecordModel>)
deactivate DB
Client --> Ctrl : Trả về danh sách đợt khám
deactivate Client
Ctrl -> Ctrl : Cập nhật state (notifyListeners)
UI --> Patient : Hiển thị danh sách các đợt khám
deactivate Ctrl
deactivate UI

Patient -> UI : Nhấn chọn một đợt khám cụ thể
activate UI
UI -> Ctrl : Gọi fetchRecordDetail(recordId)
activate Ctrl
Ctrl -> Client : Gọi getRecordDetail(recordId)
activate Client
Client -> DB : Truy vấn chi tiết bệnh án & đơn thuốc
activate DB
DB --> Client : Trả về chi tiết bản ghi (RecordDetailModel)
deactivate DB
Client --> Ctrl : Trả về chi tiết bản ghi
deactivate Client
Ctrl -> Ctrl : Cập nhật chi tiết trong state
UI --> Patient : Hiển thị kết luận, kết quả xét nghiệm & đơn thuốc
deactivate Ctrl
deactivate UI
@endum
```

### Mã Mermaid (Dự phòng):
```mermaid
sequenceDiagram
    autonumber
    actor Patient as Bệnh nhân
    participant UI as Giao diện (HistoryScreen / ProfileScreen)
    participant Ctrl as Controller (MedicalRecordController)
    participant Client as Database / API Client (Dio / SQLite)
    participant DB as SQLite DB / Server Backend

    Patient->>UI: Chọn chức năng "Lịch sử khám"
    activate UI
    UI->>Ctrl: Gọi fetchMedicalHistory(patientId)
    activate Ctrl
    Ctrl->>Client: Gọi getMedicalRecords(patientId)
    activate Client
    Client->>DB: Truy vấn danh sách đợt khám
    activate DB
    DB-->>Client: Trả về mảng dữ liệu đợt khám (List<RecordModel>)
    deactivate DB
    Client-->>Ctrl: Trả về danh sách đợt khám
    deactivate Client
    Ctrl->>Ctrl: Cập nhật state (notifyListeners)
    UI-->>Patient: Hiển thị danh sách các đợt khám
    deactivate Ctrl
    deactivate UI

    Patient->>UI: Nhấn chọn một đợt khám cụ thể
    activate UI
    UI->>Ctrl: Gọi fetchRecordDetail(recordId)
    activate Ctrl
    Ctrl->>Client: Gọi getRecordDetail(recordId)
    activate Client
    Client->>DB: Truy vấn chi tiết bệnh án, cận lâm sàng & đơn thuốc
    activate DB
    DB-->>Client: Trả về chi tiết bản ghi (RecordDetailModel)
    deactivate DB
    Client-->>Ctrl: Trả về chi tiết bản ghi
    deactivate Client
    Ctrl->>Ctrl: Cập nhật chi tiết trong state
    UI-->>Patient: Hiển thị kết luận, kết quả xét nghiệm & đơn thuốc
    deactivate Ctrl
    deactivate UI
```

---

## 2. Sơ đồ tuần tự: Thanh toán điện tử - Ví Care4U (Nguyễn Thành Danh)

### Mã PlantUML (Dán vào sequencediagram.org hoặc PlantUML Server):
```plantuml
@startuml
autonumber
skinparam BoxPadding 10
skinparam ParticipantPadding 10

actor "Bệnh nhân" as Patient
participant "Giao diện (PaymentUI)" as UI
participant "Controller (PaymentController)" as Ctrl
participant "Server Backend Care4U" as Server
participant "Cổng Momo API" as Partner
database "Database" as DB

Patient -> UI : Nhấn nút "Xác nhận thanh toán"
activate UI
UI -> Ctrl : Yêu cầu thanh toán (invoiceId)
activate Ctrl
Ctrl -> Server : Kiểm tra số dư ví (patientId)
activate Server
Server -> DB : Đọc thông tin ví
activate DB
DB --> Server : Trả về số dư (balance)
deactivate DB
Server --> Ctrl : Trả về số dư hiện tại
deactivate Server

alt Số dư ĐỦ (balance >= invoice.amount)
    Ctrl -> Server : debitWallet(invoiceId)
    activate Server
    Server -> DB : Trừ tiền ví, cập nhật hóa đơn & lưu giao dịch
    activate DB
    DB --> Server : Xác nhận thành công
    deactivate DB
    Server --> Ctrl : Trả về Biên lai (Receipt)
    deactivate Server
    Ctrl -> Ctrl : Cập nhật state
    UI --> Patient : Hiển thị Biên lai thanh toán thành công
else Số dư KHÔNG ĐỦ (Top-up & Pay)
    Ctrl --> UI : Trả về lỗi "Số dư không đủ"
    UI --> Patient : Hiển thị thông báo & mở màn hình nạp tiền
    Patient -> UI : Nhập số tiền nạp & chọn Momo -> Nhấn "Nạp tiền"
    UI -> Ctrl : Yêu cầu nạp tiền (amount, Momo)
    Ctrl -> Server : initiateTopup(amount, Momo)
    activate Server
    Server -> Partner : Gửi yêu cầu tạo giao dịch
    activate Partner
    Partner --> Server : Trả về paymentUrl
    deactivate Partner
    Server --> Ctrl : Trả về paymentUrl
    deactivate Server
    Ctrl -> UI : Điều hướng Webview mở paymentUrl
    Patient -> Partner : Xác thực giao dịch (OTP/Mật khẩu) trên Momo
    activate Partner
    Partner -> Server : Gọi Webhook thông báo nạp thành công
    activate Server
    Server -> DB : Cộng tiền ví & lưu lịch sử nạp
    activate DB
    DB --> Server : Xác nhận nạp thành công
    deactivate DB
    Server --> Partner : Phản hồi xác nhận
    deactivate Server
    Partner --> Patient : Hiển thị màn hình thành công
    deactivate Partner
    
    Ctrl -> Server : debitWallet(invoiceId)
    activate Server
    Server -> DB : Trừ tiền ví mới, cập nhật hóa đơn & lưu giao dịch
    activate DB
    DB --> Server : Xác nhận thành công
    deactivate DB
    Server --> Ctrl : Trả về Biên lai (Receipt)
    deactivate Server
    Ctrl -> Ctrl : Cập nhật state
    UI --> Patient : Hiển thị Biên lai thanh toán thành công
end
deactivate Ctrl
deactivate UI
@endum
```

### Mã Mermaid (Dự phòng):
```mermaid
sequenceDiagram
    autonumber
    actor Patient as Bệnh nhân
    participant UI as Giao diện (PaymentUI / TopupUI)
    participant Ctrl as Controller (PaymentController)
    participant Server as Server Backend Care4U
    participant Partner as Cổng thanh toán (Momo API)
    participant DB as Database

    Patient->>UI: Nhấn nút "Xác nhận thanh toán"
    activate UI
    UI->>Ctrl: Yêu cầu thanh toán hóa đơn (invoiceId)
    activate Ctrl
    Ctrl->>Server: Kiểm tra số dư ví (patientId)
    activate Server
    Server->>DB: Đọc thông tin ví
    activate DB
    DB-->>Server: Trả về thông tin số dư ví (balance)
    deactivate DB
    Server-->>Ctrl: Trả về số dư hiện tại
    deactivate Server

    alt Trường hợp 1: Số dư ĐỦ (balance >= invoice.amount)
        Ctrl->>Server: Gọi thực hiện giao dịch debitWallet(invoiceId)
        activate Server
        Server->>DB: Trừ tiền ví, cập nhật hóa đơn & lưu lịch sử giao dịch
        activate DB
        DB-->>Server: Xác nhận cập nhật thành công
        deactivate DB
        Server-->>Ctrl: Trả về kết quả giao dịch (Transaction Receipt)
        deactivate Server
        Ctrl->>Ctrl: Cập nhật trạng thái ví & hóa đơn trong state
        UI-->>Patient: Hiển thị Biên lai thanh toán thành công
        
    else Trường hợp 2: Số dư KHÔNG ĐỦ (balance < invoice.amount)
        Ctrl-->>UI: Trả về thông báo lỗi "Số dư không đủ"
        UI-->>Patient: Hiển thị thông báo & mở màn hình nạp tiền
        Patient->>UI: Nhập số tiền nạp & Chọn Momo -> Nhấn "Nạp tiền"
        UI->>Ctrl: Yêu cầu nạp tiền (amount, Momo)
        Ctrl->>Server: Gọi initiateTopup(amount, Momo)
        activate Server
        Server->>Partner: Gửi yêu cầu tạo giao dịch thanh toán
        activate Partner
        Partner-->>Server: Trả về thông tin thanh toán & paymentUrl
        deactivate Partner
        Server-->>Ctrl: Trả về link thanh toán (paymentUrl)
        deactivate Server
        Ctrl->>UI: Điều hướng Webview mở paymentUrl
        Patient->>Partner: Nhập OTP/Mật khẩu xác thực giao dịch trên Momo
        activate Partner
        Partner->>Server: Gọi Webhook/Callback thông báo nạp thành công
        activate Server
        Server->>DB: Cộng tiền ví & lưu lịch sử nạp tiền
        activate DB
        DB-->>Server: Xác nhận nạp thành công
        deactivate DB
        Server-->>Partner: Phản hồi xác nhận webhook
        deactivate Server
        Partner-->>Patient: Hiển thị màn hình thành công & quay lại Care4U
        deactivate Partner
        
        %% Tiếp tục thanh toán sau khi nạp thành công
        Ctrl->>Server: Kiểm tra lại giao dịch và thực hiện debitWallet(invoiceId)
        activate Server
        Server->>DB: Trừ tiền ví mới, cập nhật hóa đơn & lưu giao dịch
        activate DB
        DB-->>Server: Xác nhận cập nhật thành công
        deactivate DB
        Server-->>Ctrl: Trả về kết quả giao dịch (Transaction Receipt)
        deactivate Server
        Ctrl->>Ctrl: Cập nhật trạng thái ví & hóa đơn trong state
        UI-->>Patient: Hiển thị Biên lai thanh toán thành công
    end
    deactivate Ctrl
    deactivate UI
```
