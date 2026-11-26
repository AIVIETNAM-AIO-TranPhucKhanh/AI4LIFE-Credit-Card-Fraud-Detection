
<div align="center">

# AI4LIFE
### Credit Card Fraud Detection & Early Warning System

**Leveraging Machine Learning to Detect Financial Fraud, Assess Transaction Risk, and Enable Early Intervention.**

![Status](https://img.shields.io/badge/Status-In%20Development-blue?style=flat-square)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![Machine Learning](https://img.shields.io/badge/Machine%20Learning-F97316?style=flat-square)
![Domain](https://img.shields.io/badge/Domain-FinTech-059669?style=flat-square)
![Release](https://img.shields.io/badge/MVP-Planned-purple?style=flat-square)

[Overview](#overview) ·
[Research](#research-focus) ·
[Architecture](#system-architecture) ·
[Evaluation](#evaluation-framework) ·
[Roadmap](#development-roadmap) ·
[Team](#team)

</div>

---

## Overview

Financial fraud remains a critical challenge for banks, financial institutions, payment platforms, and their customers.

Despite advances in cybersecurity and financial technology, fraudulent transactions continue to evolve, exposing limitations in conventional rule-based fraud detection systems.

**AI4LIFE** is a research-oriented AI engineering project focused on developing an intelligent fraud detection and early warning system capable of identifying suspicious credit card transactions, assessing transaction-level risk, and supporting timely decision-making.

The project bridges Machine Learning research and practical financial risk management, with an emphasis on detection effectiveness, reliability, and real-world applicability.

### Mission

> Make financial transactions safer through intelligent, reliable, and practical AI solutions.

### Vision

Develop a scalable fraud risk assessment framework that could serve as a foundation for future integration into banking, FinTech, and digital payment ecosystems.

## Team

| Member | Role | Area of Responsibility |
|---|---|---|
| Trịnh Gia Huy | AI Engineer — Model | Model research, training, evaluation and optimization |
| Nguyễn Đức Thông | AI Engineer — Data | Data analysis, preprocessing and feature engineering |
| Phạm Đức Anh | AI Engineer — Pipeline | ML pipeline, inference services and API integration |
| Trần Phúc Khánh | Tech Leader | System architecture, technical direction and integration |
| Hồ Nguyễn Thuỳ Dung | QA / Reviewer | Testing, code review and experimental validation |

---

---

## Repository Structure

The repository follows a modular AI engineering architecture.

```text
AI4LIFE-Credit-Card-Fraud-Detection/
│
├── config/                         # Experiment and system configurations (model params, thresholds, paths)
│
├── data/                           # Datasets
│   ├── raw/                        # Original downloaded data, never modified
│   └── processed/                  # Cleaned / split data produced by src/preprocessing
│
├── src/                            # Core, reusable code — imported by scripts, dashboard and tests
│   ├── preprocessing/              # Data validation, cleaning, chronological train/val/test split
│   ├── features/                   # Behavioral features from past transactions only (velocity, amount vs. card average, time of day)
│   ├── models/                     # Model definitions (Logistic Regression, boosting, ...)
│   ├── training/                   # Training routines: data + config -> fitted model
│   ├── evaluation/                 # Metrics (AP, Recall@K, FPR), threshold selection, error analysis
│   └── pipeline/                   # End-to-end flow: raw transaction -> fraud risk score
│
├── dashboard/                      # Monitoring UI built with Gradio; calls the pipeline / API
├── scripts/                        # Runnable entry points (download data, train, evaluate); thin wrappers over src/
├── tests/                          # Pytest unit and integration tests for src/; run by CI on every PR
│
├── docs/                           # Research and technical documentation
│   ├── Project-overview.md         # Problem statement, research questions, objectives
│   ├── Model-ideas.md              # Proposed system architecture and modelling strategy
│   └── Evaluation-framework.md     # Metrics and evaluation protocol
│
├── .github/
│   ├── workflows/ci.yml            # CI: lint (ruff) + pytest on every pull request and push to main
│   ├── ISSUE_TEMPLATE/             # Bug report form (bug.yml); blank issues disabled (config.yml)
│   ├── pull_request_template.md    # Default pull request description (summary, Jira key, reviewer)
│   └── CODEOWNERS                  # Required approvers for main: Trần Phúc Khánh or Trịnh Gia Huy
│
├── .gitignore                      # Excludes model artifacts (*.pkl, *.joblib, *.pt), *.parquet and .env
├── requirements.txt                # Python dependencies (installed by CI and for local setup)
└── README.md                       # Project introduction (this file)
```
---

<div align="center">

### AI4LIFE

**Research Driven · Engineering Focused · Impact Oriented**

Building intelligent AI solutions for a safer financial ecosystem.

</div>
