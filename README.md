# Mendelian Randomization

Replication of [Yu et al. (2024)](https://www.frontiersin.org/journals/cardiovascular-medicine/articles/10.3389/fcvm.2024.1449185/full) estimating the causal relationship between GLP-1 receptor agonists (GLP-1RA) and ischemic stroke using Mendelian Randomization.

## Required Packages

library(data.table)
library(dplyr)
library(ggplot2)
library(TwoSampleMR) 
library(ieugwasr)
library(MRPRESSO) 

## Data

### Instrumental Variables
`data/GLP1RA-eqtls - Sheet1.csv` — 22 significant cis-eQTL SNPs for the drug target gene *GLP1R*, sourced from [Yuming et al. (2024)](https://journals.lww.com/international-journal-of-surgery/fulltext/2024/08000/association_of_glucagon_like_peptide_1_receptor.18.aspx). All instruments pass F-statistic threshold (F > 47), indicating strong instrument **relevance**.

### Outcome: T2D (Positive Control)
European ancestry-specific T2D GWAS summary statistics from the [DIAGRAM Consortium](https://diagram-consortium.org/), used as a positive control given the glucose-lowering mechanism of GLP-1RAs.

### Outcome: Ischemic Stroke
GWAS summary statistics extracted from [Open GWAS](https://opengwas.io/) — Malik et al. (2018), Open GWAS ID: `ebi-a-GCST005843`.

## Methods

Two sample Mendelian Randomization was performed using the
[TwoSampleMR](https://mrcieu.github.io/TwoSampleMR/) package in R. 
Primary causal estimates were obtained using the inverse variance weighted (IVW) method, 
with MR-Egger, weighted median, and weighted mode as sensitivity analyses.

**Positive control:** Proxies were first tested against T2D outcomes 
to validate instrument relevance, given the established 
glucose-lowering mechanism of GLP-1RAs.

**Sensitivity analyses:**
- Horizontal pleiotropy: MR-Egger intercept test and MR-PRESSO global test
- Heterogeneity: Cochran's Q statistic (MR-Egger and IVW)
- Outlier influence: leave-one-out analysis

## Results

### Positive Control (GLP1-RA --> T2D)

GLP-1RA proxies were significantly associated with reduced odds of T2D
(IVW: log-odds = -0.196, p = 2.3×10⁻¹⁷), validating instrument relevance.
No heterogeneity (Q-statistic p > 0.05) or pleiotropy (MR-Egger intercept = 0.046, 
p = 0.625) was detected.

### Primary Analysis (GLP1-RA --> Ischemic Stroke)

Consistent with the original paper, genetically proxied higher GLP-1R expression 
was associated with increased odds of ischemic stroke (~11.6% higher odds, IVW).
Tests for pleiotropy (MR-Egger intercept = 0.048, p = 0.704) and heterogeneity 
(Cochran's Q p = 1.0) were non-significant. MR-PRESSO global test was also 
non-significant (p = 1.0, RSS = 0.73).


The paradoxical direction of effect i.e. increased stroke risk contrary to cardioprotective effects of GLP1-RAs in CVOTs, may reflect limitation of whole-blood eQTLs as proxies for drug action. 
Randomised trials studying comparative effectiveness of drugs against health outcomes like MACE, often include non-healthier group of people eg. One who have Type 2 diabetes, to ensure that outcome occurs. It is hard to achieve similar condition in mendelian randomisation study. 
Also, drug-target action are often acute, and germline genetic proxies are fixed at conception. 



