# KAN-32 · So sánh mô hình phát hiện gian lận thẻ

## Phạm vi và đề xuất

**Đọc nhanh:** Hãy hình dung hệ thống ngân hàng nhận một giao dịch mới và cần quyết định có chuyển giao dịch đó sang hàng đợi kiểm tra hay không. Mô hình nhận các đặc trưng (feature, tức thông tin đầu vào như số tiền, giờ giao dịch và kênh thanh toán), rồi trả điểm rủi ro. Điểm cao được ưu tiên kiểm tra, không có nghĩa là chắc chắn gian lận.

So sánh bốn mô hình có giám sát (học từ giao dịch có nhãn gian lận/hợp lệ) được đề xuất trong tài liệu của `main` (Logistic Regression, Random Forest, XGBoost, LightGBM) và hai hướng nghiên cứu phát hiện bất thường (Isolation Forest, Autoencoder: tìm giao dịch khác với hành vi thông thường). CatBoost là ứng viên bổ sung khi dữ liệu có nhiều biến phân loại, tức các giá trị dạng nhóm như kênh app/web/quầy. Ví dụ bên dưới dùng chung một bộ giao dịch tổng hợp; quy trình đánh giá dự án nằm trong [checklist KAN-33](Temporal-split-checklist.md). [Model-ideas trên main](https://github.com/AIVIETNAM-AIO-TranPhucKhanh/AI4LIFE-Credit-Card-Fraud-Detection/blob/05e5b344edab93f5c47aab2e4967dbe5094e1807/docs/Model-ideas.md)

1. **MVP**. Dùng Logistic Regression có và không có trọng số làm baseline (mô hình mốc để biết phương pháp mới có cải thiện không), Random Forest làm mốc phi tuyến (học được quy luật kết hợp nhiều dấu hiệu), XGBoost làm ứng viên boosting đầu tiên (xây nhiều cây nối tiếp, cây sau giúp sửa sai cho mô hình trước). Thử LightGBM trên cùng cửa sổ nếu cần đối chiếu hiệu quả hoặc chi phí tính toán. Thử CatBoost khi biến phân loại gốc có giá trị, chẳng hạn loại thiết bị hoặc kênh giao dịch. Giữ hai mô hình bất thường cho nhánh nghiên cứu, đặc biệt khi nhãn ít hoặc đến chậm.
2. **So sánh công bằng**. Dùng cùng giao dịch, nhóm đặc trưng có tại thời điểm chấm, các cửa sổ theo thời gian và ngân sách cảnh báo `K` (số giao dịch có thể chuyển đi kiểm tra). Chọn ứng viên trên validation (tập dùng để chọn mô hình) theo AP (Average Precision, chất lượng xếp hạng giao dịch gian lận) và Recall@K (tỷ lệ gian lận được tìm thấy trong K cảnh báo). Đọc thêm Precision@K (tỷ lệ cảnh báo là gian lận thật), số cảnh báo sai, FPR (tỷ lệ giao dịch hợp lệ bị cảnh báo) và P95 thời gian suy luận (mốc thời gian mà 95% lượt chấm điểm không vượt quá) trên cùng phần cứng. Nếu mức cải thiện ở cùng ngân sách thiếu ổn định qua các cửa sổ hoặc quá ít ca gian lận, ưu tiên baseline dễ giải thích và vận hành. Chốt cấu hình trước khi chấm holdout (tập đánh giá cuối, không dùng để chọn mô hình). [Evaluation-framework trên main](https://github.com/AIVIETNAM-AIO-TranPhucKhanh/AI4LIFE-Credit-Card-Fraud-Detection/blob/05e5b344edab93f5c47aab2e4967dbe5094e1807/docs/Evaluation-framework.md) · [Dal Pozzolo và cộng sự, 2018](https://dalpozz.github.io/static/pdf/TNNLS_2017.pdf)
3. **Huấn luyện và đánh giá riêng từng bộ dữ liệu**. ULB phù hợp làm benchmark bảng số ngắn, thiếu khóa theo thẻ để dựng lịch sử. Sparkov phù hợp thử đặc trưng hành vi trên dữ liệu mô phỏng. Với IEEE-CIS, ghép bảng giao dịch và định danh bằng left join theo `TransactionID` sau khi kiểm tra tính duy nhất của khóa ở cả hai bảng (`validate="one_to_one"`); xác nhận số dòng và ID giao dịch không đổi, sau đó chia phần có nhãn theo `TransactionDT`. Đây là hướng đề xuất tiếp nối nghiên cứu dataset KAN-29. Số 33 cột của Sparkov là từ mẫu thử và phụ thuộc encoder (bộ chuyển dữ liệu dạng nhóm thành số), còn IEEE-CIS có schema (cấu trúc các cột) và ý nghĩa biến khác. Test công khai IEEE-CIS dùng cho suy luận vì nhãn không được cung cấp. [PR #6 của Đức Anh](https://github.com/AIVIETNAM-AIO-TranPhucKhanh/AI4LIFE-Credit-Card-Fraud-Detection/pull/6/files) · [ULB](https://www.kaggle.com/mlg-ulb/creditcardfraud/) · [IEEE-CIS](https://www.kaggle.com/competitions/ieee-fraud-detection/data)

## Bảng so sánh

**Cách đọc bảng:** Cây quyết định là chuỗi câu hỏi có/không, ví dụ “số tiền có cao hơn mức thường chi không?”. Một lá là nhóm giao dịch ở cuối chuỗi câu hỏi. Mô hình quá khớp khi học quá sát dữ liệu cũ, kể cả nhiễu, nhưng dự đoán kém trên dữ liệu mới. Trọng số lớp là cách làm lỗi trên một lớp có ảnh hưởng lớn hơn khi huấn luyện (ví dụ lớp gian lận rất hiếm); không phải số tiền thiệt hại thực tế hay bảo đảm dự đoán đúng.

| Mô hình | Vai trò | Ưu điểm | Hạn chế | Khi gian lận hiếm |
|---|---|---|---|---|
| Logistic Regression | Baseline có giám sát | Nhanh, dễ kiểm tra mức ảnh hưởng của từng biến sau khi đưa về thang đo chung | Mô hình cộng điểm tuyến tính trên thang log-odds (log của tỷ số khả năng gian lận so với hợp lệ); cần thiết kế thêm tương tác | So sánh không trọng số với `class_weight="balanced"` (tăng trọng số lớp hiếm) |
| Random Forest | Mốc phi tuyến | Học ngưỡng và tương tác, ít cần chuẩn hóa | Nhiều cây làm tăng kích thước và chi phí suy luận, khó giải thích từng cảnh báo | `balanced_subsample` tính trọng số lớp theo mẫu bootstrap (lấy ngẫu nhiên có hoàn lại) của từng cây |
| XGBoost | Ứng viên boosting đầu tiên | Học tương tác, có điều chuẩn (hạn chế mô hình quá phức tạp) và xử lý giá trị thiếu | Nhạy với độ sâu, số vòng và trọng số lớp | `scale_pos_weight` tăng ảnh hưởng của lớp dương (gian lận); thử từ 1 đến tỷ lệ hợp lệ/gian lận của train |
| LightGBM | Ứng viên boosting bổ sung | Histogram (gom các giá trị vào khoảng) và ưu tiên tách lá có lợi nhất, phù hợp khi dữ liệu bảng lớn | Lá nhỏ dễ học nhiễu, cần kiểm soát số lá và kích thước lá | Dùng một trong `scale_pos_weight` hoặc `is_unbalance` (tự điều chỉnh trọng số do mất cân bằng) |
| CatBoost | Ứng viên cho dữ liệu nhiều biến phân loại | Xử lý biến phân loại gốc; ordered boosting dùng mô hình học từ các mẫu đứng trước để ước lượng hướng sửa sai cho mẫu đang xét | Thêm thư viện, cần đo chi phí và giữ thứ tự đầu vào khi dùng `has_time` (tôn trọng thứ tự dòng) | Dùng một trong `class_weights` (trọng số chỉ định), `auto_class_weights` (trọng số tự tính) hoặc `scale_pos_weight` |
| Isolation Forest | Phát hiện bất thường không giám sát | Fit không cần nhãn, có điểm liên tục để xếp hạng | Giao dịch hợp lệ hiếm cũng có thể bị đánh điểm cao, gian lận giống hành vi thường có thể lọt | Dùng điểm bất thường và đánh giá theo ngân sách, `contamination` (tỷ lệ bất thường giả định hoặc chế độ tự động) điều khiển ngưỡng phân loại |
| Autoencoder | Phát hiện bất thường bằng tái tạo | Học được cấu trúc phi tuyến của hành vi thường | Phụ thuộc scaling (đưa biến về thang đo chung) và độ rộng nút thắt (lớp nén nhỏ nhất), có thể tái tạo tốt cả gian lận | Ưu tiên giao dịch hợp lệ đã xác nhận để fit khi có nhãn, đo hiệu quả bằng tập đánh giá tự nhiên |

## Mất cân bằng lớp và chỉ số

Ví dụ minh họa: nếu 10.000 giao dịch có 20 ca gian lận, mô hình đoán tất cả là hợp lệ vẫn đúng 99,8% nhưng bỏ sót toàn bộ 20 ca. Đây là lý do không dùng accuracy (tỷ lệ dự đoán đúng) làm chỉ số chính. Nếu chỉ kiểm tra 50 cảnh báo và bắt được 10 ca, Precision@50 = 10/50 = 20%, còn Recall@50 = 10/20 = 50%. AP đánh giá chất lượng xếp hạng qua nhiều mức cắt, không chỉ một ngân sách cố định.

- **Khi huấn luyện**. Trọng số lớp làm lỗi trên ca gian lận có ảnh hưởng lớn hơn khi fit. Tỷ lệ `n_hợp_lệ / n_gian_lận` lấy từ từng tập train là một điểm thử. Nếu thử lấy mẫu lại, thực hiện bên trong từng fold train (tập học của mỗi lượt kiểm chứng) sau khi chia thời gian. Oversampling (tăng mẫu lớp hiếm) có thể lặp lại nhiễu, undersampling (giảm mẫu lớp phổ biến) có thể làm mất các giao dịch hợp lệ hiếm, SMOTE (tạo điểm tổng hợp bằng nội suy giữa các mẫu lớp hiếm) trên biến đã one-hot (mỗi danh mục thành một cột 0/1) có thể tạo danh mục không hợp lệ. Giữ nguyên tỷ lệ lớp và lượng giao dịch ở validation/holdout. Nếu cần xác suất để ra quyết định, hiệu chỉnh và kiểm tra xác suất trên các cửa sổ phát triển có tỷ lệ tự nhiên, theo thứ tự thời gian. [imbalanced-learn](https://imbalanced-learn.org/stable/common_pitfalls.html) · [Hiệu chỉnh xác suất trong scikit-learn](https://scikit-learn.org/stable/modules/calibration.html)
- **Khi đánh giá**. AP của scikit-learn lấy tổng precision có trọng số theo phần recall tăng thêm. Báo kèm tỷ lệ gian lận vì AP phụ thuộc tỷ lệ lớp; một bộ dự đoán cho cùng một điểm trên mọi giao dịch có AP bằng tỷ lệ này (khi có nhãn dương). Với top-`K`, Precision@K = TP (số giao dịch gian lận được cảnh báo đúng) trong top-`K` / số cảnh báo thực tế, Recall@K = TP trong top-`K` / tổng số ca gian lận. Công bố `K` theo cửa sổ, cách xử lý đồng điểm và mẫu số. Top-`K` cuối ngày mô phỏng duyệt theo lô. Với cảnh báo tức thời, mô phỏng quy tắc ra quyết định khi từng giao dịch đến. Khi có số tiền phù hợp, Fraud Amount Recall@K đo phần giá trị giao dịch gian lận được bắt, với mẫu số là toàn bộ giá trị gian lận trong tập đánh giá; nếu mẫu số bằng 0, báo N/A. Chỉ số này không đồng nghĩa với số tiền thực tế ngăn chặn được. [average_precision_score](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.average_precision_score.html) · [Saito và Rehmsmeier, 2015](https://doi.org/10.1371/journal.pone.0118432) · [PR #6](https://github.com/AIVIETNAM-AIO-TranPhucKhanh/AI4LIFE-Credit-Card-Fraud-Detection/pull/6/files)

## Ví dụ chạy trên dữ liệu tổng hợp

Tạo môi trường Python 3.11 riêng và cài các gói sau. `catboost` chỉ cần cho ví dụ bổ sung. Trên macOS, các bản XGBoost/LightGBM có thể cần OpenMP; dùng bản phân phối có runtime phù hợp với môi trường. [Cài đặt XGBoost](https://xgboost.readthedocs.io/en/stable/install.html) · [Cài đặt LightGBM](https://lightgbm.readthedocs.io/en/stable/Installation-Guide.html)

```bash
python -m pip install numpy pandas scikit-learn xgboost lightgbm catboost
```

Chạy khối chuẩn bị rồi chạy bất kỳ ví dụ nào bên dưới trong cùng phiên Python, hoặc ghép các khối Python theo thứ tự vào một tệp. Mỗi dòng đại diện cho một thời điểm tăng dần và chỉ số dòng dùng để chia tập cũng như quyết định thứ tự khi bằng điểm. Biến phân loại `channel` có một giá trị mới ở validation. Mỗi cấu hình chấm trên cùng cửa sổ validation với `K = 50` cho cả cửa sổ. Logistic Regression có hai cấu hình để đối chiếu ảnh hưởng của trọng số lớp. Các điểm in ra dùng kiểm thử mã và phép đo trên dữ liệu tổng hợp.

Trong code, `random_state`/`random_seed` cố định nguồn ngẫu nhiên để dễ lặp lại; `n_jobs=1`/`thread_count=1` giới hạn số luồng phục vụ ví dụ. Đây là cấu hình minh họa, không phải bộ tham số tối ưu trên dữ liệu thực tế.

Các phiên bản tham chiếu của môi trường thử nghiệm ban đầu: Python 3.11.18, NumPy 2.4.6, pandas 3.1.1, scikit-learn 1.9.1, XGBoost 3.2.0, LightGBM 4.7.0 và CatBoost 1.2.10. Khi cần tái lập kết quả, dùng cùng phiên bản và seed; kết quả có thể khác giữa các môi trường. Seed trong ví dụ cho 80 ca gian lận trên 4.200 dòng train và 18 trên 1.800 dòng validation.

```python
import numpy as np
import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.metrics import average_precision_score
from sklearn.preprocessing import OneHotEncoder

rng = np.random.default_rng(42)
n, cut, k = 6000, 4200, 50
x = rng.normal(size=(n, 8))
raw = pd.DataFrame(x, columns=[f"x{i}" for i in range(x.shape[1])])
raw["channel"] = rng.choice(["app", "store", "web"], size=n)
raw.loc[cut::19, "channel"] = "partner"
logit = -5.2 + 1.2 * x[:, 0] + 0.9 * (x[:, 1] * x[:, 2] > 0.8)
logit += 0.6 * (raw["channel"] == "web").to_numpy()
probability = 1 / (1 + np.exp(-logit))
y = (rng.random(n) < probability).astype(int)

raw_train, raw_val = raw.iloc[:cut], raw.iloc[cut:]
y_train, y_val = y[:cut], y[cut:]
assert raw_train.index.max() < raw_val.index.min()
assert np.unique(y_train).size == np.unique(y_val).size == 2
pos_weight = (y_train == 0).sum() / (y_train == 1).sum()

encoder = ColumnTransformer(
    [("channel", OneHotEncoder(handle_unknown="ignore", sparse_output=False), ["channel"])],
    remainder="passthrough",
).set_output(transform="pandas")
X_train, X_val = encoder.fit_transform(raw_train), encoder.transform(raw_val)


def report(name, scores):
    scores = np.asarray(scores)
    assert scores.shape == y_val.shape and np.isfinite(scores).all()
    assert 0 < k <= len(y_val)
    best = np.argsort(-scores, kind="stable")[:k]
    caught = y_val[best].sum()
    ap = average_precision_score(y_val, scores)
    print(f"{name}: AP={ap:.3f}, P@{k}={caught / k:.3f}, R@{k}={caught / y_val.sum():.3f}")
```

### 1. Logistic Regression

**Hiểu đơn giản:** Giống một bảng cộng điểm rủi ro. Ví dụ minh họa: số tiền lớn cộng 2 điểm, giao dịch lúc nửa đêm cộng 1 điểm; model tự học mức cộng/trừ từ dữ liệu rồi chuyển tổng điểm về khoảng 0–1.

**Cơ chế kỹ thuật:** Mô hình học một tổ hợp tuyến tính của các đặc trưng trên thang log-odds, sau đó dùng hàm sigmoid (hàm đưa một số thực về khoảng 0–1) để cho điểm lớp gian lận. Điều chuẩn giúp hạn chế hệ số quá lớn, còn chuẩn hóa trong pipeline (chuỗi xử lý và mô hình) được fit từ train. Điểm từ mô hình có trọng số chưa chắc là xác suất gian lận đã được hiệu chỉnh.

**Tham số trong ví dụ:** `class_weight=None` dùng trọng số như nhau cho mọi mẫu; `class_weight="balanced"` tự tăng trọng số lớp hiếm theo tần suất nhãn trong train, để mô hình không dễ bỏ qua gian lận. `StandardScaler` đưa biến về thang đo chung dựa trên train. So sánh hai cấu hình để biết tăng trọng số có giúp ở cùng ngân sách cảnh báo hay không. [scikit-learn LogisticRegression](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html)

```python
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler

for weight in (None, "balanced"):
    lr = make_pipeline(
        StandardScaler(), LogisticRegression(class_weight=weight)
    )
    lr.fit(X_train, y_train)
    report(f"Logistic Regression ({weight})", lr.predict_proba(X_val)[:, 1])
```

### 2. Random Forest

**Hiểu đơn giản:** Giống nhiều người cùng kiểm tra một giao dịch bằng các quy tắc hơi khác nhau. Một cây chú ý số tiền, cây khác kết hợp số tiền với tần suất chi tiêu; kết hợp ý kiến giúp bớt phụ thuộc vào một quy tắc đơn lẻ.

**Cơ chế kỹ thuật:** Mỗi cây học trên một mẫu bootstrap, với một tập con đặc trưng được xét ở mỗi lần chia. Trung bình điểm lớp gian lận từ các cây giúp giảm phương sai (mức dao động của dự đoán khi dữ liệu học thay đổi) so với một cây đơn lẻ.

**Tham số trong ví dụ:** `n_estimators=120` là số cây; nhiều cây thường ổn định hơn nhưng tốn thời gian. `min_samples_leaf=5` yêu cầu ít nhất 5 mẫu ở mỗi lá, giúp tránh học quy luật chỉ từ vài giao dịch. `class_weight="balanced_subsample"` tính lại trọng số theo tần suất lớp trong mẫu bootstrap của từng cây. [Breiman, 2001](https://www.stat.berkeley.edu/~breiman/randomforest2001.pdf) · [scikit-learn RandomForestClassifier](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html)

```python
from sklearn.ensemble import RandomForestClassifier

rf = RandomForestClassifier(
    n_estimators=120, min_samples_leaf=5, class_weight="balanced_subsample",
    random_state=42, n_jobs=1,
)
rf.fit(X_train, y_train)
report("Random Forest", rf.predict_proba(X_val)[:, 1])
```

### 3. XGBoost

**Hiểu đơn giản:** Thay vì để nhiều cây học riêng rồi tổng hợp như Random Forest, XGBoost xây cây lần lượt. Ví dụ mô hình ban đầu bỏ sót một số giao dịch nhỏ nhưng xảy ra dồn dập; cây sau có thể học cách điều chỉnh điểm rủi ro cho những trường hợp đó.

**Cơ chế kỹ thuật:** XGBoost thêm cây tuần tự để giảm loss (hàm đo mức dự đoán sai). Gradient là đạo hàm bậc nhất, cho biết hướng và mức thay đổi của loss khi điều chỉnh điểm dự đoán; đạo hàm bậc hai mô tả độ cong của loss, giúp ước lượng mức cải thiện khi xây cây. Điều chuẩn hạn chế độ phức tạp của mô hình.

**Tham số trong ví dụ:** `n_estimators=120` là số vòng thêm cây; `max_depth=3` giới hạn độ sâu mỗi cây; `learning_rate=0.05` giảm mức đóng góp của từng cây để học từ từ. `tree_method="hist"` gom giá trị vào các khoảng khi tìm điểm chia để tăng tốc. `scale_pos_weight=pos_weight` tăng trọng số ca gian lận theo tỷ lệ hợp lệ/gian lận của train; đây chỉ là mức thử, cần đối chiếu trên validation. [Chen và Guestrin, 2016](https://arxiv.org/abs/1603.02754) · [Tham số XGBoost](https://xgboost.readthedocs.io/en/stable/parameter.html)

```python
from xgboost import XGBClassifier

xgb = XGBClassifier(
    n_estimators=120, max_depth=3, learning_rate=0.05, tree_method="hist",
    scale_pos_weight=pos_weight, random_state=42, n_jobs=1,
)
xgb.fit(X_train, y_train)
report("XGBoost", xgb.predict_proba(X_val)[:, 1])
```

### 4. LightGBM

**Hiểu đơn giản:** Cũng là mô hình học bằng các cây nối tiếp như XGBoost, nhưng ưu tiên mở rộng phần cây đang giúp giảm lỗi nhiều nhất. Ví dụ nếu nhóm giao dịch online cần phân biệt thêm các trường hợp, model có thể tập trung chia nhỏ nhóm đó thay vì chia đều mọi nhóm.

**Cơ chế kỹ thuật:** LightGBM gom các giá trị thành histogram rồi chọn lá có mức giảm loss ước tính lớn nhất để tách. Cách tăng trưởng theo lá có thể làm một nhánh sâu hơn các nhánh còn lại, nên cần hạn chế quá khớp, nhất là khi ít ca gian lận.

**Tham số trong ví dụ:** `num_leaves=15` giới hạn số lá của mỗi cây; `min_child_samples=30` yêu cầu số mẫu tối thiểu ở lá (giúp tránh nhóm quá nhỏ). `n_estimators=120` là số vòng boosting, `learning_rate=0.05` giảm đóng góp mỗi vòng. `scale_pos_weight=pos_weight` tăng trọng số lớp gian lận; nếu dùng `is_unbalance` thì không dùng đồng thời hai cách. [Ke và cộng sự, 2017](https://papers.nips.cc/paper/2017/file/6449f44a102fde848669bdd9eb6b76fa-Paper.pdf) · [Tham số LightGBM](https://lightgbm.readthedocs.io/en/stable/Parameters.html)

```python
from lightgbm import LGBMClassifier

lgbm = LGBMClassifier(
    n_estimators=120, num_leaves=15, min_child_samples=30, learning_rate=0.05,
    scale_pos_weight=pos_weight, random_state=42, n_jobs=1, verbosity=-1,
)
lgbm.fit(X_train, y_train)
report("LightGBM", lgbm.predict_proba(X_val)[:, 1])
```

### 5. CatBoost

**Hiểu đơn giản:** Cũng dùng cây nối tiếp để cải thiện dự đoán, nhưng có cách học trực tiếp từ các nhóm như loại thiết bị, kênh thanh toán hoặc ngành hàng. Ví dụ model có thể khai thác lịch sử gian lận của nhóm giao dịch web mà không phải tự biến tất cả danh mục thành hàng trăm cột.

**Cơ chế kỹ thuật:** CatBoost xây các cây boosting và có thể mã hóa biến phân loại bằng thống kê nhãn từ các mẫu đứng trước trong một thứ tự (không lấy chính nhãn của mẫu đang xét để mã hóa nó). Ordered boosting là cơ chế khác: ước lượng gradient cho mỗi mẫu bằng mô hình học từ các mẫu đứng trước nó. Hai cơ chế giúp hạn chế sai lệch do dùng thông tin của chính mẫu, nhưng không tự giải quyết mọi dạng data leakage (lộ thông tin tương lai/đáp án). Ví dụ dùng dữ liệu gốc đã xếp thời gian và `has_time=True` để CatBoost giữ thứ tự dòng. Vẫn phải kiểm tra thời điểm nhãn thực sự có sẵn theo KAN-33.

**Tham số trong ví dụ:** `iterations=100`, `depth=4`, `learning_rate=0.05` lần lượt là số vòng, độ sâu cây và mức học mỗi vòng. `cat_features=["channel"]` chỉ định cột danh mục; `one_hot_max_size=2` đặt ngưỡng số danh mục được one-hot trong cấu hình này. `boosting_type="Ordered"` chọn ordered boosting; `has_time=True` giữ thứ tự đầu vào. `class_weights=[1.0, pos_weight]` đặt trọng số hợp lệ và gian lận; không dùng đồng thời với cách đặt trọng số lớp khác. [Prokhorenkova và cộng sự, 2018](https://proceedings.neurips.cc/paper_files/paper/2018/file/14491b756b3a51daac41c24863285549-Paper.pdf) · [Tham số CatBoost](https://catboost.ai/docs/en/references/training-parameters/common)

```python
from catboost import CatBoostClassifier

cat = CatBoostClassifier(
    iterations=100, depth=4, learning_rate=0.05, cat_features=["channel"],
    boosting_type="Ordered", has_time=True, one_hot_max_size=2,
    class_weights=[1.0, pos_weight], random_seed=42, thread_count=1,
    verbose=False, allow_writing_files=False,
)
cat.fit(raw_train, y_train)
report("CatBoost", cat.predict_proba(raw_val)[:, 1])
```

### 6. Isolation Forest

**Hiểu đơn giản:** Giống trò tìm một giao dịch khác biệt trong đám đông. Một giao dịch có số tiền rất lớn và hành vi khác hẳn phần còn lại có thể được tách ra chỉ sau vài câu hỏi, nên được đánh điểm bất thường cao; giao dịch lạ vẫn có thể hợp lệ.

**Cơ chế kỹ thuật:** Mỗi cây chọn ngẫu nhiên đặc trưng và điểm chia để cô lập mẫu. Điểm bất thường có xu hướng cần ít bước chia hơn, nên ta đảo dấu `score_samples` của scikit-learn để điểm cao nghĩa là đáng xem xét trước. Fit không dùng nhãn gian lận; đây là phát hiện bất thường không giám sát, không phải mô hình ước lượng xác suất gian lận.

**Tham số trong ví dụ:** `n_estimators=120` là số cây cô lập; `contamination` dùng để đặt ngưỡng phân loại bất thường, không phải trọng số lớp và không nhất thiết bằng tỷ lệ gian lận. Ví dụ dùng giá trị mặc định của tham số này và xếp hạng trực tiếp bằng điểm liên tục thay vì nhãn phân loại của model. [Liu, Ting và Zhou, 2008](https://doi.org/10.1109/ICDM.2008.17) · [scikit-learn IsolationForest](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.IsolationForest.html)

```python
from sklearn.ensemble import IsolationForest

isolation = IsolationForest(n_estimators=120, random_state=42, n_jobs=1)
isolation.fit(X_train)
report("Isolation Forest", -isolation.score_samples(X_val))
```

### 7. Autoencoder

**Hiểu đơn giản:** Giống học cách nén rồi khôi phục một bản mô tả giao dịch. Khi đã quen với giao dịch bình thường, model có thể khôi phục chúng khá tốt; một giao dịch có hành vi khác lạ có thể khó khôi phục hơn và được ưu tiên kiểm tra.

**Cơ chế kỹ thuật:** Mạng học nén đầu vào qua một lớp nhỏ rồi tái tạo đầu vào, với sai số tái tạo (mức chênh lệch giữa đầu vào và bản khôi phục) làm điểm bất thường. Ví dụ dùng MLP (mạng nơ-ron nhiều lớp) có nút thắt để minh họa, fit scaler và mạng trên giao dịch hợp lệ đã biết trong train. Đây là novelty detection (học hành vi bình thường đã biết rồi phát hiện mẫu mới khác biệt), có dùng nhãn để lọc tập fit. Khi nhãn chưa đủ và fit trên dữ liệu hỗn hợp, cần đo độ nhạy với tỷ lệ gian lận lẫn trong train. Model có thể tái tạo tốt cả một số giao dịch gian lận nên sai số thấp không bảo đảm an toàn.

**Tham số trong ví dụ:** `hidden_layer_sizes=(12, 4, 12)` đặt ba lớp ẩn, lớp 4 nút là nút thắt nén thông tin. `max_iter=300` giới hạn số vòng học, `tol=1e-3` là mức cải thiện tối thiểu dùng trong tiêu chí dừng. `StandardScaler` đưa biến về thang chung, tránh một biến lớn chi phối sai số; chỉ fit trên giao dịch hợp lệ đã biết trong train. [Hinton và Salakhutdinov, 2006](https://pubmed.ncbi.nlm.nih.gov/16873662/) · [scikit-learn MLPRegressor](https://scikit-learn.org/stable/modules/generated/sklearn.neural_network.MLPRegressor.html)

```python
from sklearn.neural_network import MLPRegressor
from sklearn.preprocessing import StandardScaler

normal = X_train.loc[y_train == 0]
scaler = StandardScaler().fit(normal)
Z_normal, Z_val = scaler.transform(normal), scaler.transform(X_val)
autoencoder = MLPRegressor(
    hidden_layer_sizes=(12, 4, 12), max_iter=300, tol=1e-3, random_state=42,
)
autoencoder.fit(Z_normal, Z_normal)
residual = Z_val - autoencoder.predict(Z_val)
report("Autoencoder", np.mean(residual ** 2, axis=1))
```
