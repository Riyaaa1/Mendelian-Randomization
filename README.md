# Mendelian Randomization

This is a replication of the [paper 1](https://www.frontiersin.org/journals/cardiovascular-medicine/articles/10.3389/fcvm.2024.1449185/full) estimating causal relationship between GLP1-RA and ischemic stroke based on Mendelian Randomization. 

## About Data

1. Instrumental variables - `data/GLP1RA-eqtls - Sheet1.csv` includes 22 significant cis-eQTL SNPs for drug target gene GLP1R (E) (F-statistics > 47) available through [paper 2](https://journals.lww.com/international-journal-of-surgery/fulltext/2024/08000/association_of_glucagon_like_peptide_1_receptor.18.aspx)

2. T2D association summary statistics - European ancestry specific T2D GWAS summary statistics taken from [DIAGRAM](https://diagram-consortium.org). T2D here serves as a positive control

3. Outcome (Ischaemic Stroke) - Extracted from [Open GWAS](https://opengwas.io), Malik R. 2018 OpenGwasID: ebi-a-GCST005843

