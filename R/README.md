# R/

Reusable R functions used across scripts or analyses.

Depending on the project, this folder may contain:
- **Helper functions**: small utilities for data cleaning or formatting
- **Analysis functions**: wrappers around statistical methods used repeatedly
- **Methodological functions**: custom implementations of statistical or modeling approaches

Source these files at the top of any script that needs them:

```r
source("R/my_functions.R")
```

Functions should be documented with comments describing their inputs, outputs, and purpose.
