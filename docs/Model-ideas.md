## System Architecture

The following diagram represents the proposed system architecture.

```mermaid
flowchart TD
    A[Transaction Data] --> B[Data Validation]
    B --> C[Preprocessing and Feature Engineering]
    C --> D[Fraud Detection Engine]

    D --> E[Supervised Learning]
    D -.-> F[Anomaly Detection - Future Research]

    E --> G[Fraud Risk Score]
    F -.-> G

    G --> H[Risk Decision Engine]

    H -->|Low Risk| I[Normal Processing]
    H -->|Medium Risk| J[Additional Verification]
    H -->|High Risk| K[Fraud Alert]

    I --> L[Monitoring Dashboard]
    J --> L
    K --> L

    L -.-> M[Investigation and Feedback]
    M -.-> N[Model Monitoring and Improvement]
    N -.-> D
```

The system is designed to support risk-based decisions rather than automatically treating every suspicious transaction as confirmed fraud.

Dashed connections represent potential future extensions.

---

## Machine Learning Strategy

The project adopts an experimental, baseline-driven development strategy.

### Supervised Learning

| Model | Purpose |
|---|---|
| Logistic Regression | Interpretable baseline |
| Random Forest | Nonlinear classification benchmark |
| XGBoost | Gradient boosting benchmark |
| LightGBM | Additional boosting candidate |

### Unsupervised Learning — Future Research

| Model | Purpose |
|---|---|
| Isolation Forest | Anomaly detection |
| Autoencoder | Learning normal transaction representations |

### Hybrid Approaches — Future Research

Potential combinations include:

- Supervised classification and anomaly detection.
- Cost-sensitive learning and threshold optimization.
- Behavioral features and transaction risk scoring.
- Ensemble-based fraud detection.

Model selection will be driven by experimental evidence rather than model complexity alone.

---