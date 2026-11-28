# KAN-32 · So sánh mô hình phát hiện gian lận thẻ

## Phạm vi và đề xuất

So sánh bốn mô hình có giám sát được đề xuất trong tài liệu của `main` (Logistic Regression, Random Forest, XGBoost, LightGBM) và hai hướng nghiên cứu phát hiện bất thường (Isolation Forest, Autoencoder). CatBoost là ứng viên bổ sung khi dữ liệu có nhiều biến phân loại. Ví dụ bên dưới dùng chung một bộ giao dịch tổng hợp; quy trình đánh giá dự án nằm trong [checklist KAN-33](Temporal-split-checklist.md). [Model-ideas trên main](https://github.com/AIVIETNAM-AIO-TranPhucKhanh/AI4LIFE-Credit-Card-Fraud-Detection/blob/05e5b344edab93f5c47aab2e4967dbe5094e1807/docs/Model-ideas.md)

1. **MVP**. Dùng Logistic Regression có và không có trọng số làm baseline, Random Forest làm mốc phi tuyến, XGBoost làm ứng viên boosting đầu tiên. Thử LightGBM trên cùng cửa sổ nếu cần đối chiếu hiệu quả hoặc chi phí tính toán. Thử CatBoost khi biến phân loại gốc có giá trị, chẳng hạn loại thiết bị hoặc kênh giao dịch. Giữ hai mô hình bất thường cho nhánh nghiên cứu, đặc biệt khi nhãn ít hoặc đến chậm.
2. **So sánh công bằng**. Dùng cùng giao dịch, nhóm đặc trưng có tại thời điểm chấm, các cửa sổ theo thời gian và ngân sách cảnh báo `K`. Chọn ứng viên trên validation theo AP và Recall@K. Đọc thêm Precision@K, số cảnh báo sai, FPR và P95 thời gian suy luận trên cùng phần cứng. Nếu mức cải thiện ở cùng ngân sách thiếu ổn định qua các cửa sổ hoặc quá ít ca gian lận, ưu tiên baseline dễ giải thích và vận hành. Chốt cấu hình trước khi chấm holdout. [Evaluation-framework trên main](https://github.com/AIVIETNAM-AIO-TranPhucKhanh/AI4LIFE-Credit-Card-Fraud-Detection/blob/05e5b344edab93f5c47aab2e4967dbe5094e1807/docs/Evaluation-framework.md) · [Dal Pozzolo và cộng sự, 2018](https://dalpozz.github.io/static/pdf/TNNLS_2017.pdf)
3. **Huấn luyện và đánh giá riêng từng bộ dữ liệu**. ULB phù hợp làm benchmark bảng số ngắn, thiếu khóa theo thẻ để dựng lịch sử. Sparkov phù hợp thử đặc trưng hành vi trên dữ liệu mô phỏng. Với IEEE-CIS, ghép bảng giao dịch và định danh bằng left join theo `TransactionID` sau khi kiểm tra tính duy nhất của khóa ở cả hai bảng (`validate="one_to_one"`); xác nhận số dòng và ID giao dịch không đổi, sau đó chia phần có nhãn theo `TransactionDT`. Đây là hướng đề xuất tiếp nối nghiên cứu dataset KAN-29. Số 33 cột của Sparkov là từ mẫu thử và phụ thuộc encoder, còn IEEE-CIS có schema và ý nghĩa biến khác. Test công khai IEEE-CIS dùng cho suy luận vì nhãn không được cung cấp. [PR #6 của Đức Anh](https://github.com/AIVIETNAM-AIO-TranPhucKhanh/AI4LIFE-Credit-Card-Fraud-Detection/pull/6/files) · [ULB](https://www.kaggle.com/mlg-ulb/creditcardfraud/) · [IEEE-CIS](https://www.kaggle.com/competitions/ieee-fraud-detection/data)

## Bảng so sánh

| Mô hình | Vai trò | Ưu điểm | Hạn chế | Khi gian lận hiếm |
|---|---|---|---|---|
| Logistic Regression | Baseline có giám sát | Nhanh, dễ kiểm tra hệ số với biến đã chuẩn hóa | Log-odds tuyến tính, cần thiết kế thêm tương tác | So sánh không trọng số với `class_weight="balanced"` |
| Random Forest | Mốc phi tuyến | Học ngưỡng và tương tác, ít cần chuẩn hóa | Nhiều cây làm tăng kích thước và chi phí suy luận, khó giải thích từng cảnh báo | `balanced_subsample` tính trọng số theo mẫu bootstrap của từng cây |
| XGBoost | Ứng viên boosting đầu tiên | Học tương tác, có điều chuẩn và xử lý giá trị thiếu | Nhạy với độ sâu, số vòng và trọng số lớp | Thử `scale_pos_weight` quanh các mức từ 1 đến tỷ lệ âm/dương của train |
| LightGBM | Ứng viên boosting bổ sung | Histogram và tăng trưởng theo lá phù hợp khi dữ liệu bảng lớn | Lá nhỏ dễ học nhiễu, cần kiểm soát số lá và kích thước lá | Dùng một trong `scale_pos_weight` hoặc `is_unbalance` |
| CatBoost | Ứng viên cho dữ liệu nhiều biến phân loại | Xử lý biến phân loại gốc, có ordered boosting | Thêm thư viện, cần đo chi phí và giữ thứ tự đầu vào khi dùng `has_time` | Dùng một trong `class_weights`, `auto_class_weights` hoặc `scale_pos_weight` |
| Isolation Forest | Phát hiện bất thường không giám sát | Fit không cần nhãn, có điểm liên tục để xếp hạng | Giao dịch hợp lệ hiếm cũng có thể bị đánh điểm cao, gian lận giống hành vi thường có thể lọt | Dùng điểm bất thường và đánh giá theo ngân sách, `contamination` điều khiển ngưỡng phân loại |
| Autoencoder | Phát hiện bất thường bằng tái tạo | Học được cấu trúc phi tuyến của hành vi thường | Phụ thuộc scaling và độ rộng nút thắt, có thể tái tạo tốt cả gian lận | Ưu tiên giao dịch hợp lệ đã xác nhận để fit khi có nhãn, đo hiệu quả bằng tập đánh giá tự nhiên |

## Mất cân bằng lớp và chỉ số

- **Khi huấn luyện**. Trọng số lớp làm lỗi trên ca gian lận có ảnh hưởng lớn hơn khi fit. Tỷ lệ `n_hợp_lệ / n_gian_lận` lấy từ từng tập train là một điểm thử. Nếu thử lấy mẫu lại, thực hiện bên trong từng fold train sau khi chia thời gian. Oversampling có thể lặp lại nhiễu, undersampling có thể làm mất các giao dịch hợp lệ hiếm, SMOTE trên biến đã one-hot có thể tạo danh mục không hợp lệ. Giữ nguyên tỷ lệ lớp và lượng giao dịch ở validation/holdout. Nếu cần xác suất để ra quyết định, hiệu chỉnh và kiểm tra xác suất trên các cửa sổ phát triển có tỷ lệ tự nhiên, theo thứ tự thời gian. [imbalanced-learn](https://imbalanced-learn.org/stable/common_pitfalls.html) · [Hiệu chỉnh xác suất trong scikit-learn](https://scikit-learn.org/stable/modules/calibration.html)
- **Khi đánh giá**. AP của scikit-learn lấy tổng precision có trọng số theo phần recall tăng thêm. Báo kèm tỷ lệ gian lận vì AP phụ thuộc tỷ lệ lớp; một bộ dự đoán cho cùng một điểm trên mọi giao dịch có AP bằng tỷ lệ này (khi có nhãn dương). Với top-`K`, Precision@K = TP trong top-`K` / số cảnh báo thực tế, Recall@K = TP trong top-`K` / tổng số ca gian lận. Công bố `K` theo cửa sổ, cách xử lý đồng điểm và mẫu số. Top-`K` cuối ngày mô phỏng duyệt theo lô. Với cảnh báo tức thời, mô phỏng quy tắc ra quyết định khi từng giao dịch đến. Khi có số tiền phù hợp, Fraud Amount Recall@K đo phần giá trị giao dịch gian lận được bắt, với mẫu số là toàn bộ giá trị gian lận trong tập đánh giá; nếu mẫu số bằng 0, báo N/A. Chỉ số này không đồng nghĩa với số tiền thực tế ngăn chặn được. [average_precision_score](https://scikit-learn.org/stable/modules/generated/sklearn.metrics.average_precision_score.html) · [Saito và Rehmsmeier, 2015](https://doi.org/10.1371/journal.pone.0118432) · [PR #6](https://github.com/AIVIETNAM-AIO-TranPhucKhanh/AI4LIFE-Credit-Card-Fraud-Detection/pull/6/files)

## Ví dụ chạy trên dữ liệu tổng hợp

Tạo môi trường Python 3.11 riêng và cài các gói sau. `catboost` chỉ cần cho ví dụ bổ sung. Trên macOS, các bản XGBoost/LightGBM có thể cần OpenMP; dùng bản phân phối có runtime phù hợp với môi trường. [Cài đặt XGBoost](https://xgboost.readthedocs.io/en/stable/install.html) · [Cài đặt LightGBM](https://lightgbm.readthedocs.io/en/stable/Installation-Guide.html)

```bash
python -m pip install numpy pandas scikit-learn xgboost lightgbm catboost
```

Chạy khối chuẩn bị rồi chạy bất kỳ ví dụ nào bên dưới trong cùng phiên Python, hoặc ghép các khối Python theo thứ tự vào một tệp. Mỗi dòng đại diện cho một thời điểm tăng dần và chỉ số dòng dùng để chia tập cũng như quyết định thứ tự khi bằng điểm. Biến phân loại `channel` có một giá trị mới ở validation. Mỗi cấu hình chấm trên cùng cửa sổ validation với `K = 50` cho cả cửa sổ. Logistic Regression có hai cấu hình để đối chiếu ảnh hưởng của trọng số lớp. Các điểm in ra dùng kiểm thử mã và phép đo trên dữ liệu tổng hợp.

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

Mô hình học một tổ hợp tuyến tính của các đặc trưng trên thang log-odds, sau đó dùng hàm sigmoid để cho điểm lớp gian lận. Điều chuẩn giúp hạn chế hệ số quá lớn, còn chuẩn hóa trong pipeline được fit từ train. `balanced` tăng trọng số lớp hiếm theo tần suất nhãn trong train. [scikit-learn LogisticRegression](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html)

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

Mỗi cây học trên một mẫu bootstrap, với một tập con đặc trưng được xét ở mỗi lần chia. Trung bình điểm lớp gian lận từ các cây giúp giảm phương sai so với một cây đơn lẻ. Giới hạn `min_samples_leaf` giúp tránh các lá quá nhỏ khi một số ít ca hiếm có ảnh hưởng lớn. [Breiman, 2001](https://www.stat.berkeley.edu/~breiman/randomforest2001.pdf) · [scikit-learn RandomForestClassifier](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html)

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

XGBoost thêm cây tuần tự để giảm loss, dùng gradient và đạo hàm bậc hai của loss để xây cây, đồng thời điều chuẩn độ phức tạp của mô hình. `tree_method="hist"` dùng các nhóm giá trị để tìm điểm chia, còn `scale_pos_weight` tăng ảnh hưởng của lớp dương trong mục tiêu. [Chen và Guestrin, 2016](https://arxiv.org/abs/1603.02754) · [Tham số XGBoost](https://xgboost.readthedocs.io/en/stable/parameter.html)

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

LightGBM gom các giá trị thành histogram rồi chọn lá có mức giảm loss ước tính lớn nhất để tách. Cách tăng trưởng theo lá có thể làm một nhánh sâu hơn các nhánh còn lại, nên kiểm soát `num_leaves` và `min_child_samples`, nhất là khi ít ca gian lận. [Ke và cộng sự, 2017](https://papers.nips.cc/paper/2017/file/6449f44a102fde848669bdd9eb6b76fa-Paper.pdf) · [Tham số LightGBM](https://lightgbm.readthedocs.io/en/stable/Parameters.html)

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

CatBoost xây các cây boosting và có thể mã hóa biến phân loại bằng thống kê nhãn từ các mẫu đứng trước trong một thứ tự. Ordered boosting ước lượng gradient cho mỗi mẫu bằng mô hình học từ các mẫu đứng trước nó. Ví dụ dùng dữ liệu gốc đã xếp thời gian và `has_time=True` để CatBoost giữ thứ tự dòng. Vẫn phải kiểm tra thời điểm nhãn thực sự có sẵn theo KAN-33. [Prokhorenkova và cộng sự, 2018](https://proceedings.neurips.cc/paper_files/paper/2018/file/14491b756b3a51daac41c24863285549-Paper.pdf) · [Tham số CatBoost](https://catboost.ai/docs/en/references/training-parameters/common)

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

Mỗi cây chọn ngẫu nhiên đặc trưng và điểm chia để cô lập mẫu. Điểm bất thường có xu hướng cần ít bước chia hơn, nên ta đảo dấu `score_samples` của scikit-learn để điểm cao nghĩa là đáng xem xét trước. `contamination` dùng để đặt ngưỡng khi phân loại, còn ví dụ xếp hạng trực tiếp bằng điểm liên tục. [Liu, Ting và Zhou, 2008](https://doi.org/10.1109/ICDM.2008.17) · [scikit-learn IsolationForest](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.IsolationForest.html)

```python
from sklearn.ensemble import IsolationForest

isolation = IsolationForest(n_estimators=120, random_state=42, n_jobs=1)
isolation.fit(X_train)
report("Isolation Forest", -isolation.score_samples(X_val))
```

### 7. Autoencoder

Mạng học nén đầu vào qua một lớp nhỏ rồi tái tạo đầu vào, với sai số tái tạo làm điểm bất thường. Ví dụ dùng MLP có nút thắt để minh họa, fit scaler và mạng trên giao dịch hợp lệ đã biết trong train (novelty detection có dùng nhãn để lọc tập fit). Khi nhãn chưa đủ và fit trên dữ liệu hỗn hợp, cần đo độ nhạy với tỷ lệ gian lận lẫn trong train. [Hinton và Salakhutdinov, 2006](https://pubmed.ncbi.nlm.nih.gov/16873662/) · [scikit-learn MLPRegressor](https://scikit-learn.org/stable/modules/generated/sklearn.neural_network.MLPRegressor.html)

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
