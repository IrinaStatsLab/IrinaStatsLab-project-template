# analysis/

Numbered R scripts that form the main analysis pipeline. Run them in order:

```
1_clean.R       # Load raw data, clean, and save to output/rds/ or data/processed/
2_process.R     # Further processing or feature engineering
3_model.R       # Modeling and statistical analysis
4_visualize.R   # Figures and tables
...
```

Each script should be self-contained with respect to inputs and outputs:
- Load inputs from `data/processed/` or `output/rds/`
- Save outputs to `output/figures/`, `output/tables/`, or `output/rds/`
- Source any helper functions from `R/` at the top of the script
