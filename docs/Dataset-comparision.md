# Đề xuất Dataset project Credit Card Fraud Detection

Tóm tắt: dùng Sparkov làm bộ dataset để train model đầu. Sau đó dùng IEEE-CIS làm bộ dataset để test và finetune trên giao dịch thực tế.

## Tám bộ Dataset để so sánh

| Dataset và nguồn | Độ thực tiễn của dữ liệu | Số giao dịch | Cột | Phần trăm gian lận | Đặc trưng và hạn chế |
| --- | --- | ---: | ---: | ---: | --- |
| [Sparkov](https://www.kaggle.com/datasets/kartik2112/fraud-detection)<br>Kartik Shenoy · 2020 | Mô phỏng | 1.852.394 | 23 | 0,521% | Mã thẻ, thời gian, điểm bán và tọa độ. Dữ liệu được mô phỏng. |
| [IEEE-CIS](https://www.kaggle.com/competitions/ieee-fraud-detection/data)<br>Vesta / IEEE-CIS · 2019 | Thực tế | 590.540 train<br>506.691 test | 394/434 | 3,499% | Thiết bị, email, nhóm mã thẻ, thời gian tương đối. Nhiều trường ẩn danh, bảng định danh thưa. |
| [ULB–Worldline](https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud)<br>ULB / Kaggle · 2018 | Thực tế | 284.807 | 31 | 0,173% | 28 biến PCA, số tiền, thời gian tương đối. Chỉ hai ngày và thiếu mã nối lịch sử thẻ. |
| [CardHistory-Fraud](https://huggingface.co/datasets/toloka/CardHistory-Fraud)<br>Toloka · 2026 | Mô phỏng | 24.937.300 | 19 | 0,424% | Lịch sử thẻ, kênh, điểm bán và kịch bản. Dùng chung dữ liệu nền với TabFormer. |
| [Kaggle Playground S6E11](https://www.kaggle.com/competitions/playground-series-s6e11/data)<br>Kaggle · 2026 | Tổng hợp | 699.960 train<br>299.984 test | 26/25 | ≈1,67% | Thiết bị, kênh và xác thực. Thiếu khóa nối lịch sử và dấu thời gian đầy đủ. |
| [Financial Transactions](https://www.kaggle.com/datasets/computingvictor/transactions-fraud-datasets)<br>ComputingVictor · 2024 | Mô phỏng | 13.305.915<br>8.914.963 có nhãn | 12/13 | 0,1495% | Nối giao dịch với thẻ, khách hàng và MCC. 67% giao dịch có nhãn. |
| [IBM TabFormer](https://github.com/IBM/TabFormer/tree/main/data/credit_card)<br>IBM Research · 2021 | Mô phỏng | 24.386.900 | 15 | 0,122% | Lịch sử theo thẻ, thời gian, kênh và mã lỗi. Gian lận mô phỏng có lệch địa lý. |
| [Fraud Detection Handbook](https://github.com/Fraud-Detection-Handbook/simulated-data-raw)<br>Le Borgne và cs. · 2021 | Mô phỏng | 1.754.155 | 9 | 0,837% | Mã khách, mã thiết bị đầu cuối, thời gian và ba kịch bản. Thiếu kênh và MCC. |

Số cột gồm ID và nhãn nếu có. IEEE-CIS: 394 / 434 là trước / sau nối định danh. S6E11: 26 / 25 là train / test. Financial Transactions: 12 / 13 là trước / sau gắn nhãn.

Ghi chú: PCA là phương pháp tạo biến số mới bằng cách kết hợp các biến gốc, dùng để giảm số chiều dữ liệu trong khi giữ lại phần lớn độ biến thiên.

MCC là mã 4 chữ số chỉ ngành nghề của điểm bán. Ví dụ, 5411 là siêu thị hoặc cửa hàng tạp hóa, còn 5812 là nhà hàng. Dù viết bằng số, MCC là biến phân loại.

## Đặc trưng và cách dùng dữ liệu

Dựng 20 đặc trưng từ 25000 dòng đầu tiên của tệp Sparkov fraudTrain.csv. Mã hóa one-hot cho 14 danh mục trong mẫu tạo 33 cột đầu vào.

Trong 20 đặc trưng của Sparkov, có **1 cột danh mục giao dịch**. Cột này chứa các giá trị như siêu thị, xăng xe hoặc du lịch.

One-hot biến mỗi danh mục thành một cột riêng. Với mỗi giao dịch, cột tương ứng nhận 1, các cột khác nhận 0. Ví dụ bên dưới để hiểu rõ:

| Danh mục giao dịch | Siêu thị | Xăng xe | Du lịch |
| --- | ---: | ---: | ---: |
| Siêu thị | 1 | 0 | 0 |
| Xăng xe | 0 | 1 | 0 |
| Du lịch | 0 | 0 | 1 |

Trong ví dụ, 1 cột biến thành 3 cột. Mẫu Sparkov có **14 danh mục**, nên **1 cột biến thành 14 cột**.

Vì vậy, mỗi giao dịch có **19 cột đặc trưng khác + 14 cột danh mục = 33 cột đầu vào**.

| Nhóm đặc trưng | Số biến | Biến đầu vào |
| --- | ---: | --- |
| **Số tiền và thời điểm** | 3 | Số tiền, giờ trong ngày, thứ trong tuần. |
| **Bối cảnh điểm bán** | 2 | Danh mục và khoảng cách từ địa chỉ chủ thẻ đến điểm bán. |
| **Tần suất và tổng chi** | 6 | Số giao dịch và tổng tiền trong từng cửa sổ 1 giờ, 24 giờ và 7 ngày. |
| **Lệch khỏi thói quen** | 4 | Trung bình và độ lệch chuẩn số tiền 7 ngày, tỷ số so với trung bình, thời gian từ giao dịch trước. |
| **Mức độ quen thuộc với điểm bán** | 5 | Số điểm bán khác nhau trong 24 giờ và 7 ngày, điểm bán mới, số giao dịch cùng điểm bán và cùng danh mục trong 7 ngày. |
| **Tổng** | **20** | Số biến nghiệp vụ trước khi mã hóa danh mục. |

### Kết quả từ hai nghiên cứu

**FinFraudBench** Đồ thị CreditCard-Fraud dựng từ Sparkov. Tệp đồ thị xử lý sẵn đang được giữ lại trong thời gian phản biện. [Bài nghiên cứu](https://arxiv.org/html/2608.15177v1)

**Bài về trọng số theo số tiền** Thử trên Sparkov và IEEE-CIS. Kết quả trên Sparkov ủng hộ dùng biến tần suất và tỷ số số tiền so với lịch sử chi tiêu. [Bản arXiv v2](https://arxiv.org/html/2607.14686v2)

### Dữ liệu tại Việt Nam

Chưa có bộ dataset nào từ ngân hàng Việt Nam có giao dịch thẻ cấp dòng, nhãn gian lận đã xác nhận, tài liệu làm sạch và quyền sử dụng rõ ràng

### Kết luận và đề xuất bộ dữ liệu

**Sparkov:** Huấn luyện phiên bản đầu với 20 đặc trưng. Giữ tệp kiểm tra theo thời gian của bộ gốc.

**IEEE-CIS:** Nối hai bảng train theo TransactionID, chia phần có nhãn theo thời gian rồi huấn luyện và đánh giá riêng.

**Chỉ số đánh giá** Đo Average Precision, Recall@K và Fraud Amount Recall@K. Chỉ số cuối lấy giá trị giao dịch gian lận trong K cảnh báo chia cho tổng giá trị giao dịch gian lận trên tập kiểm tra.

