
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
│   └── preprocessed/               # Cleaned / split data produced by src/preprocessing
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
├── .gitignore                      # Excludes raw and preprocessed data (data/raw/, data/preprocessed/) and .env
├── requirements.txt                # Python dependencies (installed by CI and for local setup)
└── README.md                       # Project introduction (this file)
```

---

## Dataset Setup

The project uses five public datasets. Raw files are **not committed** to this repository (`data/raw/` is ignored by Git): every member downloads them locally and places them in the folders below, **keeping the folder and file names exactly as shown**.

### Target folder structure

```text
data/raw/
├── sparkov-fraud-detection/          # Sparkov (Kaggle dataset)
│   ├── fraudTrain.csv
│   └── fraudTest.csv
│
├── ieee-fraud-detection/             # IEEE-CIS (Kaggle competition)
│   ├── train_transaction.csv
│   ├── train_identity.csv
│   ├── test_transaction.csv
│   ├── test_identity.csv
│   └── sample_submission.csv
│
├── mlg-ulb-creditcardfraud/          # ULB (Kaggle dataset)
│   └── creditcard.csv
│
├── playground-series-s6e11/          # Kaggle Playground S6E11 (Kaggle competition)
│   ├── train.csv
│   ├── test.csv
│   └── sample_submission.csv
│
└── CardHistory-Fraud/                # CardHistory-Fraud (Hugging Face)
    ├── data/
    │   ├── part-00.parquet
    │   ├── ...
    │   └── part-12.parquet
    ├── baselines/
    ├── episodes.parquet
    ├── reissues.parquet
    ├── FINGERPRINT.json
    ├── LICENSE
    ├── NOTICE
    └── README.md
```

### Kaggle datasets (manual download)

All four Kaggle datasets are downloaded by hand from the browser:

1. Sign in to [Kaggle](https://www.kaggle.com).
2. **For the two competitions (IEEE-CIS and S6E11): join the competition first.** Open the competition's **Rules** page and click **Join Competition / I Understand and Accept**. Without this step the download button is not available. Kaggle may ask you to verify your phone number.
3. Open the **Data** page of the dataset or competition and click **Download** (or **Download All**).
4. Unzip the downloaded `.zip` file into the matching folder under `data/raw/` from the table below.

| Dataset | Type | Download page | Target folder |
|---|---|---|---|
| Sparkov | Dataset | [kaggle.com/datasets/kartik2112/fraud-detection](https://www.kaggle.com/datasets/kartik2112/fraud-detection) | `data/raw/sparkov-fraud-detection/` |
| IEEE-CIS | Competition (join first) | [kaggle.com/competitions/ieee-fraud-detection/data](https://www.kaggle.com/competitions/ieee-fraud-detection/data) | `data/raw/ieee-fraud-detection/` |
| ULB | Dataset | [kaggle.com/datasets/mlg-ulb/creditcardfraud](https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud) | `data/raw/mlg-ulb-creditcardfraud/` |
| Playground S6E11 | Competition (join first) | [kaggle.com/competitions/playground-series-s6e11/data](https://www.kaggle.com/competitions/playground-series-s6e11/data) | `data/raw/playground-series-s6e11/` |

> **IEEE-CIS rules:** the data may be used for non-commercial purposes only (research and education) and **must not be redistributed or published**, including samples or processed versions. Never commit any IEEE-CIS file and never share it with someone who has not joined the competition.

### CardHistory-Fraud (Hugging Face)

CardHistory-Fraud is downloaded with the Hugging Face CLI, which is installed through `requirements.txt`. Create a virtual environment and install the dependencies **before** running the download command.

**1. Create and activate a virtual environment** (from the repository root)

Windows (PowerShell):

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
```

macOS / Linux:

```bash
python -m venv .venv
source .venv/bin/activate
```

**2. Install the dependencies**

```bash
pip install -r requirements.txt
```

**3. Log in and download** (from the repository root, with the virtual environment active)

```bash
hf auth login
hf download toloka/CardHistory-Fraud --repo-type dataset --local-dir ./data/raw/CardHistory-Fraud
```

`hf auth login` asks for a Hugging Face access token (create one at [huggingface.co/settings/tokens](https://huggingface.co/settings/tokens)). The files are written directly into `data/raw/CardHistory-Fraud/` with the structure above; no renaming is needed.

---

## Dataset Credits

This project uses the following public datasets. All rights belong to their respective authors; please follow each license when using the data.

| Dataset | Authors / Provider | Source | License |
|---|---|---|---|
| Credit Card Transactions Fraud Detection (Sparkov) | Kartik Shenoy; generated with the Sparkov Data Generation tool by Brandon Harris | [Kaggle](https://www.kaggle.com/datasets/kartik2112/fraud-detection) · [Sparkov Data Generation](https://github.com/namebrandon/Sparkov_Data_Generation) | CC0: Public Domain |
| IEEE-CIS Fraud Detection | Vesta Corporation and IEEE Computational Intelligence Society (2019) | [Kaggle competition](https://www.kaggle.com/competitions/ieee-fraud-detection) | Kaggle competition rules: non-commercial use only, no redistribution |
| Credit Card Fraud Detection (ULB) | Machine Learning Group, Université Libre de Bruxelles, and Worldline | [Kaggle](https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud) | Open Database License (ODbL) 1.0 |
| Predicting Credit Card Fraud (Playground Series S6E11) | Kaggle (2026) | [Kaggle competition](https://www.kaggle.com/competitions/playground-series-s6e11) | CC BY 4.0 |
| CardHistory-Fraud | Igor Tica and Oleg Zubkov, Toloka AI BV (2026); built on IBM's TabFormer data | [Hugging Face](https://huggingface.co/datasets/toloka/CardHistory-Fraud) · [GitHub](https://github.com/Toloka/CardHistory-Fraud) · [IBM TabFormer](https://github.com/IBM/TabFormer) | Apache License 2.0 (TabFormer: Apache License 2.0) |

**Citations**

- **ULB:** Andrea Dal Pozzolo, Olivier Caelen, Reid A. Johnson and Gianluca Bontempi. *Calibrating Probability with Undersampling for Unbalanced Classification.* IEEE Symposium Series on Computational Intelligence (SSCI), 2015.
- **CardHistory-Fraud:**

  ```bibtex
  @misc{cardhistoryfraud2026,
    title  = {CardHistory-Fraud: card fraud that hides in the history},
    author = {Tica, Igor and Zubkov, Oleg},
    year   = {2026},
    note   = {Toloka},
    url    = {https://huggingface.co/datasets/toloka/CardHistory-Fraud}
  }
  ```

- **IBM TabFormer** (base data of CardHistory-Fraud): Inkit Padhi et al. *Tabular Transformers for Modeling Multivariate Time Series.* ICASSP 2021 (arXiv:2011.01843); Erik Altman. *Synthesizing Credit Card Transactions.* arXiv:1910.03033, 2019.
- CardHistory-Fraud also uses city coordinates from [GeoNames](https://www.geonames.org) (CC BY 4.0); see the dataset's `NOTICE` file.

---

<div align="center">

### AI4LIFE

**Research Driven · Engineering Focused · Impact Oriented**

Building intelligent AI solutions for a safer financial ecosystem.

</div>
