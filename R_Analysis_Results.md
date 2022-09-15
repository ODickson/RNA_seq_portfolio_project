# Differential Gene Expression using R
The raw code I used to perform this analysis with can be found in this [jupyter notebook]().

## Research Questions:
1. Are any differentially expressed genes or pathways between the responders and non-responders?
2. Are there any differentially expressed genes or pathways between treatment before and after treatment for those who respond?

## Analysis FLow:
1. Import Gene Counts into R and create DESeq2 object
2. Annotate Gene Symbols
3. Plot Gene Expression data
4. Pathway Enrichment

## Responders vs Non-responders
### 1. Initial DESeq2 results
```
out of 39542 with nonzero total read count
adjusted p-value < 0.05
LFC > 0 (up)       : 24, 0.061%
LFC < 0 (down)     : 33, 0.083%
outliers [1]       : 0, 0%
low counts [2]     : 291, 0.74%
(mean count < 0)
[1] see 'cooksCutoff' argument of ?results
[2] see 'independentFiltering' argument of ?results
```
The initial DESeq2 results show that there is very few differentially expressed genes between the responder and non-responder groups.
![output](https://user-images.githubusercontent.com/59836053/190227005-07882daa-0058-4ce4-bc74-cf2e990592ad.png)
