# KAN-34 - So sánh các cách chấm điểm mô hình khi gian lận rất hiếm

## Tóm tắt

- **Không dùng độ chính xác (Accuracy).** Khi gian lận chỉ chiếm khoảng 0,2–3,5% giao dịch, một mô hình "không bao giờ báo gian lận" vẫn đạt trên 96% độ chính xác.
- **Tập trung vào 4 chỉ số:** AP (Average Precision), Recall@K, Precision@K và Fraud Amount Recall@K.
- **Theo dõi thêm:** ROC AUC (để so với kết quả bên ngoài), tỷ lệ báo nhầm (FPR) và số cảnh báo tại ngưỡng đã chọn, Precision / Recall / F1 tại ngưỡng đó.
- **Có thể bỏ qua:** Accuracy, Specificity, Balanced Accuracy.

---

## 1. Bốn ô cơ bản

Mỗi giao dịch, sau khi mô hình chấm điểm và so với một **ngưỡng** (ví dụ điểm ≥ 0,5 thì báo gian lận), rơi vào một trong bốn ô:

| | Mô hình báo **gian lận** | Mô hình báo **bình thường** |
|---|---|---|
| **Thực tế gian lận** | TP – bắt đúng | FN – bỏ sót |
| **Thực tế bình thường** | FP – báo nhầm | TN – bỏ qua đúng |

Hầu hết các chỉ số bên dưới chỉ là cách chia khác nhau giữa bốn ô này.

---

## 2. Ví dụ minh họa

Giả sử tập kiểm tra có **100.000 giao dịch, trong đó 200 vụ gian lận (0,2%)**. Nhân viên chỉ kịp kiểm tra **1.000 cảnh báo** (1% số giao dịch).

| | Mô hình A: "luôn báo bình thường" | Mô hình B: báo 1.000 giao dịch đáng ngờ nhất, bắt được 150 vụ |
|---|---:|---:|
| TP / FN | 0 / 200 | 150 / 50 |
| FP / TN | 0 / 99.800 | 850 / 98.950 |
| **Accuracy** | **99,80%** | 99,10% |
| Precision | – (không cảnh báo nào) | 15,0% |
| **Recall** | **0%** | **75,0%** |
| F1 | 0 | 0,25 |
| FPR (tỷ lệ báo nhầm) | 0% | 0,85% |

Mô hình A **vô dụng** (không bắt được vụ nào) nhưng có Accuracy **cao hơn** mô hình B. Đây là lý do Accuracy bị loại.

---

## 3. So sánh từng chỉ số

### 3.1. Nhóm chỉ số dùng ngưỡng cố định

| Chỉ số | Công thức | Ý nghĩa dễ hiểu | Khi gian lận rất hiếm |
|---|---|---|---|
| **Accuracy** (độ chính xác) | (TP + TN) / tổng | Tỷ lệ giao dịch đoán đúng | **Vô nghĩa**: bị lấn át bởi hàng trăm nghìn giao dịch bình thường (ví dụ ở mục 2) |
| **Precision** (độ tin cậy cảnh báo) | TP / (TP + FP) | Trong các cảnh báo, bao nhiêu % là gian lận thật | **Quan trọng**: phản ánh nhân viên phải xem bao nhiêu báo nhầm. Phụ thuộc ngưỡng |
| **Recall** (độ bao phủ) | TP / (TP + FN) | Bắt được bao nhiêu % vụ gian lận | **Quan trọng**: mục tiêu chính của bài toán. Phụ thuộc ngưỡng |
| **F1** | 2 × Precision × Recall / (Precision + Recall) | Trung bình hài hòa của Precision và Recall | Dùng được để đọc nhanh tại một ngưỡng, nhưng coi Precision và Recall quan trọng như nhau, trong khi thực tế thường không như vậy |
| **FPR** (tỷ lệ báo nhầm) | FP / (FP + TN) | Bao nhiêu % giao dịch bình thường bị báo nhầm | **Trông rất nhỏ** vì mẫu số khổng lồ (0,85% trong ví dụ, nghĩa là 850 cảnh báo sai). Nên đọc kèm **số cảnh báo sai tuyệt đối** |
| **Specificity** | TN / (TN + FP) = 1 − FPR | Bao nhiêu % giao dịch bình thường được bỏ qua đúng | Luôn gần 100%, không giúp phân biệt mô hình |
| **Balanced Accuracy** | (Recall + Specificity) / 2 | Trung bình độ đúng của hai lớp | Specificity gần 100% nên chỉ số này gần như bằng (Recall + 1) / 2, không cho thêm thông tin so với Recall |

### 3.2. Nhóm chỉ số không cần chọn ngưỡng (đánh giá cả bảng xếp hạng)

Mô hình cho mỗi giao dịch một điểm. Hai chỉ số dưới đây xét **toàn bộ thứ tự xếp hạng**, không phụ thuộc một ngưỡng cụ thể.

| Chỉ số | Ý nghĩa dễ hiểu | Mốc "đoán bừa" | Khi gian lận rất hiếm |
|---|---|---|---|
| **ROC AUC** | Lấy ngẫu nhiên 1 giao dịch gian lận và 1 giao dịch bình thường: xác suất mô hình chấm giao dịch gian lận cao hơn | 0,5 | **Thường cao giả**: hàng trăm nghìn giao dịch bình thường dễ phân biệt kéo điểm lên. Hai mô hình có ROC AUC 0,95 và 0,96 có thể khác nhau rất nhiều về số báo nhầm ở đầu danh sách |
| **AP** (Average Precision, gần bằng diện tích dưới đường Precision–Recall) | Đi dọc danh sách từ điểm cao xuống thấp; mỗi lần gặp một vụ gian lận, ghi lại Precision tại đó, rồi lấy trung bình | **Bằng tỷ lệ gian lận** của tập đánh giá (ví dụ 0,002 với tập 0,2%) | **Phù hợp nhất**: phạt nặng các báo nhầm nằm ở đầu danh sách, đúng chỗ nhân viên xem trước |

**Mốc "đoán bừa" của AP trên từng dataset** (bằng tỷ lệ gian lận, tính trên toàn bộ dữ liệu có nhãn):

| Dataset | Tỷ lệ gian lận = AP khi đoán bừa |
|---|---:|
| ULB | 0,00173 |
| CardHistory-Fraud | 0,00424 |
| Sparkov | 0,00521 |
| Kaggle S6E11 | 0,01670 |
| IEEE-CIS (tập train) | 0,03499 |

Vì mốc này khác nhau giữa các dataset, **không so AP giữa hai dataset khác nhau**; chỉ so AP giữa các mô hình trên **cùng một tập đánh giá**, và luôn báo kèm tỷ lệ gian lận của tập đó.

### 3.3. Nhóm chỉ số theo ngân sách cảnh báo K

Thực tế, ngân hàng không chọn ngưỡng "0,5" mà chọn **số cảnh báo nhân viên xử lý được** (ngân sách cảnh báo K). Mô hình xếp hạng mọi giao dịch, K giao dịch có điểm cao nhất được đưa đi kiểm tra.

| Chỉ số | Công thức | Ý nghĩa |
|---|---|---|
| **Recall@K** | Số vụ gian lận trong top K / tổng số vụ gian lận | Với sức người có hạn, bắt được bao nhiêu % vụ gian lận |
| **Precision@K** | Số vụ gian lận trong top K / K | Trong K cảnh báo, bao nhiêu % là thật (mức "đáng công" kiểm tra) |
| **Fraud Amount Recall@K** | Tổng tiền của các vụ gian lận trong top K / tổng tiền gian lận | Chặn được bao nhiêu % số tiền bị gian lận; ưu tiên mô hình bắt được vụ lớn |

Trong ví dụ ở mục 2 (K = 1.000): Recall@K = 75%, Precision@K = 15%.

**Quy tắc khi dùng K:**
- Chốt K **trước** khi so sánh và dùng **cùng một K** cho mọi mô hình trên cùng tập đánh giá.
- Đề xuất: **K = 1% số giao dịch của tập đánh giá**, báo thêm K = 0,5% để xem kết quả có ổn định không. Với tập đánh giá chia theo ngày, có thể quy đổi thành "K giao dịch mỗi ngày".
- Ghi rõ cách xử lý khi nhiều giao dịch bằng điểm nhau ở vị trí thứ K (ví dụ giữ nguyên thứ tự thời gian).
- Fraud Amount Recall@K chỉ có ý nghĩa khi dataset có số tiền (cả 5 dataset của nhóm đều có: `amt`, `TransactionAmt`, `Amount`, `amount_usd`, `amount`).

### 3.4. Nhóm chỉ số về độ tin cậy của xác suất (chỉ khi cần)

| Chỉ số | Ý nghĩa | Khi nào cần |
|---|---|---|
| **Brier score** / **Log loss** | Điểm của mô hình có đúng là xác suất không (điểm 0,8 thì khoảng 80% là gian lận thật) | Chỉ khi dashboard hiển thị "xác suất gian lận" cho người dùng hoặc dùng xác suất để tính chi phí. Không dùng để chọn mô hình phát hiện tốt nhất |

Lưu ý: dùng class weight hoặc lấy mẫu lại (SMOTE, undersampling) làm điểm của mô hình **không còn là xác suất thật**, dù khả năng xếp hạng vẫn tốt.

---

## 4. Phân loại: tập trung, lưu ý hay bỏ qua

### Tập trung (chỉ số chính để chọn mô hình)

| Chỉ số | Lý do |
|---|---|
| **AP** | Đánh giá cả bảng xếp hạng, nhạy với báo nhầm ở đầu danh sách, không cần chọn ngưỡng. Dùng làm **chỉ số chính** để so mô hình trên validation |
| **Recall@K** | Trả lời câu hỏi vận hành: với sức người có hạn, bắt được bao nhiêu vụ |
| **Precision@K** | Cho biết mỗi cảnh báo có đáng công kiểm tra không |
| **Fraud Amount Recall@K** | Đo thiệt hại tài chính được ngăn chặn, không chỉ số vụ |

### Lưu ý (báo cáo kèm, không dùng để chọn mô hình)

| Chỉ số | Lý do |
|---|---|
| **ROC AUC** | Để so với kết quả bên ngoài (ví dụ điểm Kaggle của IEEE-CIS và S6E11 đều tính bằng ROC AUC). Không dùng để chọn mô hình vì thường cao giả |
| **FPR và số cảnh báo sai tuyệt đối** | FPR luôn nhỏ; con số tuyệt đối (ví dụ 850 cảnh báo sai) mới phản ánh khối lượng công việc |
| **Precision, Recall, F1 tại ngưỡng đã chọn** | Khi đưa mô hình vào dashboard cần một ngưỡng cụ thể; ngưỡng phải chọn trên **validation**, không chọn trên holdout |
| **Tỷ lệ gian lận và số vụ gian lận trong tập đánh giá** | Bắt buộc báo kèm. Tập có ít vụ gian lận (ví dụ holdout của ULB khoảng 75 vụ) thì kết quả dao động mạnh: bắt thêm hoặc sót 5 vụ đã làm Recall thay đổi khoảng 7% |
| **Brier score** | Chỉ khi cần điểm là xác suất thật |

### Bỏ qua

| Chỉ số | Lý do |
|---|---|
| **Accuracy** | Mô hình "luôn báo bình thường" vẫn đạt điểm rất cao (mục 2) |
| **Specificity** | Luôn gần 100% |
| **Balanced Accuracy** | Không cho thêm thông tin so với Recall |

---

## 5. Cách tính trong Python

```python
import numpy as np
from sklearn.metrics import (
    average_precision_score, roc_auc_score, precision_score, recall_score, f1_score,
)


def at_k(y_true, scores, k, amounts=None):
    """Precision@K, Recall@K và (nếu có số tiền) Fraud Amount Recall@K."""
    y_true = np.asarray(y_true)
    top = np.argsort(-np.asarray(scores), kind="stable")[:k]  # K giao dịch điểm cao nhất
    caught = y_true[top].sum()
    out = {"precision@k": caught / k, "recall@k": caught / y_true.sum()}
    if amounts is not None:
        amounts = np.asarray(amounts)
        fraud_amount = amounts[y_true == 1].sum()
        out["fraud_amount_recall@k"] = amounts[top][y_true[top] == 1].sum() / fraud_amount
    return out


ap = average_precision_score(y_val, scores)           # chỉ số chính
roc = roc_auc_score(y_val, scores)                    # để so với bên ngoài
k = int(0.01 * len(y_val))                            # ngân sách cảnh báo 1%
budget = at_k(y_val, scores, k, amounts=amount_val)

y_pred = (scores >= threshold).astype(int)            # ngưỡng chọn trên validation
precision, recall = precision_score(y_val, y_pred), recall_score(y_val, y_pred)
f1 = f1_score(y_val, y_pred)
```