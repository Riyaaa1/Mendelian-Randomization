# Mendelian Randomization

Replication of [Yu et al. (2024)](https://www.frontiersin.org/journals/cardiovascular-medicine/articles/10.3389/fcvm.2024.1449185/full) estimating the causal relationship between GLP-1 receptor agonists (GLP-1RA) and ischemic stroke using Mendelian Randomization.

## Data

### Instrumental Variables
`data/GLP1RA-eqtls - Sheet1.csv` — 22 significant cis-eQTL SNPs for the drug target gene *GLP1R*, sourced from [Yuming et al. (2024)](https://journals.lww.com/international-journal-of-surgery/fulltext/2024/08000/association_of_glucagon_like_peptide_1_receptor.18.aspx). All instruments pass F-statistic threshold (F > 47), indicating strong instrument **relevance**.

### Outcome: T2D (Positive Control)
European ancestry-specific T2D GWAS summary statistics from the [DIAGRAM Consortium](https://diagram-consortium.org/), used as a positive control given the glucose-lowering mechanism of GLP-1RAs.

### Outcome: Ischemic Stroke
GWAS summary statistics extracted from [Open GWAS](https://opengwas.io/) — Malik et al. (2018), Open GWAS ID: `ebi-a-GCST005843`.

