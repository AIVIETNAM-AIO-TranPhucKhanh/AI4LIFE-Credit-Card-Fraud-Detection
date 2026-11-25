#!/usr/bin/env bash
# FraudGuard AI - tạo label & 4 milestone (deadline nộp 12/12/2026).
# Yêu cầu: GitHub CLI (gh) + `gh auth login` bằng tài khoản có quyền admin/maintain repo.
# Dùng:  bash scripts/setup-labels-milestones.sh
set -euo pipefail
REPO="${1:-AIVIETNAM-AIO-TranPhucKhanh/AI4LIFE-Credit-Card-Fraud-Detection}"
label() { gh label create "$1" --color "$2" --description "$3" --repo "$REPO" --force >/dev/null && echo "✓ label: $1"; }

# Xoá label mặc định không dùng (bỏ comment nếu muốn)
# for l in "duplicate" "invalid" "question" "wontfix" "enhancement"; do gh label delete "$l" --repo "$REPO" --yes || true; done

# Loại việc
label "type: bug"        "D73A4A" "Lỗi code / sai kết quả"
label "type: task"       "1D76DB" "Công việc chung (chi tiết trên Jira)"
label "type: experiment" "5319E7" "Thực nghiệm ML (E0-E5)"
label "type: data"       "0E8A16" "Dataset, EDA, split, feature"
label "type: contract"   "B60205" "Thay đổi schema/API/model bundle - người nhận bàn giao phải review"
label "type: docs"       "0075CA" "README, decision log, tài liệu"
label "type: report"     "F9D0C4" "Báo cáo & slide nộp cuối khoá"

# Ưu tiên theo phạm vi trong brief
label "P0: core"         "B60205" "Bắt buộc để nộp 12/12"
label "P1: extension"    "FBCA04" "Mở rộng - chỉ làm khi P0 ổn định"

# Module (khớp cấu trúc repo đề xuất)
label "area: data"       "C2E0C6" "data/, src/preprocessing, src/features, notebooks/"
label "area: model"      "D4C5F9" "src/models, src/training, src/evaluation, experiments/"
label "area: pipeline"   "BFD4F2" "src/pipeline (luồng end-to-end)"
label "area: api"        "BFD4F2" "src/api (FastAPI)"
label "area: dashboard"  "FEF2C0" "dashboard/ (Gradio)"
label "area: qa"         "F9D0C4" "tests/, báo cáo QA"
label "area: infra"      "EDEDED" "CI, Docker, môi trường"


# Thực nghiệm
label "exp: E0" "E4E669" "Rule / Logistic Regression"
label "exp: E1" "E4E669" "Boosting, đặc trưng hiện tại"
label "exp: E2" "E4E669" "E1 + đặc trưng hành vi"
label "exp: E3" "E4E669" "E2 + class weight / policy cảnh báo"
label "exp: E4" "E4E669" "Anomaly detection / MLP (mở rộng)"
label "exp: E5" "E4E669" "Hybrid (mở rộng)"

label "risk: leakage"        "B60205" "Nghi ngờ rò rỉ dữ liệu tương lai / nhãn"

# Milestone - hạn là 23:59 giờ Việt Nam (= 16:59:59Z)
milestone() {
  gh api --method POST "repos/$REPO/milestones" -f title="$1" -f due_on="$2" -f description="$3" >/dev/null \
    && echo "✓ milestone: $1" || echo "• bỏ qua (có thể đã tồn tại): $1"
}
milestone "GĐ1 - Tìm hiểu model & chốt dataset" "2026-11-28T16:59:59Z" \
  "25/11-28/11. Chốt dataset + metric chính + cách chia tập theo thời gian. Có data mẫu, schema, EDA ngắn. Repo/CI/mock API/UI khung chạy được."
milestone "GĐ2 - Baseline hoàn chỉnh"           "2026-12-03T16:59:59Z" \
  "29/11-03/12. E0 (LogReg) + E1 (boosting) tái lập được; model bundle + API thật; dashboard gọi API. Đây là mốc so sánh cho mọi thực nghiệm sau."
milestone "GĐ3 - Thử nghiệm model"             "2026-12-08T16:59:59Z" \
  "04/12-08/12. E2 (đặc trưng hành vi), E3 (class weight/policy), ablation; E4 chỉ khi còn thời gian. Chọn & KHÓA cấu hình bằng validation. Bắt đầu viết báo cáo."
milestone "GĐ4 - Test, hoàn thiện, UI & nộp bài" "2026-12-12T16:59:59Z" \
  "09/12-12/12. Đánh giá test cuối 1 lần; QA report; replay + hàng đợi cảnh báo trên web; báo cáo + slide; diễn tập demo; nộp 12/12."
echo "Xong: https://github.com/$REPO/milestones"
