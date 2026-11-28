# Bảng thống nhất dataset

## Phân tích dataset

Số liệu dưới đây được đọc trực tiếp từ các file gốc trong `data/raw/` (tải từ Kaggle và Hugging Face). Phần này chỉ ghi số liệu, chưa đánh giá hay chọn cột để train.

| | Sparkov | IEEE-CIS | ULB | Kaggle S6E11 | CardHistory |
|---|---:|---:|---:|---:|---:|
| Loại dữ liệu | Mô phỏng | Thực tế (đã ẩn danh) | Thực tế (đã ẩn danh bằng PCA) | Tổng hợp | Mô phỏng |
| Số giao dịch có nhãn | 1.852.394 | 590.540 | 284.807 | 699.960 | 24.937.300 |
| Số giao dịch gian lận | 9.651 | 20.663 | 492 | 11.689 | 105.740 |
| Tỷ lệ gian lận | 0,521% | 3,499% | 0,173% | 1,670% | 0,424% |
| Số cột | 23 | 394 (transaction) + 41 (identity) | 31 | 26 | 19 |
| Có mã thẻ | Có | Không (đã ẩn) | Không | Không | Có |
| Khoảng thời gian | 01/01/2019 – 31/12/2020 (2 năm) | 182 ngày (thời gian tương đối) | 48 giờ (tháng 9/2013) | Chỉ có giờ và thứ | 1991 – 03/2020 |
| Tỷ lệ ô trống | 0% | Nhiều cột thiếu 47–96% (chi tiết bên dưới) | 0% | 0% | 0% |
| License | CC0 (Public Domain) | Luật cuộc thi Kaggle: chỉ phi thương mại, không được phát tán dữ liệu | ODbL (ghi nguồn) | CC BY 4.0 | Apache 2.0 |

---

### 1. Sparkov – Credit Card Transactions Fraud Detection

Nguồn: [kaggle.com/datasets/kartik2112/fraud-detection](https://www.kaggle.com/datasets/kartik2112/fraud-detection). Dữ liệu được sinh bằng công cụ mô phỏng Sparkov.

**Thông số chung**

| Thông số | `fraudTrain.csv` | `fraudTest.csv` | Tổng |
|---|---:|---:|---:|
| Số giao dịch | 1.296.675 | 555.719 | 1.852.394 |
| Số giao dịch gian lận | 7.506 | 2.145 | 9.651 |
| Tỷ lệ gian lận | 0,579% | 0,386% | 0,521% |
| Khoảng thời gian | 01/01/2019 00:00 – 21/06/2020 12:13 | 21/06/2020 12:14 – 31/12/2020 23:59 | |
| Số thẻ (`cc_num`) khác nhau | 983 | 924 | |
| Số thẻ có ít nhất 1 giao dịch gian lận | 762 | 218 | |
| Số điểm bán (`merchant`) khác nhau | 693 | 693 | |
| Số danh mục (`category`) | 14 | 14 | |
| Số tiểu bang (`state`) | 51 | 50 | |
| Số tiền (`amt`, USD) nhỏ nhất – lớn nhất | 1,00 – 28.948,90 | 1,00 – 22.768,10 | |
| Tỷ lệ ô trống | 0% | 0% | |
| Dung lượng file | 351 MB | 150 MB | 501 MB |

**Ý nghĩa các cột**

| Tên cột | Ý nghĩa |
|---|---|
| (cột không tên) | Số thứ tự dòng trong file (0, 1, 2, …) |
| `trans_date_trans_time` | Ngày giờ giao dịch |
| `cc_num` | Số thẻ tín dụng (định danh thẻ) |
| `merchant` | Tên điểm bán (tên giả, có tiền tố `fraud_`) |
| `category` | Danh mục giao dịch, 14 loại: `entertainment`, `food_dining`, `gas_transport`, `grocery_net`, `grocery_pos`, `health_fitness`, `home`, `kids_pets`, `misc_net`, `misc_pos`, `personal_care`, `shopping_net`, `shopping_pos`, `travel` (`_net`: mua online, `_pos`: mua tại quầy) |
| `amt` | Số tiền giao dịch (USD) |
| `first` | Tên chủ thẻ |
| `last` | Họ chủ thẻ |
| `gender` | Giới tính chủ thẻ (`F`/`M`) |
| `street` | Địa chỉ nhà chủ thẻ |
| `city` | Thành phố của chủ thẻ |
| `state` | Tiểu bang của chủ thẻ (mã 2 chữ cái) |
| `zip` | Mã bưu chính của chủ thẻ |
| `lat` | Vĩ độ nơi ở của chủ thẻ |
| `long` | Kinh độ nơi ở của chủ thẻ |
| `city_pop` | Dân số thành phố của chủ thẻ |
| `job` | Nghề nghiệp chủ thẻ |
| `dob` | Ngày sinh chủ thẻ |
| `trans_num` | Mã giao dịch (duy nhất cho mỗi giao dịch) |
| `unix_time` | Thời điểm giao dịch dạng Unix timestamp (số giây) |
| `merch_lat` | Vĩ độ điểm bán |
| `merch_long` | Kinh độ điểm bán |
| `is_fraud` | Nhãn: 1 = gian lận, 0 = bình thường |

**5 giao dịch đầu tiên (`fraudTrain.csv`)**

| Cột | GD 1 | GD 2 | GD 3 | GD 4 | GD 5 |
|---|---|---|---|---|---|
| (cột không tên) | 0 | 1 | 2 | 3 | 4 |
| `trans_date_trans_time` | 2019-01-01 00:00:18 | 2019-01-01 00:00:44 | 2019-01-01 00:00:51 | 2019-01-01 00:01:16 | 2019-01-01 00:03:06 |
| `cc_num` | 2703186189652095 | 630423337322 | 38859492057661 | 3534093764340240 | 375534208663984 |
| `merchant` | fraud_Rippin, Kub and Mann | fraud_Heller, Gutmann and Zieme | fraud_Lind-Buckridge | fraud_Kutch, Hermiston and Farrell | fraud_Keeling-Crist |
| `category` | misc_net | grocery_pos | entertainment | gas_transport | misc_pos |
| `amt` | 4.97 | 107.23 | 220.11 | 45.0 | 41.96 |
| `first` | Jennifer | Stephanie | Edward | Jeremy | Tyler |
| `last` | Banks | Gill | Sanchez | White | Garcia |
| `gender` | F | F | M | M | M |
| `street` | 561 Perry Cove | 43039 Riley Greens Suite 393 | 594 White Dale Suite 530 | 9443 Cynthia Court Apt. 038 | 408 Bradley Rest |
| `city` | Moravian Falls | Orient | Malad City | Boulder | Doe Hill |
| `state` | NC | WA | ID | MT | VA |
| `zip` | 28654 | 99160 | 83252 | 59632 | 24433 |
| `lat` | 36.0788 | 48.8878 | 42.1808 | 46.2306 | 38.4207 |
| `long` | -81.1781 | -118.2105 | -112.262 | -112.1138 | -79.4629 |
| `city_pop` | 3495 | 149 | 4154 | 1939 | 99 |
| `job` | Psychologist, counselling | Special educational needs teacher | Nature conservation officer | Patent attorney | Dance movement psychotherapist |
| `dob` | 1988-03-09 | 1978-06-21 | 1962-01-19 | 1967-01-12 | 1986-03-28 |
| `trans_num` | 0b242abb623afc578575680df30655b9 | 1f76529f8574734946361c461b024d99 | a1a22d70485983eac12b5b88dad1cf95 | 6b849c168bdad6f867558c3793159a81 | a41d7549acf90789359a9aa5346dcb46 |
| `unix_time` | 1325376018 | 1325376044 | 1325376051 | 1325376076 | 1325376186 |
| `merch_lat` | 36.011293 | 49.159046999999994 | 43.150704 | 47.034331 | 38.674999 |
| `merch_long` | -82.048315 | -118.186462 | -112.154481 | -112.561071 | -78.632459 |
| `is_fraud` | 0 | 0 | 0 | 0 | 0 |

---

### 2. IEEE-CIS Fraud Detection

Nguồn: [kaggle.com/competitions/ieee-fraud-detection](https://www.kaggle.com/competitions/ieee-fraud-detection/data). Dữ liệu giao dịch thật do Vesta Corporation cung cấp, phần lớn tên và ý nghĩa cột đã bị ẩn.

**Thông số chung**

| File | Số dòng | Số cột | Có nhãn | Dung lượng |
|---|---:|---:|---|---:|
| `train_transaction.csv` | 590.540 | 394 | Có (`isFraud`) | 683 MB |
| `train_identity.csv` | 144.233 | 41 | Không (nối bằng `TransactionID`) | 27 MB |
| `test_transaction.csv` | 506.691 | 393 | Không | 613 MB |
| `test_identity.csv` | 141.907 | 41 | Không | 26 MB |
| `sample_submission.csv` | 506.691 | 2 | Mẫu file nộp | 6 MB |

| Thông số (tập train) | Giá trị |
|---|---:|
| Số giao dịch gian lận | 20.663 |
| Tỷ lệ gian lận | 3,499% |
| Số giao dịch có thông tin thiết bị (`train_identity`) | 144.233 (24,4%) |
| Tỷ lệ gian lận khi có thông tin thiết bị | 7,85% |
| Tỷ lệ gian lận khi không có thông tin thiết bị | 2,09% |
| `TransactionDT` nhỏ nhất – lớn nhất | 86.400 – 15.811.131 giây (182 ngày) |
| Khoảng cách từ cuối tập train tới đầu tập test | 30 ngày |
| Số tiền (`TransactionAmt`, USD) nhỏ nhất – lớn nhất | 0,251 – 31.937,39 |

**Tỷ lệ ô trống theo nhóm cột (tập train)**

| Nhóm cột | Số cột | Ô trống thấp nhất | Trung vị | Cao nhất |
|---|---:|---:|---:|---:|
| `TransactionID`, `TransactionDT`, `TransactionAmt`, `ProductCD`, `card1` | 5 | 0% | 0% | 0% |
| `card2`–`card6` | 5 | 0,27% | 0,27% | 1,51% |
| `addr1`, `addr2` | 2 | 11,13% | 11,13% | 11,13% |
| `dist1`, `dist2` | 2 | 59,65% | | 93,63% |
| `P_emaildomain`, `R_emaildomain` | 2 | 15,99% | | 76,75% |
| `C1`–`C14` | 14 | 0% | 0% | 0% |
| `D1`–`D15` | 15 | 0,21% | 52,47% | 93,41% |
| `M1`–`M9` | 9 | 28,68% | 47,66% | 59,35% |
| `V1`–`V339` | 339 | 0% | 47,29% | 86,12% |
| `id_01`–`id_38`, `DeviceType`, `DeviceInfo` (trong 144.233 dòng identity) | 40 | 0% | | 96,71% |

**Ý nghĩa các cột – file transaction**

| Tên cột | Ý nghĩa |
|---|---|
| `TransactionID` | Mã giao dịch, dùng để nối với file identity |
| `isFraud` | Nhãn: 1 = gian lận, 0 = bình thường (chỉ có ở tập train) |
| `TransactionDT` | Số giây tính từ một mốc thời gian không công bố (không phải ngày giờ thật) |
| `TransactionAmt` | Số tiền giao dịch (USD) |
| `ProductCD` | Mã loại sản phẩm/dịch vụ, 5 giá trị: `W`, `C`, `R`, `H`, `S` |
| `card1` | Thông tin thẻ đã ẩn (dạng mã số, hơn 2.000 giá trị) |
| `card2` | Thông tin thẻ đã ẩn (500 giá trị) |
| `card3` | Thông tin thẻ đã ẩn (114 giá trị) |
| `card4` | Hãng thẻ: `visa`, `mastercard`, `american express`, `discover` |
| `card5` | Thông tin thẻ đã ẩn (119 giá trị) |
| `card6` | Loại thẻ: `debit`, `credit`, `debit or credit`, `charge card` |
| `addr1` | Mã vùng thanh toán (đã ẩn) |
| `addr2` | Mã quốc gia thanh toán (đã ẩn) |
| `dist1`, `dist2` | Khoảng cách (ví dụ giữa địa chỉ thanh toán, địa chỉ giao hàng, vị trí IP…) |
| `P_emaildomain` | Tên miền email của người mua (`gmail.com`, `yahoo.com`, …) |
| `R_emaildomain` | Tên miền email của người nhận |
| `C1`–`C14` | Các bộ đếm (ví dụ số địa chỉ liên quan tới thẻ). Ý nghĩa cụ thể bị ẩn |
| `D1`–`D15` | Khoảng thời gian (ngày) kể từ một sự kiện trước đó, ví dụ từ giao dịch trước. Ý nghĩa cụ thể bị ẩn |
| `M1`–`M9` | Kết quả khớp thông tin (ví dụ tên trên thẻ và địa chỉ). Giá trị `T`/`F`, riêng `M4` là `M0`/`M1`/`M2` |
| `V1`–`V339` | Đặc trưng do Vesta tự tạo (đếm, xếp hạng, quan hệ giữa các giá trị). Ý nghĩa bị ẩn |

**Ý nghĩa các cột – file identity**

| Tên cột | Ý nghĩa |
|---|---|
| `TransactionID` | Mã giao dịch, dùng để nối với file transaction |
| `id_01`–`id_11` | Thông số dạng số về mạng và thiết bị (đã ẩn), ví dụ điểm tin cậy, số lần thay đổi |
| `id_12`–`id_29` | Thông tin dạng danh mục về mạng và thiết bị (đã ẩn), ví dụ `Found`/`NotFound`/`New` |
| `id_30` | Hệ điều hành (`Windows 10`, `iOS 11.2.1`, `Android 7.0`, …) |
| `id_31` | Trình duyệt (`chrome 63.0`, `mobile safari 11.0`, …) |
| `id_32` | Độ sâu màu màn hình (24, 32, …) |
| `id_33` | Độ phân giải màn hình (`1920x1080`, …) |
| `id_34` | Trạng thái khớp (`match_status:-1` đến `match_status:2`) |
| `id_35`–`id_38` | Cờ `T`/`F` (ý nghĩa bị ẩn) |
| `DeviceType` | Loại thiết bị: `desktop`, `mobile` |
| `DeviceInfo` | Tên thiết bị (`Windows`, `iOS Device`, `MacOS`, …), 1.786 giá trị |

Lưu ý: trong `test_identity.csv` tên cột viết `id-01`, `id-02`, … (gạch ngang), trong `train_identity.csv` viết `id_01`, `id_02`, … (gạch dưới).

**5 giao dịch đầu tiên**

Không đưa vào tài liệu này. Luật cuộc thi IEEE-CIS cấm sao chép hoặc công bố dữ liệu cho người không tham gia cuộc thi, và repo đang ở chế độ public. Mỗi thành viên tự join cuộc thi và xem dữ liệu trên máy của mình.

---

### 3. ULB – Credit Card Fraud Detection

Nguồn: [kaggle.com/datasets/mlg-ulb/creditcardfraud](https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud). Giao dịch thẻ thật của chủ thẻ châu Âu trong 2 ngày tháng 9/2013, các thông tin gốc đã được biến đổi bằng PCA.

**Thông số chung**

| Thông số | Giá trị |
|---|---:|
| Số giao dịch | 284.807 |
| Số giao dịch gian lận | 492 |
| Tỷ lệ gian lận | 0,173% |
| Số cột | 31 |
| Tỷ lệ ô trống | 0% |
| Số dòng trùng nhau hoàn toàn | 1.081 (trong đó 19 dòng gian lận) |
| `Time` nhỏ nhất – lớn nhất | 0 – 172.792 giây (48 giờ) |
| Ngày 1: số giao dịch / gian lận | 144.786 / 281 (0,194%) |
| Ngày 2: số giao dịch / gian lận | 140.021 / 211 (0,151%) |
| `Amount` (EUR): nhỏ nhất / trung vị / trung bình / lớn nhất | 0 / 22,00 / 88,35 / 25.691,16 |
| `Amount` của giao dịch gian lận: trung vị / trung bình / lớn nhất | 9,21 / 122,21 / 2.125,87 |
| Số giao dịch có `Amount` = 0 | 1.825 (trong đó 27 gian lận) |
| Dung lượng file | 151 MB |

**Ý nghĩa các cột**

| Tên cột | Ý nghĩa |
|---|---|
| `Time` | Số giây tính từ giao dịch đầu tiên trong dataset |
| `V1`–`V28` | Các thành phần PCA: thông tin gốc của giao dịch đã được biến đổi để ẩn danh. Không công bố cột nào ứng với thông tin gì |
| `Amount` | Số tiền giao dịch (EUR) |
| `Class` | Nhãn: 1 = gian lận, 0 = bình thường |

**Thống kê `V1`–`V28` (toàn bộ dữ liệu)**

Trung bình của nhóm gian lận và nhóm bình thường, cùng độ lệch chuẩn của toàn bộ dữ liệu. Mọi cột `V` có trung bình toàn bộ bằng 0.

| Cột | Độ lệch chuẩn | TB nhóm gian lận | TB nhóm bình thường |
|---|---:|---:|---:|
| `V1` | 1,959 | −4,772 | +0,008 |
| `V2` | 1,651 | +3,624 | −0,006 |
| `V3` | 1,516 | −7,033 | +0,012 |
| `V4` | 1,416 | +4,542 | −0,008 |
| `V5` | 1,380 | −3,151 | +0,005 |
| `V6` | 1,332 | −1,398 | +0,002 |
| `V7` | 1,237 | −5,569 | +0,010 |
| `V8` | 1,194 | +0,571 | −0,001 |
| `V9` | 1,099 | −2,581 | +0,004 |
| `V10` | 1,089 | −5,677 | +0,010 |
| `V11` | 1,021 | +3,800 | −0,007 |
| `V12` | 0,999 | −6,259 | +0,011 |
| `V13` | 0,995 | −0,109 | +0,000 |
| `V14` | 0,959 | −6,972 | +0,012 |
| `V15` | 0,915 | −0,093 | +0,000 |
| `V16` | 0,876 | −4,140 | +0,007 |
| `V17` | 0,849 | −6,666 | +0,012 |
| `V18` | 0,838 | −2,246 | +0,004 |
| `V19` | 0,814 | +0,681 | −0,001 |
| `V20` | 0,771 | +0,372 | −0,001 |
| `V21` | 0,735 | +0,714 | −0,001 |
| `V22` | 0,726 | +0,014 | −0,000 |
| `V23` | 0,624 | −0,040 | +0,000 |
| `V24` | 0,606 | −0,105 | +0,000 |
| `V25` | 0,521 | +0,041 | −0,000 |
| `V26` | 0,482 | +0,052 | −0,000 |
| `V27` | 0,404 | +0,171 | −0,000 |
| `V28` | 0,330 | +0,076 | −0,000 |

**Tỷ lệ gian lận theo giờ** (giờ = `(Time // 3600) % 24`, tính từ giao dịch đầu tiên)

| Giờ | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Số GD | 7.695 | 4.220 | 3.328 | 3.492 | 2.209 | 2.990 | 4.101 | 7.243 | 10.276 | 15.838 | 16.598 | 16.856 |
| % gian lận | 0,08 | 0,24 | 1,71 | 0,49 | 1,04 | 0,37 | 0,22 | 0,32 | 0,09 | 0,10 | 0,05 | 0,31 |

| Giờ | 12 | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| Số GD | 15.420 | 15.365 | 16.570 | 16.461 | 16.453 | 16.166 | 17.039 | 15.649 | 16.756 | 17.703 | 15.441 | 10.938 |
| % gian lận | 0,11 | 0,11 | 0,14 | 0,16 | 0,13 | 0,18 | 0,19 | 0,12 | 0,11 | 0,09 | 0,06 | 0,19 |

**5 giao dịch đầu tiên** (giá trị `V1`–`V28` làm tròn 4 chữ số thập phân)

| Cột | GD 1 | GD 2 | GD 3 | GD 4 | GD 5 |
|---|---|---|---|---|---|
| `Time` | 0 | 0 | 1 | 1 | 2 |
| `V1` | -1.3598 | 1.1919 | -1.3584 | -0.9663 | -1.1582 |
| `V2` | -0.0728 | 0.2662 | -1.3402 | -0.1852 | 0.8777 |
| `V3` | 2.5363 | 0.1665 | 1.7732 | 1.7930 | 1.5487 |
| `V4` | 1.3782 | 0.4482 | 0.3798 | -0.8633 | 0.4030 |
| `V5` | -0.3383 | 0.0600 | -0.5032 | -0.0103 | -0.4072 |
| `V6` | 0.4624 | -0.0824 | 1.8005 | 1.2472 | 0.0959 |
| `V7` | 0.2396 | -0.0788 | 0.7915 | 0.2376 | 0.5929 |
| `V8` | 0.0987 | 0.0851 | 0.2477 | 0.3774 | -0.2705 |
| `V9` | 0.3638 | -0.2554 | -1.5147 | -1.3870 | 0.8177 |
| `V10` | 0.0908 | -0.1670 | 0.2076 | -0.0550 | 0.7531 |
| `V11` | -0.5516 | 1.6127 | 0.6245 | -0.2265 | -0.8228 |
| `V12` | -0.6178 | 1.0652 | 0.0661 | 0.1782 | 0.5382 |
| `V13` | -0.9914 | 0.4891 | 0.7173 | 0.5078 | 1.3459 |
| `V14` | -0.3112 | -0.1438 | -0.1659 | -0.2879 | -1.1197 |
| `V15` | 1.4682 | 0.6356 | 2.3459 | -0.6314 | 0.1751 |
| `V16` | -0.4704 | 0.4639 | -2.8901 | -1.0596 | -0.4514 |
| `V17` | 0.2080 | -0.1148 | 1.1100 | -0.6841 | -0.2370 |
| `V18` | 0.0258 | -0.1834 | -0.1214 | 1.9658 | -0.0382 |
| `V19` | 0.4040 | -0.1458 | -2.2619 | -1.2326 | 0.8035 |
| `V20` | 0.2514 | -0.0691 | 0.5250 | -0.2080 | 0.4085 |
| `V21` | -0.0183 | -0.2258 | 0.2480 | -0.1083 | -0.0094 |
| `V22` | 0.2778 | -0.6387 | 0.7717 | 0.0053 | 0.7983 |
| `V23` | -0.1105 | 0.1013 | 0.9094 | -0.1903 | -0.1375 |
| `V24` | 0.0669 | -0.3398 | -0.6893 | -1.1756 | 0.1413 |
| `V25` | 0.1285 | 0.1672 | -0.3276 | 0.6474 | -0.2060 |
| `V26` | -0.1891 | 0.1259 | -0.1391 | -0.2219 | 0.5023 |
| `V27` | 0.1336 | -0.0090 | -0.0554 | 0.0627 | 0.2194 |
| `V28` | -0.0211 | 0.0147 | -0.0598 | 0.0615 | 0.2152 |
| `Amount` | 149.62 | 2.69 | 378.66 | 123.5 | 69.99 |
| `Class` | 0 | 0 | 0 | 0 | 0 |

---

### 4. Kaggle Playground Series S6E11 – Predicting Credit Card Fraud

Nguồn: [kaggle.com/competitions/playground-series-s6e11](https://www.kaggle.com/competitions/playground-series-s6e11/data). Dữ liệu tổng hợp do Kaggle sinh ra từ bộ "Credit Card Fraud Detection 2026". License: CC BY 4.0.

**Thông số chung**

| File | Số dòng | Số cột | Có nhãn | Dung lượng |
|---|---:|---:|---|---:|
| `train.csv` | 699.960 | 26 | Có (`is_fraud`) | 99 MB |
| `test.csv` | 299.984 | 25 | Không | 41 MB |
| `sample_submission.csv` | 299.984 | 2 | Mẫu file nộp | 8 MB |

| Thông số (tập train) | Giá trị |
|---|---:|
| Số giao dịch gian lận | 11.689 |
| Tỷ lệ gian lận | 1,670% |
| Tỷ lệ ô trống | 0% |
| Số dòng trùng nhau (không tính `id`) | 0 |
| Số cột dạng số | 13 |
| Số cột dạng danh mục / đúng-sai | 11 |
| Thước đo của cuộc thi | ROC AUC |
| Hạn nộp | 30/11/2026 |

**Ý nghĩa các cột**

| Tên cột | Ý nghĩa |
|---|---|
| `id` | Mã dòng |
| `amount_usd` | Số tiền giao dịch (USD) |
| `hours_since_last_txn` | Số giờ từ giao dịch trước của khách hàng |
| `txn_count_last_24h` | Số giao dịch trong 24 giờ trước |
| `distance_from_home_km` | Khoảng cách từ nơi ở tới nơi giao dịch (km) |
| `card_age_months` | Tuổi của thẻ (tháng) |
| `customer_age` | Tuổi khách hàng |
| `account_balance_usd` | Số dư tài khoản (USD) |
| `cvv_retry_count` | Số lần nhập lại mã CVV |
| `velocity_score` | Điểm tốc độ giao dịch |
| `time_of_day_hour` | Giờ trong ngày (0–23) |
| `day_of_week` | Thứ trong tuần (0–6) |
| `merchant_risk_score` | Điểm rủi ro của điểm bán (0–100) |
| `prior_disputes` | Số lần khiếu nại trước đây |
| `merchant_category` | Ngành hàng của điểm bán (12 loại) |
| `card_type` | Hãng thẻ: Visa, Mastercard, Amex, RuPay, Discover |
| `auth_method` | Cách xác thực: 3D Secure, OTP, PIN, Biometric, No Authentication |
| `channel` | Kênh giao dịch: Online, POS, Contactless, In-App, ATM |
| `device_type` | Thiết bị (8 loại) |
| `is_foreign_transaction` | Giao dịch nước ngoài |
| `is_new_merchant` | Lần đầu mua ở điểm bán này |
| `used_vpn` | Có dùng VPN |
| `ip_country_mismatch` | Quốc gia của địa chỉ IP khác quốc gia của thẻ |
| `billing_shipping_mismatch` | Địa chỉ thanh toán khác địa chỉ giao hàng |
| `is_ai_generated_scam_attempt` | Được gắn cờ là lừa đảo do AI tạo |
| `is_fraud` | Nhãn: 1 = gian lận, 0 = bình thường (lưu dạng `0.0` / `1.0`) |

**Thống kê các cột số (tập train)**

| Cột | Nhỏ nhất | Trung vị | Trung bình | Lớn nhất | Số giá trị khác nhau | Trung vị nhóm gian lận | Trung vị nhóm bình thường |
|---|---:|---:|---:|---:|---:|---:|---:|
| `amount_usd` | 1 | 27,25 | 79,89 | 6.872,69 | 13.387 | 31,18 | 27,21 |
| `hours_since_last_txn` | 0,01 | 4,73 | 6,63 | 51,98 | 3.633 | 3,61 | 4,73 |
| `txn_count_last_24h` | 0 | 3 | 2,98 | 11 | 12 | 4 | 3 |
| `distance_from_home_km` | 0 | 10,22 | 13,59 | 57,93 | 4.365 | 10,31 | 10,22 |
| `card_age_months` | 25 | 47 | 46,86 | 73 | 49 | 47 | 47 |
| `customer_age` | 18 | 52 | 51,43 | 81 | 64 | 61 | 52 |
| `account_balance_usd` | 58,25 | 1.382,74 | 2.065,00 | 99.701,40 | 43.317 | 1.396,00 | 1.382,74 |
| `cvv_retry_count` | 0 | 0 | 0,09 | 3 | 4 | 0 | 0 |
| `velocity_score` | 0 | 18,6 | 18,93 | 72,9 | 666 | 26,6 | 18,5 |
| `time_of_day_hour` | 0 | 12 | 11,76 | 23 | 24 | 12 | 12 |
| `day_of_week` | 0 | 3 | 2,98 | 6 | 7 | 3 | 3 |
| `merchant_risk_score` | 0 | 34,2 | 35,22 | 100 | 950 | 45,9 | 34,0 |
| `prior_disputes` | 0 | 0 | 0,15 | 4 | 5 | 0 | 0 |

**Số giao dịch và tỷ lệ gian lận theo giá trị (tập train)**

| Cột | Giá trị: số giao dịch / tỷ lệ gian lận |
|---|---|
| `cvv_retry_count` | 0: 642.088 / 0,93% · 1: 55.942 / 8,75% · 2: 1.905 / 41,73% · 3: 25 / 36,00% |
| `txn_count_last_24h` | 0: 18.462 / 0,23% · 1: 92.705 / 0,69% · 2: 170.757 / 1,28% · 3: 178.367 / 1,66% · 4: 131.869 / 1,98% · 5: 69.701 / 2,59% · 6: 26.488 / 3,51% · 7: 8.907 / 4,36% · 8: 2.252 / 3,95% · 9: 378 / 5,82% · 10: 65 / 12,31% · 11: 9 / 22,22% |
| `prior_disputes` | 0: 598.396 / 1,55% · 1: 96.365 / 2,36% · 2: 5.032 / 3,00% · 3: 165 / 3,64% · 4: 2 / 0,00% |
| `merchant_category` | Online Retail: 155.097 / 1,11% · Groceries: 142.578 / 1,11% · Restaurants: 101.360 / 1,14% · Fuel: 59.880 / 1,24% · Electronics: 48.693 / 3,08% · Streaming: 47.196 / 2,25% · Utilities: 42.027 / 1,38% · Healthcare: 35.889 / 1,29% · Travel: 28.715 / 1,86% · Gaming: 23.784 / 5,51% · Gift Cards: 9.456 / 7,30% · Crypto Exchange: 5.285 / 6,53% |
| `card_type` | Visa: 345.001 / 1,70% · Mastercard: 254.857 / 1,60% · Amex: 45.797 / 1,90% · RuPay: 37.070 / 1,68% · Discover: 17.235 / 1,46% |
| `auth_method` | 3D Secure: 210.036 / 1,47% · OTP: 175.178 / 1,41% · PIN: 154.020 / 0,87% · Biometric: 93.666 / 0,50% · No Authentication: 67.060 / 6,44% |
| `channel` | Online: 273.939 / 1,74% · POS: 206.465 / 1,66% · Contactless: 105.620 / 1,55% · In-App: 83.716 / 1,63% · ATM: 30.220 / 1,59% |
| `device_type` | Android Phone: 237.454 / 1,61% · iPhone: 164.691 / 1,72% · POS Terminal: 113.237 / 1,73% · Windows PC: 80.934 / 1,61% · Mac: 33.973 / 1,71% · Tablet: 27.688 / 1,70% · Smart Watch: 21.106 / 1,70% · ATM Machine: 20.877 / 1,70% |
| `is_foreign_transaction` | False: 687.862 / 1,48% · True: 12.098 / 12,57% |
| `is_new_merchant` | False: 593.240 / 1,12% · True: 106.720 / 4,73% |
| `used_vpn` | False: 676.295 / 1,50% · True: 23.665 / 6,55% |
| `ip_country_mismatch` | False: 688.648 / 1,43% · True: 11.312 / 16,50% |
| `billing_shipping_mismatch` | False: 690.906 / 1,52% · True: 9.054 / 12,99% |
| `is_ai_generated_scam_attempt` | False: 697.661 / 1,63% · True: 2.299 / 15,22% |
| `time_of_day_hour` | 24 giá trị, tỷ lệ gian lận từ 1,44% đến 1,83% |
| `day_of_week` | 7 giá trị, tỷ lệ gian lận từ 1,58% đến 1,78% |

**5 giao dịch đầu tiên (`train.csv`)**

| Cột | GD 1 | GD 2 | GD 3 | GD 4 | GD 5 |
|---|---|---|---|---|---|
| `id` | 0 | 1 | 2 | 3 | 4 |
| `amount_usd` | 61.16 | 24.83 | 6.36 | 37.44 | 653.85 |
| `hours_since_last_txn` | 9.77 | 1.54 | 1.2 | 5.13 | 0.8 |
| `txn_count_last_24h` | 1 | 3 | 4 | 4 | 4 |
| `distance_from_home_km` | 17.78 | 13.06 | 8.17 | 8.67 | 11.69 |
| `card_age_months` | 48 | 38 | 50 | 48 | 37 |
| `customer_age` | 56 | 28 | 55 | 48 | 52 |
| `account_balance_usd` | 1269.35 | 3233.0 | 1046.88 | 2217.67 | 3291.06 |
| `cvv_retry_count` | 0 | 0 | 0 | 0 | 0 |
| `velocity_score` | 5.5 | 33.4 | 35.8 | 20.7 | 34.8 |
| `time_of_day_hour` | 17 | 23 | 15 | 7 | 4 |
| `day_of_week` | 3 | 5 | 0 | 3 | 4 |
| `merchant_risk_score` | 29.2 | 29.9 | 24.1 | 41.9 | 48.0 |
| `prior_disputes` | 0 | 1 | 0 | 0 | 0 |
| `merchant_category` | Groceries | Online Retail | Utilities | Groceries | Electronics |
| `card_type` | Mastercard | Visa | Visa | Mastercard | Visa |
| `auth_method` | OTP | PIN | OTP | 3D Secure | 3D Secure |
| `channel` | POS | In-App | Online | POS | Online |
| `device_type` | iPhone | Android Phone | Tablet | Android Phone | Windows PC |
| `is_foreign_transaction` | False | False | False | False | False |
| `is_new_merchant` | False | False | False | False | False |
| `used_vpn` | False | False | True | False | False |
| `ip_country_mismatch` | False | False | False | False | False |
| `billing_shipping_mismatch` | False | False | False | False | False |
| `is_ai_generated_scam_attempt` | False | False | False | False | False |
| `is_fraud` | 0.0 | 0.0 | 0.0 | 0.0 | 0.0 |


---

### 5. CardHistory-Fraud (Toloka, dựa trên IBM TabFormer)

Nguồn: [huggingface.co/datasets/toloka/CardHistory-Fraud](https://huggingface.co/datasets/toloka/CardHistory-Fraud). Dữ liệu mô phỏng: giao dịch gốc của IBM TabFormer, cộng thêm 7 kiểu gian lận, các giao dịch hợp lệ giống gian lận (du lịch, đăng ký dịch vụ mới) và phản ứng của ngân hàng (khoá thẻ, từ chối, cấp thẻ mới). License: Apache 2.0 (ghi nguồn Toloka và IBM).

**Thông số chung**

| Thông số | Giá trị |
|---|---:|
| Số giao dịch | 24.937.300 |
| Số giao dịch gian lận | 105.740 |
| Tỷ lệ gian lận | 0,424% |
| Trong đó gian lận gốc của IBM | 29.520 |
| Số chủ thẻ / số thẻ | 2.000 / 6.139 |
| Số điểm bán (`merchant_id`) khác nhau | 99.890 |
| Khoảng thời gian | 1991 – 03/2020 |
| Số cột | 19 |
| Tỷ lệ ô trống | 0% |
| File dữ liệu | 13 file `data/part-*.parquet` (297 MB), `episodes.parquet`, `reissues.parquet` |
| Thứ tự dòng | Theo thẻ, rồi theo thời gian |

**Chia tập có sẵn (cột `split`)**

| Tập | Phạm vi | Số giao dịch | Số gian lận | Tỷ lệ gian lận | Số thẻ |
|---|---|---:|---:|---:|---:|
| train | Trước 2018, cộng 01–06/2018 của 80% số thẻ | 21.766.782 | 92.822 | 0,426% | 4.833 |
| validation | 01–06/2018 của 20% số thẻ còn lại | 165.592 | 796 | 0,481% | 786 |
| test | 07/2018 – 03/2020 | 3.004.926 | 12.122 | 0,403% | 5.205 |

**Số giao dịch theo kiểu (cột `scenario`)**

| Kiểu | Gian lận? | Số giao dịch | Trong tập test |
|---|---|---:|---:|
| legit | Không | 24.007.499 | 2.885.672 |
| legit domestic trip | Không | 446.047 | 58.182 |
| legit trip abroad | Không | 263.797 | 33.839 |
| legit new subscription | Không | 114.217 | 15.111 |
| attempt on a blocked card | Có | 33.551 | 3.811 |
| IBM's original fraud | Có | 29.520 | 3.359 |
| network testing wave: probe | Có | 12.158 | 1.043 |
| stolen card | Có | 6.440 | 866 |
| card-testing burst | Có | 6.025 | 801 |
| counterfeit card | Có | 5.499 | 782 |
| breached merchant | Có | 3.443 | 418 |
| fraudulent recurring charge | Có | 3.111 | 377 |
| distributed testing: probe | Có | 3.064 | 380 |
| network testing wave: purchase | Có | 2.149 | 191 |
| distributed testing: purchase | Có | 780 | 94 |

**Số giao dịch theo nguồn gốc (cột `origin`)**

| `origin` | Ý nghĩa | Số giao dịch | Số gian lận | Tỷ lệ gian lận |
|---|---|---:|---:|---:|
| `ibm` | Dòng gốc của IBM, giữ nguyên | 24.007.364 | 29.520 | 0,123% |
| `added` | Dòng do bộ sinh dữ liệu thêm vào | 636.338 | 76.220 | 11,978% |
| `ibm_moved_by_trip` | Dòng IBM bị đổi địa điểm do chuyến đi | 274.110 | 0 | 0% |
| `ibm_declined_by_bank` | Dòng IBM bị từ chối vì thẻ đã khoá | 14.105 | 0 | 0% |
| `ibm_retimed_after_trip` | Dòng IBM bị dời giờ vì chủ thẻ chưa về | 5.383 | 0 | 0% |

**Ý nghĩa các cột**

| Tên cột | Ý nghĩa |
|---|---|
| `row_id` | Vị trí dòng trong dataset (theo thẻ, rồi theo thời gian) |
| `user` | Mã chủ thẻ |
| `card_index` | Số thứ tự thẻ của chủ thẻ |
| `card` | Mã thẻ, `card = user × 10 + card_index`. Thẻ được cấp lại vẫn giữ mã này |
| `timestamp` | Ngày giờ giao dịch theo giờ địa phương (đến phút, không có múi giờ) |
| `amount` | Số tiền (USD); số âm là hoàn tiền |
| `use_chip` | Cách thanh toán: Chip Transaction, Swipe Transaction, Online Transaction |
| `mcc` | Mã ngành hàng của điểm bán (merchant category code) |
| `merchant_id` | Mã điểm bán (đã ẩn danh) |
| `merchant_city` | Thành phố của điểm bán; giao dịch online có giá trị `" ONLINE"` |
| `merchant_state` | Tiểu bang của điểm bán; giao dịch nước ngoài ghi tên nước; giao dịch online để trống |
| `errors` | Mã lỗi / mã từ chối, ví dụ `Bad CVV,`, `Card Blocked,`; trống = không có lỗi |
| `is_fraud` | Nhãn: 1 = gian lận, 0 = bình thường |
| `scenario_id`, `scenario` | Kiểu gian lận hoặc kiểu giao dịch hợp lệ giống gian lận (0 = giao dịch thường) |
| `origin` | Nguồn gốc của dòng (bảng ở trên) |
| `split` | `train`, `validation` hoặc `test` |
| `episode` | Mã vụ gian lận được thêm vào (−1 = không thuộc vụ nào), nối với `episodes.parquet` |
| `is_probe` | Có phải giao dịch thử thẻ số tiền nhỏ của kẻ gian không |

**File phụ**

| File | Số dòng | Cột | Nội dung |
|---|---:|---|---|
| `episodes.parquet` | 15.500 | `episode`, `card`, `kind`, `compromised_at`, `stolen_at` | Mỗi dòng là một vụ gian lận được thêm vào. Số vụ theo loại: network testing wave 8.211, breached merchant 3.607, distributed testing 1.008, stolen card 981, card-testing burst 958, counterfeit card 735 |
| `reissues.parquet` | 5.973 | `card`, `exposed_at`, `new_card_active_at` | Thẻ được ngân hàng cấp lại sau khi điểm bán bị lộ dữ liệu |

**Số giao dịch và tỷ lệ gian lận theo giá trị (toàn bộ dữ liệu)**

| Cột | Giá trị: số giao dịch / tỷ lệ gian lận |
|---|---|
| `use_chip` | Swipe: 15.629.136 / 0,177% · Chip: 6.410.514 / 0,174% · Online: 2.897.650 / 2,312% |
| `errors` | (trống): 24.466.074 / 0,239% · Insufficient Balance: 247.655 / 0,969% · Bad PIN: 59.828 / 0,537% · Technical Glitch: 48.897 / 0,213% · Do Not Honor: 26.704 / 49,363% · Suspected Fraud: 22.435 / 37,994% · Bad Card Number: 15.815 / 15,403% · Card Blocked: 15.679 / 71,414% · Bad CVV: 14.355 / 26,555% · Bad Expiration: 13.193 / 18,889% · Stolen Card: 2.822 / 98,831% · Bad Zipcode: 2.101 / 0,048% |
| `amount` (USD) | ≤ 0: 1.270.143 / 0,431% · 0–1: 447.357 / 1,374% · 1–5: 2.804.572 / 0,674% · 5–20: 5.589.308 / 0,210% · 20–50: 6.277.881 / 0,189% · 50–100: 5.806.131 / 0,284% · 100–200: 2.106.159 / 0,800% · 200–500: 543.691 / 3,061% · > 500: 92.058 / 1,813% |
| `mcc` (15 mã nhiều giao dịch nhất) | 5411: 2.922.490 / 0,228% · 5499: 2.704.894 / 0,061% · 5541: 2.678.522 / 0,161% · 5812: 1.855.427 / 0,073% · 5912: 1.430.501 / 0,320% · 5300: 1.136.197 / 0,516% · 4829: 1.130.187 / 0,238% · 4784: 1.124.657 / 0,000% · 4121: 1.008.214 / 0,195% · 5814: 929.820 / 0,102% · 7538: 922.082 / 0,043% · 5311: 899.523 / 1,202% · 5310: 462.833 / 0,839% · 4900: 457.619 / 0,012% · 5813: 456.044 / 0,103% |
| Giờ trong ngày | 0h: 0,973% · 1h: 1,072% · 2h: 1,039% · 3h: 1,250% · 4h: 1,114% · 5h: 0,787% · 6h: 0,221% · 7h: 0,288% · 8h: 0,366% · 9h: 0,434% · 10h: 0,421% · 11h: 0,389% · 12h: 0,368% · 13h: 0,374% · 14h: 0,363% · 15h: 0,367% · 16h: 0,332% · 17h: 0,483% · 18h: 0,530% · 19h: 0,489% · 20h: 0,449% · 21h: 0,456% · 22h: 0,434% · 23h: 0,731% |
| Thứ trong tuần (0 = thứ Hai) | 0: 0,415% · 1: 0,422% · 2: 0,386% · 3: 0,443% · 4: 0,429% · 5: 0,405% · 6: 0,467% |

| Thông số khác | Nhóm gian lận | Nhóm bình thường |
|---|---:|---:|
| Số tiền: trung vị / trung bình | 46,61 / 96,67 | 29,92 / 43,88 (mẫu 2,6 triệu dòng) |
| Số giờ từ giao dịch trước của cùng thẻ: trung vị | 2,82 | 8,30 |

**5 giao dịch đầu tiên (`part-00.parquet`)**

| Cột | GD 1 | GD 2 | GD 3 | GD 4 | GD 5 |
|---|---|---|---|---|---|
| `row_id` | 0 | 1 | 2 | 3 | 4 |
| `user` | 0 | 0 | 0 | 0 | 0 |
| `card_index` | 0 | 0 | 0 | 0 | 0 |
| `card` | 0 | 0 | 0 | 0 | 0 |
| `timestamp` | 2002-09-01 06:21 | 2002-09-01 06:42 | 2002-09-02 06:22 | 2002-09-02 17:45 | 2002-09-03 06:23 |
| `amount` | 134.09 | 38.48 | 120.34 | 128.95 | 104.71 |
| `use_chip` | Swipe Transaction | Swipe Transaction | Swipe Transaction | Swipe Transaction | Swipe Transaction |
| `mcc` | 5300 | 5411 | 5411 | 5651 | 5912 |
| `merchant_id` | 3527213246127876953 | -727612092139916043 | -727612092139916043 | 3414527459579106770 | 5817218446178736267 |
| `merchant_city` | La Verne | Monterey Park | Monterey Park | Monterey Park | La Verne |
| `merchant_state` | CA | CA | CA | CA | CA |
| `errors` | (trống) | (trống) | (trống) | (trống) | (trống) |
| `is_fraud` | 0 | 0 | 0 | 0 | 0 |
| `scenario_id` | 0 | 0 | 0 | 0 | 0 |
| `scenario` | legit | legit | legit | legit | legit |
| `origin` | ibm | ibm | ibm | ibm | ibm |
| `split` | train | train | train | train | train |
| `episode` | -1 | -1 | -1 | -1 | -1 |
| `is_probe` | False | False | False | False | False |


---

## Đặc trưng đề xuất cho từng dataset

Mỗi dataset có một bộ đầu vào (input) riêng, không gộp thành một bộ chung. Bốn dataset được chọn để đại diện cho bốn kiểu dữ liệu khác nhau:

| Dataset | Kiểu dữ liệu | Dùng để kiểm tra |
|---|---|---|
| **IEEE-CIS** | Dữ liệu thật, nhiều chiều, nhiều giá trị thiếu, nhiều biến danh mục | Khả năng xử lý dữ liệu "bẩn" và tự dựng định danh thẻ |
| **Sparkov** | Có lịch sử thẻ, quy mô vừa, có thông tin địa lý | Tác dụng của đặc trưng theo thời gian (feature engineering) và đặc trưng quan hệ thẻ – điểm bán |
| **CardHistory** | Lịch sử giao dịch dài theo thẻ, quy mô lớn (25 triệu dòng) | Khả năng của mô hình boosting (LightGBM / XGBoost) khi gian lận chỉ thấy được qua lịch sử thẻ, trên dữ liệu lớn |
| **Kaggle S6E11** (kèm **ULB**) | Dữ liệu phẳng, không có lịch sử | Nhóm đối chứng "không có ngữ cảnh". S6E11 có đặc trưng dễ hiểu; ULB là dữ liệu thật đã PCA, mất cân bằng rất mạnh |

**Quy tắc chung cho mọi dataset**

1. **Đặc trưng lịch sử chỉ dùng giao dịch trước thời điểm đang xét** (theo checklist KAN-33).
2. **Cột định danh** (mã thẻ, mã điểm bán, mã giao dịch) chỉ dùng để gom lịch sử hoặc nối bảng, không đưa thẳng vào model.
3. **Cột chứa đáp án hoặc thông tin sinh ra sau khi biết đáp án** không bao giờ được đưa vào model.
4. Bộ mã hoá (one-hot, đếm tần suất, chuẩn hoá) chỉ fit trên tập train.
5. Thuộc tính nhạy cảm (giới tính, tuổi, nghề nghiệp) không dùng mặc định; nếu thử thì báo cáo riêng.

---

### A. IEEE-CIS

**Cách chia tập:** theo `TransactionDT` trên phần có nhãn (`train_transaction`). File test của cuộc thi không có nhãn, chỉ dùng để nộp lên Kaggle.

| Nhóm | Đặc trưng | Tính từ | Lý do |
|---|---|---|---|
| 1. Giao dịch cơ bản | `TransactionAmt`, `log_amt`, `amt_cents` (phần lẻ sau dấu phẩy), `ProductCD` | `TransactionAmt`, `ProductCD` | Thông tin có sẵn cho mọi giao dịch, không thiếu. Phần lẻ của số tiền phản ánh loại tiền tệ / kiểu thanh toán |
| 2. Thời gian | `hour = (DT // 3600) % 24`, `dow = (DT // 86400) % 7` | `TransactionDT` | `TransactionDT` là bộ đếm tăng dần, đưa thẳng vào model sẽ học "thời điểm" thay vì quy luật; giờ và thứ thì lặp lại theo chu kỳ |
| 3. Thẻ và địa chỉ | `card4`, `card6` (one-hot); `card1`, `card2`, `card3`, `card5`, `addr1`, `addr2` (mã hoá bằng **tần suất xuất hiện**, fit trên train) | `card1`–`card6`, `addr1`, `addr2` | `card4`/`card6` ít giá trị. Các cột còn lại có hàng trăm đến hàng nghìn giá trị, one-hot sẽ quá nhiều cột và dễ học vẹt |
| 4. Email | `P_emaildomain`, `R_emaildomain` (gộp tên miền hiếm thành "khác"), `has_R_email`, `P_equals_R` | `P_emaildomain`, `R_emaildomain` | Tên miền email và việc người mua/người nhận dùng cùng email là tín hiệu rủi ro; `R_emaildomain` thiếu 77% nên việc *có hay không* cũng là thông tin |
| 5. Bộ đếm | `C1`–`C14` | `C1`–`C14` | Không thiếu giá trị, là đặc trưng hành vi do Vesta tính sẵn |
| 6. Khoảng thời gian | `D1`, `D4`, `D10`, `D15` | `D1`–`D15` | Bốn cột ít thiếu nhất (0,2–28,6%); các cột `D` còn lại thiếu 44–93% |
| 7. Khớp thông tin | `M1`–`M9` (đổi `T`/`F` thành 1/0, `M4` one-hot) | `M1`–`M9` | Kết quả khớp tên / địa chỉ, ý nghĩa nghiệp vụ rõ |
| 8. Thiết bị và mạng | `has_identity`, `DeviceType`, `os` (rút gọn từ `id_30`), `browser` (rút gọn từ `id_31`), `id_01`–`id_38` | file identity | Chỉ có ở 24% giao dịch nhưng nhóm này có tỷ lệ gian lận 7,85% so với 2,09%. Chỉ dùng cho mô hình cây (tự xử lý giá trị thiếu) |
| 9. Nhóm `V` chọn lọc | Bỏ cột thiếu > 80%; gom các cột có cùng tỷ lệ thiếu thành nhóm, mỗi nhóm giữ vài cột ít tương quan với nhau | `V1`–`V339` | 339 cột trùng thông tin nhiều; giữ hết làm chậm và dễ quá khớp. Thêm ở bước sau, không dùng trong bản đầu |
| 10. Định danh thẻ tự dựng | `uid = card1 + addr1 + (ngày giao dịch − D1)`; từ `uid`: số giao dịch trước đó, số tiền trung bình / độ lệch chuẩn trước đó, `amt / trung bình`, thời gian từ giao dịch trước | `card1`, `addr1`, `D1`, `TransactionDT` | IEEE-CIS không có mã thẻ. `ngày − D1` ước lượng ngày mở thẻ nên cùng giá trị trên một thẻ. Đây là phần kiểm tra "tự dựng định danh thẻ", làm sau cùng vì dễ leakage nhất |

**Không đưa vào model:** `TransactionID` (chỉ để nối bảng), `TransactionDT` dạng thô (chỉ để chia tập và tính giờ/thứ), `isFraud` (đáp án).

**Thứ tự thử:** nhóm 1–7 (khoảng 40 cột) → thêm nhóm 8–9 → thêm nhóm 10.

---

### B. Sparkov

**Cách chia tập:** theo thời gian. Train: đầu `fraudTrain.csv`; validation: 2–3 tháng cuối của `fraudTrain.csv`; holdout: `fraudTest.csv` (21/06/2020 – 31/12/2020). Đặc trưng lịch sử tính trên toàn bộ dòng thời gian (chỉ nhìn quá khứ) rồi mới chia.

| Nhóm | Đặc trưng | Tính từ | Lý do |
|---|---|---|---|
| 1. Số tiền | `amt`, `log_amt` | `amt` | Tín hiệu mạnh nhất: trung vị gian lận 390 USD so với 47 USD; 75,8% vụ gian lận ≥ 200 USD |
| 2. Thời gian | `hour`, `is_night` (22h–3h), `dow` | `trans_date_trans_time` | Tỷ lệ gian lận 22h–23h là 2,6%, 0h–3h khoảng 1,3%, ban ngày khoảng 0,1% |
| 3. Danh mục | `category` (one-hot 14 cột), `is_online` (danh mục `_net`) | `category` | `shopping_net`, `misc_net`, `grocery_pos` có tỷ lệ gian lận cao nhất |
| 4. Tần suất | `n_tx_1h`, `n_tx_24h`, `n_tx_7d`, `sum_amt_1h`, `sum_amt_24h`, `sum_amt_7d`, `hours_since_prev` | `cc_num`, thời gian, `amt` | Gian lận quẹt dồn dập: trung vị thời gian từ giao dịch trước 1,4 giờ so với 4,4 giờ |
| 5. Lệch thói quen | `amt_mean_30d`, `amt_std_30d`, `amt_vs_mean`, `amt_vs_max_30d` | `cc_num`, `amt` | Cùng một số tiền có thể bình thường với thẻ này nhưng bất thường với thẻ khác |
| 6. Mức quen thuộc | `is_new_merchant`, `n_distinct_merchant_24h`, `n_distinct_merchant_7d`, `n_same_category_7d` | `cc_num`, `merchant`, `category` | Kẻ gian thường mua ở nơi chủ thẻ chưa từng mua |
| 7. Địa lý | `dist_home_merchant_km`, `city_pop` | `lat`, `long`, `merch_lat`, `merch_long`, `city_pop` | Kiểm tra tác dụng của thông tin địa lý. Thống kê ban đầu cho thấy khoảng cách gần như không khác giữa gian lận và bình thường (78,1 so với 78,2 km), giữ lại để đo bằng thực nghiệm |
| 8. Quan hệ thẻ – điểm bán | `merchant_n_cards_30d` (số thẻ khác nhau đã mua ở điểm bán trong 30 ngày trước), `merchant_n_tx_30d`, `merchant_amt_mean_30d`, `card_n_merchants_30d`, `amt_vs_merchant_mean` | `cc_num`, `merchant`, `amt`, thời gian | Sparkov có đủ mã thẻ và mã điểm bán. Tóm mối quan hệ giữa thẻ và điểm bán thành các cột số để mô hình ML dùng được; chỉ tính từ giao dịch trước thời điểm đang xét |

**Không đưa vào model:**

| Cột | Lý do |
|---|---|
| cột không tên, `trans_num` | Số thứ tự dòng / mã giao dịch |
| `cc_num`, `merchant` dạng thô | Định danh, chỉ dùng để tính nhóm 4, 6, 8 (đưa thẳng vào sẽ học vẹt) |
| `first`, `last`, `street` | Thông tin cá nhân |
| `lat`, `long`, `merch_lat`, `merch_long` dạng thô | Chỉ dùng để tính khoảng cách |
| `city`, `state`, `zip` | Hàng trăm giá trị, dễ học vẹt theo vị trí |
| `gender`, `dob` (tuổi), `job` | Thuộc tính nhạy cảm, không dùng mặc định |
| `unix_time` | Trùng thông tin với `trans_date_trans_time` |
| `is_fraud` | Đáp án |

---

### C. CardHistory-Fraud

**Cách chia tập:** dùng cột `split` có sẵn (train trước 2018 + 01–06/2018 của 80% thẻ; validation: 01–06/2018 của 20% thẻ còn lại; test: 07/2018 – 03/2020). Đánh giá theo cách của bộ dữ liệu: bỏ "IBM's original fraud" và "attempt on a blocked card" khỏi kết quả chính.

Gian lận trong bộ này chủ yếu chỉ thấy được qua lịch sử của thẻ, nên lịch sử được tóm thành các đặc trưng dạng bảng theo nhiều cửa sổ thời gian. Mô hình phù hợp nhất là **LightGBM**: xử lý tốt dữ liệu bảng rất lớn (25 triệu dòng), nhanh, ít tốn bộ nhớ và hỗ trợ sẵn biến danh mục; **XGBoost** (`tree_method="hist"`) là lựa chọn thay thế.

**Bảng đặc trưng** (tham khảo 46 đặc trưng của mô hình XGBoost mẫu trong `baselines/weights/xgboost-geo.json`)

| Nhóm | Đặc trưng | Tính từ | Lý do |
|---|---|---|---|
| 1. Giao dịch hiện tại | `abs_amount`, `log_amount`, `is_refund` (`amount < 0`), `use_chip` (one-hot), `mcc` | `amount`, `use_chip`, `mcc` | Online có tỷ lệ gian lận 2,31% so với khoảng 0,18% khi quẹt / chip; số tiền 0–1 USD (thử thẻ) 1,37% và 200–500 USD 3,06% |
| 2. Thời gian | `hour`, `dow`, `hours_since_prev` | `timestamp`, `card` | 0h–4h có tỷ lệ gian lận khoảng 1–1,25%; trung vị thời gian từ giao dịch trước của gian lận là 2,8 giờ so với 8,3 giờ |
| 3. Vị trí | `is_online`, `is_abroad`, `is_home_city` (thành phố thường mua nhất trong quá khứ), `city_switches_24h`, `n_nonhome_7d` | `merchant_city`, `merchant_state`, `card` | Thẻ giả (clone) bị dùng ở nơi chủ thẻ không đến; giao dịch du lịch hợp lệ cũng đổi vị trí nên cần lịch sử để phân biệt |
| 4. Tần suất | `n_1h`, `n_24h`, `n_7d` | `card`, `timestamp` | Đợt thử thẻ: 3–7 giao dịch cách nhau vài phút |
| 5. Lệch thói quen | `roll_mean10`, `roll_std10`, `amt_z` (độ lệch so với 10 giao dịch trước), `amt_vs_max20` | `card`, `amount` | Thẻ bị đánh cắp: số tiền tăng dần và lớn hơn bình thường |
| 6. Mức mới lạ | `new_merchant`, `new_city`, `new_mcc`, `new_merch_7d`, `share_new_merch_7d` | `card`, `merchant_id`, `merchant_city`, `mcc` | Kẻ gian dùng điểm bán, thành phố, ngành hàng mới với thẻ |
| 7. Dấu hiệu thử thẻ | `tiny_cnp_7d`, `tiny_cnp_30d` (số giao dịch online < 5 USD), `days_since_tiny_cnp` | `card`, `amount`, `use_chip` | Gian lận thử thẻ trước bằng vài giao dịch rất nhỏ rồi mới mua lớn |
| 8. Lịch sử bị từ chối | `decl_7d`, `decl_30d`, `days_since_decl` | `errors` của **các giao dịch trước** | Mã lỗi của giao dịch trước là thông tin đã có; mã lỗi của chính giao dịch đang chấm thì không dùng (xem bên dưới) |
| 9. Lịch sử dài | `n_30d`, `n_90d`, `amt_mean_90d`, `amt_std_90d`, `n_distinct_mcc_30d`, `n_distinct_city_30d`, `share_online_30d` | `card`, `timestamp`, `amount`, `mcc`, `merchant_city`, `use_chip` | Thói quen dài hạn của thẻ (thường mua online hay tại quầy, ở bao nhiêu nơi) giúp phân biệt gian lận với giao dịch hợp lệ giống gian lận như du lịch, đăng ký dịch vụ mới |
| 10. Biến nhiều giá trị | `merchant_freq`, `mcc_freq`, `city_freq` (số lần xuất hiện, đếm trên tập train) | `merchant_id`, `mcc`, `merchant_city` | 99.890 điểm bán, không one-hot được; mã hoá bằng tần suất giữ được thông tin "điểm bán phổ biến hay hiếm" mà không tạo hàng nghìn cột |

**Không đưa vào model:**

| Cột | Lý do |
|---|---|
| `scenario`, `scenario_id`, `origin`, `episode`, `is_probe` | **Lộ đáp án** (ví dụ `is_probe = True` luôn là gian lận; `origin = added` có tỷ lệ gian lận 12% so với 0,12%) |
| `errors` của chính giao dịch đang chấm | Phần lớn là phản ứng của ngân hàng sau khi đã phát hiện gian lận (`Card Blocked` 71%, `Stolen Card` 99%) |
| `row_id`, `split` | Số thứ tự và nhãn chia tập |
| `user`, `card_index`, `card`, `merchant_id` dạng thô trong bảng đặc trưng | Định danh, chỉ dùng để gom lịch sử và tính tần suất |
| `episodes.parquet`, `reissues.parquet` | Thông tin về đáp án, chỉ dùng để phân tích lỗi |

---

### D. Kaggle S6E11 (kèm ULB)

Hai bộ dữ liệu phẳng, không có lịch sử thẻ, dùng làm nhóm đối chứng "không có ngữ cảnh".

**S6E11**

**Cách chia tập:** không có thời gian đầy đủ nên chia ngẫu nhiên, giữ nguyên tỷ lệ gian lận ở mỗi tập (train / validation / holdout). Ghi rõ hạn chế này trong báo cáo.

| Nhóm | Đặc trưng | Lý do |
|---|---|---|
| 1. Giao dịch | `amount_usd` (log), `merchant_category`, `channel`, `card_type` | Thông tin cơ bản; `Gift Cards`, `Crypto Exchange`, `Gaming` có tỷ lệ gian lận 5,5–7,3% |
| 2. Xác thực và bảo mật | `auth_method`, `cvv_retry_count`, `used_vpn`, `ip_country_mismatch`, `billing_shipping_mismatch`, `is_ai_generated_scam_attempt` | Nhóm tín hiệu mạnh nhất: nhập lại CVV 2 lần → 41,7%; IP khác quốc gia → 16,5%; không xác thực → 6,4% |
| 3. Hành vi tính sẵn | `hours_since_last_txn`, `txn_count_last_24h`, `velocity_score`, `is_new_merchant`, `is_foreign_transaction`, `distance_from_home_km` | Đặc trưng lịch sử đã được tính sẵn thành cột, thay cho việc tự tính từ mã thẻ |
| 4. Rủi ro và hồ sơ | `merchant_risk_score`, `prior_disputes`, `card_age_months`, `account_balance_usd` | Thông tin hồ sơ; lưu ý `merchant_risk_score` ngoài đời thường được tính từ lịch sử gian lận |
| 5. Thời gian và thiết bị | `time_of_day_hour`, `day_of_week`, `device_type` | Giữ để so sánh với các bộ có lịch sử; thống kê ban đầu không thấy khác biệt |

**Không đưa vào model:** `id` (mã dòng), `is_fraud` (đáp án). `customer_age` không dùng mặc định (thuộc tính nhạy cảm).

**ULB**

**Cách chia tập:** theo `Time` (khoảng 60/20/20), số vụ gian lận ở validation / holdout chỉ khoảng 57 / 75 nên phải báo kèm.

| Nhóm | Đặc trưng | Lý do |
|---|---|---|
| 1. Thành phần PCA | `V1`–`V28` | Đã chuẩn hoá sẵn; là toàn bộ thông tin gốc của giao dịch |
| 2. Số tiền | `log(1 + Amount)` | Phân bố số tiền rất lệch |
| 3. Thời gian | `hour = (Time // 3600) % 24` | Tỷ lệ gian lận lúc 2h là 1,71% so với 0,05–0,3% ban ngày |

**Không đưa vào model:** `Time` dạng thô (chỉ có 2 ngày, dùng để chia tập), `Class` (đáp án).

**Dùng S6E11 và ULB để điều chỉnh số liệu khi thử nghiệm**

- **Hạ tỷ lệ gian lận của S6E11** (bỏ bớt mẫu gian lận trong tập đánh giá) xuống mức của ULB (khoảng 0,17%) để xem cùng một mô hình giảm hiệu quả bao nhiêu khi gian lận hiếm hơn.
- **Dùng ULB để kiểm tra nhanh** pipeline, cách tính metric và cách xử lý mất cân bằng (class weight, lấy mẫu lại) trước khi chạy trên các bộ lớn.

---

### Tóm tắt đầu vào

| Dataset | Dạng đầu vào | Số đặc trưng dự kiến (bản đầu) | Cách chia tập | Cột tuyệt đối không dùng |
|---|---|---|---|---|
| IEEE-CIS | Bảng | Khoảng 40, tăng dần khi thêm nhóm 8–10 | Theo `TransactionDT` | `isFraud`, `TransactionID` |
| Sparkov | Bảng | Khoảng 35–40 (gồm 14 cột one-hot danh mục) | Theo thời gian, holdout = `fraudTest.csv` | `is_fraud`, ID, thông tin cá nhân |
| CardHistory | Bảng | Khoảng 50 | Cột `split` có sẵn | `scenario*`, `origin`, `episode`, `is_probe`, `errors` hiện tại |
| S6E11 | Bảng | 24 | Ngẫu nhiên, giữ tỷ lệ | `is_fraud` |
| ULB | Bảng | 30 | Theo `Time` | `Class` |
