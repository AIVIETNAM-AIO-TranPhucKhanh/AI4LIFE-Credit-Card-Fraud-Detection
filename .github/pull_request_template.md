## Mô tả
<!-- PR này làm gì? Giữ PR nhỏ, 1 task. -->

**Jira:** KAN-<!-- số -->  <!-- ghi mã Jira cả ở tên branch để Jira tự liên kết -->

**Module:** Data / Model / Pipeline / API / App / QA / Report
**Reviewer chuyên môn:** @

## Thay đổi contract? (schema, API, model bundle, feature)
- [ ] Không
- [ ] Có → đã tag người nhận bàn giao review và cập nhật `docs/`

## Đã kiểm tra thế nào?
<!-- Lệnh chạy, kết quả test. Với thực nghiệm: run ID + metric trên validation. -->

## Checklist
- [ ] `pytest` chạy xanh trên máy mình
- [ ] Không commit dữ liệu lớn, model weights, `.env`/API key
- [ ] Logic dùng lại nằm trong `src/`, không chỉ ở notebook
- [ ] (ML) Không dùng thông tin tương lai / nhãn chưa biết; preprocessing chỉ fit trên train
- [ ] (ML) Không chọn model/ngưỡng dựa trên test
