# FraudGuard AI - Bộ khởi tạo GitHub

Repo: `AIVIETNAM-AIO-TranPhucKhanh/AI4LIFE-Credit-Card-Fraud-Detection` · Deadline nộp: **12/12/2026**
Jira: https://ai4life-team.atlassian.net/jira/software/projects/KAN (key `KAN`)

## Cài đặt (5 phút)
1. (Đã làm) `.github/`, `.gitignore`, `scripts/` đã có trong repo.
2. (Đã làm) `.github/CODEOWNERS`: AIVIETNAM-AIO-TranPhucKhanh, AIVIETNAM-AIO-TrinhGiaHuy.
3. Cài GitHub CLI, chạy `gh auth login`, rồi:
   ```bash
   bash scripts/setup-labels-milestones.sh   # (đã chạy) label + 4 milestone
   ```
4. (Đã làm) Ruleset `main`: bắt buộc PR, 1 approval từ Code Owner (Phúc hoặc Huy), CI xanh, cấm force-push/xoá branch.

## 4 giai đoạn
| Milestone | Thời gian | Mốc bàn giao |
|---|---|---|
| GĐ1 - Tìm hiểu model & chốt dataset | 25/11 - 28/11 | Dataset, metric, split chốt; data mẫu; mock API + UI khung chạy |
| GĐ2 - Baseline hoàn chỉnh | 29/11 - 03/12 | E0 + E1 tái lập; model bundle; API thật; dashboard gọi API |
| GĐ3 - Thử nghiệm model | 04/12 - 08/12 | E2, E3, ablation (E4 nếu kịp); khóa cấu hình; bắt đầu báo cáo |
| GĐ4 - Test, hoàn thiện, UI & nộp | 09/12 - 12/12 | Test cuối; QA report; UI replay + hàng đợi; báo cáo + slide; nộp |

## Có gì trong bộ này
- **Phân công & theo dõi công việc: trên Jira.** GitHub không tạo issue sẵn.
- **Label** (gắn cho PR): loại việc, P0/P1, module, mã thực nghiệm E0-E5, `risk: leakage`.
- **Issue form**: chỉ còn Báo lỗi (có mức độ, mã Jira).
- **PR template**: reviewer chuyên môn, cảnh báo đổi contract, checklist chống leakage.
- **CODEOWNERS**: mọi PR vào `main` cần Phúc hoặc Huy approve. Reviewer chuyên môn theo module thì tag thủ công trong PR.
- **CI**: lint + pytest mỗi PR. Không dùng Dependabot (không tự cập nhật thư viện).

## Quy ước
- Chỉ có 1 nhánh lâu dài là `main` (không dùng `dev`). Tạo branch từ `main`, mở PR vào `main`.
- Branch: `<loại>/KAN-<số>-mo-ta`, loại là `feat`, `fix`, `research`, `docs`, `test` (vd `feat/KAN-12-time-split`). Có mã Jira để Jira tự hiện branch/commit/PR khi cài app GitHub for Jira.
- Commit/PR title: mã Jira + Conventional Commits, vd `KAN-12 feat(data): chia tập theo thời gian`.
- Cấu trúc thư mục: theo mục **Repository Structure** trong `README.md` (`src/preprocessing`, `src/features`, `src/models`, `src/training`, `src/evaluation`, `src/pipeline`, `src/api`, `dashboard/` dùng Gradio).
- Không commit dữ liệu thô, model weights, `.env`.
