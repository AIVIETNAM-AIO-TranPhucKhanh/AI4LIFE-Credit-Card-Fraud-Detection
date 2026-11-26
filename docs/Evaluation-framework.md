## Evaluation Framework

Accuracy is not considered a primary evaluation metric due to the highly imbalanced nature of fraud detection datasets.

### Primary Metrics

| Metric | Evaluation Objective |
|---|---|
| Average Precision (AP) | Measure fraud ranking quality across decision thresholds. |
| Recall at Fixed Alert Budget | Maximize fraud coverage within investigation capacity. |

### Secondary Metrics

| Metric | Evaluation Objective |
|---|---|
| Recall | Measure detected fraudulent transactions. |
| Precision | Measure the reliability of fraud alerts. |
| False Positive Rate | Measure incorrect alerts on legitimate transactions. |
| Precision@K | Measure alert quality within the top-K transactions. |
| F1-score | Balance precision and recall. |
| ROC-AUC | Measure overall discrimination capability. |

### Business & System Metrics

| Metric | Evaluation Objective |
|---|---|
| Alert Rate | Measure operational investigation workload. |
| Fraud Amount Recall | Measure the proportion of fraudulent transaction value detected, when supported by the dataset. |
| P95 Inference Latency | Measure transaction assessment latency. |

### Optimization Objective

> Maximize fraud detection capability while controlling false alarms and operational costs.

### Evaluation Protocol

- Use consistent datasets and evaluation conditions across models.
- Prefer chronological data splitting when timestamps are available.
- Prevent data leakage during preprocessing and feature engineering.
- Fit preprocessing and resampling methods using training data only.
- Optimize decision thresholds on validation data.
- Reserve the test set for final evaluation.
- Compare candidate models against established baselines.
- Document experimental configurations and limitations.

### Experimental Results

| Model | AP | Recall | Precision | FPR | Recall@K |
|---|---:|---:|---:|---:|---:|
| Logistic Regression | — | — | — | — | — |
| Random Forest | — | — | — | — | — |
| XGBoost | — | — | — | — | — |
| LightGBM | — | — | — | — | — |

*Experimental results will be published after model training and validation.*

---