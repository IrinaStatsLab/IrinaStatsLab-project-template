# 2_process.R
# Load cleaned data, perform processing or feature engineering, and save outputs.

library(tidyverse)

# Source helper functions if needed
# source("R/processing_functions.R")

# ── Load ──────────────────────────────────────────────────────────────────────

cleaned <- readRDS("output/rds/cleaned.rds")

# ── Process ───────────────────────────────────────────────────────────────────

# Add processing steps here

processed <- cleaned

# ── Save ──────────────────────────────────────────────────────────────────────

saveRDS(processed, "output/rds/processed.rds")
