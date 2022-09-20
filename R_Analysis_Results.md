# Differential Gene Expression using R
The raw code I used to perform this analysis with can be found in this [jupyter notebook]().

## Research Questions:
1. Are any differentially expressed genes or pathways between three groups: Normal, Primary Tumour and Metastatic

## Analysis FLow:
1. Import Gene Counts into R and create DESeq2 object
2. Annotate Gene Symbols
3. Plot Gene Expression data
4. Pathway Enrichment

## 1. Initial DESeq2 results
As this is a three way comparision at least one group needs to be made the reference group. This can be done by seting the `biopsy_site` as a factor with `biopsy_site::Normal` as the reference level and the DESeq2 design = `~biopsy_site`. The initial results are down below.
```
out of 41776 with nonzero total read count
adjusted p-value < 0.05
LFC > 0 (up)       : 3365, 8.1%
LFC < 0 (down)     : 2748, 6.6%
outliers [1]       : 0, 0%
low counts [2]     : 17441, 42%
(mean count < 1)
```
## 2. Principal Component Analysis
