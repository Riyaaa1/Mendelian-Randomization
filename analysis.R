library(data.table)
library(dplyr)
library(ggplot2)
library(TwoSampleMR) 
library(MRInstruments) 
library(ieugwasr) 
library(MRPRESSO) 


# Specify the exposure and outcome
exposure = 'GLP1R'
outcome = 'Ischemic Stroke'

### Read IVs from https://journals.lww.com/international-journal-of-surgery/fulltext/2024/08000/association_of_glucagon_like_peptide_1_receptor.18.aspx

eqtl.gen <- read.csv('data/GLP1RA-eqtls - Sheet1.csv')
eqtl.gen.expo <- read_exposure_data(filename = 'data/GLP1RA-eqtls - Sheet1.csv',
                                   sep = ",",
                                   clump = FALSE,
                                   snp_col = "SNP",
                                   beta_col = "beta",
                                   se_col = "se",
                                   pval_col = "p",
                                   effect_allele_col = "effect_allele",
                                   other_allele_col  = "other_allele",
                                   eaf_col = "maf"
)

eqtl.gen.expo$Phenotype <- exposure

# test against t2D as positive control

#diamante <- read.delim('data/DIAMANTE-EUR.sumstat.txt', sep = ' ')

# rename columns to remove dots
#diamante <- diamante %>%
# rename(
#   beta = Fixed.effects_beta,
#   se = Fixed.effects_SE,
#   pval = Fixed.effects_p.value
# )
#write.csv(diamante,'data/DIAMANTE-EUR.csv', quote = FALSE, row.names = FALSE)

t2dm_eqtl_outcome <- read_outcome_data(
  snps = eqtl.gen.expo$SNP,
  filename = 'data/DIAMANTE-EUR.csv',
  sep = ',',  
  snp_col = 'rsID',
  beta_col = 'beta',
  se_col = 'se',
  effect_allele_col = 'effect_allele',
  other_allele_col = 'other_allele',
  eaf_col = 'effect_allele_frequency',
  pval_col = 'pval'
)

eqtl.expo_t2dm_harmonised <- harmonise_data(eqtl.gen.expo, t2dm_eqtl_outcome)

# run MR
res_t2d_control<- mr(eqtl.expo_t2dm_harmonised)
# All the results point to significantly reduced odds of T2DM with the GLP1RA proxies. (IVW, log-odds = -0.1964233, pval = 2.318575e-17)

# test for heterogeneity: Do all causal estimates point to similar directions?
mr_heterogeneity(eqtl.expo_t2dm_harmonised)
# the Q statistics calculated by both MR-Egger and IVW is less than 50% and are non significant indicating no heterogeneity

# test for pleiotropy
mr_pleiotropy_test(eqtl.expo_t2dm_harmonised) # no pleiotropy ( egger intercept: 0.046, pval = 0.625)

# Extract the outcome data : Ischemic stroke (Malik R. 2018 OpenGwasID: ebi-a-GCST005843)

eqtl.gen_outcome_dat <- extract_outcome_data(snps = eqtl.gen.expo$SNP,
                                    outcomes = 'ebi-a-GCST005843')

eqtl.gen_outcome_dat$Phenotype <- outcome 

# harmonise the data
glp_stroke_harmonised <- harmonise_data(eqtl.gen.expo, eqtl.gen_outcome_dat)

###### MR analysis for actual outcome ######

res_glp_stroke <- mr(glp_stroke_harmonised)

# scatterplot

# each dot in the scatterplot represent each SNP and the grey lines are CIs.
# The regression lines (colored differently for different methods) depict the direction
# and the strength of causal relationship between exposure and outcome. 

scatter_plot <- mr_scatter_plot(res_glp_stroke,glp_stroke_harmonised)
scatter_out_p <- scatter_plot[[1]] + 
  theme_bw() + 
  guides(color=guide_legend(ncol =1)) + 
  theme(
    text = element_text(size = 8), 
  )
#ggsave(scatter_out_p, file = "results/scatterplot_stroke_glp.pdf", width = 7, height = 7)


# Similar to the table, the slope for MR egger (dark blue line) shows 
# opposite trend or negative slope while rest of the lines cluster together
# including IVW towards positive direction. 

# Note: MR Egger detects the horizontal pleiotropy by fitting an intercept, 
# and if pleiotropy exists it can flip the direction.

# Check for pleiotropy

pleio_glp_stroke <- mr_pleiotropy_test(glp_stroke_harmonised)
# test for pleiotropy: non significant (intercept = 0.04760006, pval = 0.7043501)

### Sensitivity analysis 

# 1. Leave-one-out (are results driven by outliers?)
loo_glp_stroke <- mr_leaveoneout(glp_stroke_harmonised)

# 2. check the cochran's Q statistics
het_glp_stroke <- mr_heterogeneity(glp_stroke_harmonised)
# pval = 1

# 3. MR-PRESSO global method using default parameters 
mr_presso_glpStroke <- mr_presso(BetaOutcome = 'beta.outcome',
                                 BetaExposure = 'beta.exposure',
                                 SdOutcome = 'se.outcome',
                                 SdExposure = 'se.exposure',
                                 data = glp_stroke_harmonised
                                 )
mr_presso_glpStroke
# global test for pleiotropy - p val : 1, Rss = 0.73
# genetically predicted higher GLP1R exposure is associated with approximately 11.6% higher odds of ischemic stroke.




