# 1_clean.R
# Load raw data, perform cleaning, and save outputs for downstream scripts.

library(tidyverse)

# Source helper functions if needed
# source("R/cleaning_functions.R")

# ── Load ──────────────────────────────────────────────────────────────────────

raw <- read_csv("data/raw/your_data.csv")

# ── Clean ─────────────────────────────────────────────────────────────────────

# Add cleaning steps here

cleaned <- raw

# ── Save ──────────────────────────────────────────────────────────────────────

saveRDS(cleaned, "output/rds/cleaned.rds")
