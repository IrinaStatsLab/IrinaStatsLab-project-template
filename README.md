# [Project Title]

[One or two sentences describing the project and the question it addresses.]

---

*This project uses the [IrinaStatsLab project template](https://github.com/IrinaStatsLab/project-template), designed for R and RStudio projects. For Python or other languages, a different structure may be used but the same principles apply.*

## Data

**Source:** [Where the data comes from — include a URL or citation if public.]

**Unit of observation:** [What does one row represent? e.g., one patient visit, one county-year.]

**Coverage:** [Date range, geographic scope, or other relevant scope.]

**How to obtain:** [Instructions for getting the data. See the data handling note in the Principles section below for context on what belongs here.]

## Pipeline

Run scripts in the following order:

| Script | Description | Inputs | Outputs |
|---|---|---|---|
| `scripts/00_setup.R` | Installs and loads dependencies | — | — |
| `analysis/01_clean.R` | [What it does] | `data/raw/...` | `data/processed/...` |
| `analysis/02_...R` | [What it does] | `...` | `...` |

## Setup

```r
# Install renv if needed, then restore the package library:
install.packages("renv")
renv::restore()
```

[Any other setup steps — e.g., credentials, data download instructions — go here.]

---

## Project Structure

`R/` and `output/` are present in every project. Everything else is added based on project type.

```
project/                   # Always present
├── R/                     # Reusable functions, sourced by all scripts
├── output/
│   ├── figures/
│   ├── tables/
│   └── rds/               # Intermediate R objects
└── README.md
```

---

### Variant 1: Data Analysis

For projects centered on an external dataset. `scripts/` holds utility and setup code (not final); `analysis/` holds the final numbered pipeline. When parallel analyses are needed (e.g., primary + sensitivity), shared steps sit at the top of `analysis/` and diverging threads get subfolders — continuing the numbering sequence.

```
├── data/
│   ├── raw/               # Original, unmodified data
│   └── processed/         # Cleaned and processed data files
├── scripts/               # Setup, data pulls, utilities (e.g., 00_setup.R)
├── analysis/
│   ├── 01_clean.R         # Shared; all downstream analyses load its output
│   ├── primary/
│   │   ├── 02_model.R
│   │   └── 03_figures.R
│   └── sensitivity/       # Optional parallel thread
│       ├── 02_model.R
│       └── 03_figures.R
├── reports/               # Quarto or R Markdown reports
```

---

### Variant 2: Methods Development

For projects centered on statistical methods, with simulations as the primary engine. Real data application is optional and secondary.

```
├── simulations/
│   ├── configs/           # Simulation parameter files
│   ├── 01_run.R           # Run or submit simulations
│   ├── 02_aggregate.R     # Aggregate results across runs
│   └── results/           # Saved outputs (consider gitignoring if large)
├── data/                  # Real data application (optional)
│   ├── raw/
│   └── processed/
├── analysis/              # Real-data analysis scripts, numbered (optional)
├── reports/               # Optional
```

---

### Variant 3: Lightweight

For smaller or exploratory projects that do not need a formal pipeline or reports. Functions and analysis scripts both live in `R/`; no numbering required but names should be descriptive.

```
├── data/
│   ├── raw/
│   └── processed/
├── R/                     # functions.R, explore.R, model.R, etc.
```

## Principles

These principles apply regardless of programming language or environment.

**The project lives under version control.**
All code, configuration, and documentation is tracked in a repository, enabling collaboration, rollback, and a record of not just what changed but why.

> *Example implementation (R/RStudio):*
>
> - Create under the [IrinaStatsLab](https://github.com/IrinaStatsLab) GitHub organization; start as private
> - Make public only when the project is ready to share
> - Do not push data unless it is public, small, and you have hosting rights
> - Commit regularly with meaningful messages — not as a single end-of-project dump
> - For manuscript submission, archive a permanent snapshot of the code (and data, if shareable) on [OSF](https://osf.io), [Zenodo](https://zenodo.org), or equivalent — many journals now require this, and a GitHub repository alone is not a permanent archive
> - See the lab's [coding resources](https://github.com/IrinaStatsLab/IrinaStatsLabResources) for commit style conventions

**The project is self-contained.**
Everything needed to run the analysis — code, dependency declarations, and data (or instructions to obtain it) — lives within the project.

> Data handling varies by project:
>
> | Data type | Approach |
> |---|---|
> | Small public data | Include in the repository |
> | Large public data | Exclude; provide a download script or sourcing instructions |
> | Confidential data | Exclude; document access requirements; consider a private repository |
>
> In all cases, the README must state how to obtain the data.

> *Example implementation (R/RStudio):*
>
> - Use [`renv`](https://rstudio.github.io/renv/) to manage packages
> - Run `renv::init()` at project setup; commit `renv.lock`
> - Collaborators run `renv::restore()` to recreate the environment
> - Run `renv::snapshot()` whenever packages change

**Raw data is never modified.**
Source data is read-only; all transformations happen in code and outputs go to separate locations.

> *Example implementation (R/RStudio):*
>
> - `data/raw/` is only ever read from — never written to
> - All cleaned outputs go to `data/processed/` or `output/rds/`
> - Optionally, make `data/raw/` read-only at the OS level as a safeguard

**Data is validated at each pipeline stage.**
After loading or transforming data, basic checks should be explicit in the code — not assumed. Validation catches problems early, before they silently propagate through the analysis and surface only in final results.

> *Example implementation (R/RStudio):*
>
> - After loading raw data: check dimensions, column names, and data types
> - After cleaning: check for unexpected missing values, impossible values, and distributions that look wrong
> - Useful tools: `stopifnot()` for hard assertions, `summary()`, `is.na()`, `table()` for quick inspection
> - Validation checks belong in the script itself, not only in the analyst's head

**File paths are relative to the project root.**
No hardcoded absolute paths — paths should resolve correctly on any machine without modification.

> *Example implementation (R/RStudio):*
>
> - **Preferred:** open the `.Rproj` file in RStudio; this sets the working directory to the project root automatically, so `"data/raw/myfile.csv"` just works
> - **Alternative:** `here::here("data", "raw", "myfile.csv")` constructs paths explicitly — useful in Quarto/RMarkdown where the working directory may differ, but can behave unexpectedly when file names are not unique across the project

**Code runs without manual intervention.**
No one should need to edit a line, change a working directory, or follow a "before you run this" comment to execute the code. Repeated values belong in a function or single configuration location, not copy-pasted inline.

> *Example implementation (R/RStudio):*
>
> - No `setwd()` anywhere in the project
> - No comments instructing someone to change a path or variable
> - No comment-in/comment-out blocks used as switches — if a step is conditional or optional, control it with a parameter or a separate script, not by manually uncommenting lines
> - All `library()` calls go at the top of the script — never mid-script; this makes dependencies immediately visible to anyone reading the code
> - One-time setup steps (dependency installation, configuration) go in `scripts/00_setup.R`

**Naming is consistent and intentional.**
Files, functions, and variables follow a predictable convention; good names communicate purpose without requiring a comment.

> *Example implementation (R/RStudio):*
>
> - `snake_case` for file names, functions, and variables ([tidyverse style guide](https://style.tidyverse.org/))
> - Scripts numbered to make order explicit: `01_clean.R`, `02_model.R`
> - Function names are verbs: `compute_age_group()`; data objects are nouns: `patient_visits`

**Functions and scripts are separated.**
Reusable logic lives in dedicated files; analysis scripts orchestrate, they do not define. Every function must document its inputs and outputs explicitly — not as an afterthought, but as part of writing the function.

> *Example implementation (R/RStudio):*
>
> - All reusable functions live in `R/`
> - Loaded at the top of any script that needs them: `source("R/plot_functions.R")`
> - Every function has a comment block stating what it takes as input, what it returns, and any important assumptions or side effects
> - Analysis scripts should read like a sequence of function calls, with implementation details out of sight

**Each analytical step is done exactly once.**
Every transformation or derivation happens in one place only; downstream scripts consume the output, they do not repeat the logic. Repeated code patterns belong in a function.

> *Example implementation (R/RStudio):*
>
> - Derived variables (e.g., age groups, composite scores) are created in `01_clean.R`, saved, and loaded as-is by all downstream scripts
> - If the same plot type is produced for multiple variables, a single function in `R/` handles it

**Scripts are modular and run in sequence.**
The analysis is broken into discrete, numbered stages; each stage reads its inputs and writes its outputs explicitly. The guiding question for where to split: *could you imagine wanting to rerun this step without rerunning everything before it?* If yes, it deserves its own script with saved outputs. Natural split points include data acquisition, cleaning, heavy computation (model fitting, simulations), exploratory analysis, figure generation, and table generation — though the right split depends on the project.

> *Example implementation (R/RStudio):*
>
> - Scripts in `analysis/` are numbered: `01_clean.R`, `02_model.R`, `03_figures.R`, …
> - Every script opens with a short header comment stating its purpose, its inputs (file paths), and its outputs (file paths) — this makes the pipeline readable without running anything
> - Each script saves its outputs so the next can load them fresh
> - Any script can be run independently — no need to rerun earlier steps
> - A script you expect to iterate on frequently (e.g., figures) should always be separate from slow upstream steps
> - Optionally, a `run_all.R` at the project root sources all scripts in order

**Intermediate outputs are saved.**
Each stage writes its outputs to disk; the next stage loads them. This avoids re-running expensive steps and makes each stage independently inspectable.

> *Example implementation (R/RStudio):*
>
> - R objects (model fits, processed data frames): `saveRDS()` → `output/rds/`, loaded with `readRDS()`
> - Human-readable or shareable outputs: `write_csv()` → `data/processed/` or `output/tables/`, loaded with `read_csv()`
> - If only figures need updating, the figures script reruns on its own — no data reprocessing needed

**Computation and presentation are separated.**
Heavy processing — data cleaning, model fitting, simulations — runs in dedicated scripts and saves its outputs. Downstream scripts load those outputs and focus solely on presentation. This keeps slow steps from blocking fast ones and allows figures, tables, or reports to be updated without re-running expensive computation.

> *Example implementation (R/RStudio):*
>
> - A simulation or modeling script saves results to `output/rds/`; a separate figures script loads and plots them
> - Quarto/RMarkdown reports load pre-computed outputs — they do not run the analysis
> - If a report is slow to render, that is a signal that computation belongs in a script, not the document

**All figures and tables are generated automatically by code.**
No manually edited outputs; if something needs to change, it changes in the code. Every figure and table in a manuscript or report must trace directly to a specific script and output file — this mapping should be explicit and maintained throughout the project.

> *Example implementation (R/RStudio):*
>
> - Never export figures by hand from the RStudio Plots pane — this includes clicking Export or Save in the Plots pane
> - Default format is **PDF** (vector-based, scales without quality loss; accepted by all major statistics journals, arXiv, and presentations); PNG is not publication quality
> - Preferred pattern: `pdf("output/figures/fig.pdf", width = 6, height = 4)` → plot → `dev.off()`
> - Other formats (`png()`, `ggsave()`, etc.) only when a journal or collaborator requires it
> - Tables saved with `write_csv()` or equivalent to `output/tables/`; when LaTeX output is needed, use packages such as `knitr::kable()`, `kableExtra`, or `gt` — never write LaTeX tables by hand
> - In Quarto/RMarkdown, figures and tables render inline directly from code
> - Each figure and table in the manuscript should be traceable to its script and output file (e.g., noted in comments or in the README pipeline table)

**Results are exactly reproducible.**
Given the same inputs, the pipeline produces identical outputs — this requires pinned packages, explicit seeds, and no hidden environment state. Running from a fresh session is the default, not the exception.

> *Example implementation (R/RStudio):*
>
> - `set.seed()` at the top of any script that uses randomness
> - For parallel simulation runs, `set.seed()` alone is not sufficient — use `RNGkind("L'Ecuyer-CMRG")` before setting the seed to ensure reproducibility across workers
> - `renv` pins package versions (see self-contained note above)
> - `renv::snapshot()` keeps `renv.lock` current as packages change
> - Do not suppress warnings with `suppressWarnings()` or `suppressMessages()` — warnings often indicate real problems; if a warning is genuinely ignorable, document why in a comment rather than silencing it
> - In RStudio, disable "Restore .RData into workspace at startup" and set "Save workspace to .RData on exit" to **Never** (Tools → Global Options → General) — the environment should always be rebuilt from code, never carried over from a previous session
> - Before finalizing any script, run it in a fresh R session to verify it works without leftover objects

**Analytical decisions are documented.**
Comment generously. Comments explain *why*, not *what* — but there should be many of them. Non-obvious choices in cleaning, modeling, or interpretation are noted where they occur. A collaborator or reviewer should be able to follow the logic of the code without asking questions.

> *Example implementation (R/RStudio):*
>
> - Comment every meaningful decision: why a variable was recoded this way, why a model was specified this way, why certain observations were excluded
> - When in doubt, add a comment — over-commenting is far less costly than under-commenting
> - For richer documentation, Quarto or R Markdown reports weave code, output, and written interpretation together

**Code is reviewed before submission.**
No code supporting a submitted manuscript, report, or public release should be unreviewed. A second set of eyes catches errors — including non-reproducible outputs and incorrect logic — that the original author cannot.

> *Example implementation (R/RStudio):*
>
> - Before submission, at least one lab member runs the full pipeline independently and verifies outputs match the manuscript
> - Review should confirm: scripts run without error, figures and tables match the manuscript, no results are hardcoded by hand

---

## Tools for Spotting Issues

No single tool catches everything. Use these in combination.

**AI-assisted review** (e.g., Posit Assistant, GitHub Copilot)
A useful first pass — can flag hardcoded values, missing comments, non-reproducible patterns, style inconsistencies, and suspicious logic before a human reviewer sees the code.

**Peer review**
The most important check. A lab member runs the full pipeline independently, verifies all outputs match the manuscript, and reads the code for clarity and correctness. No submission should skip this step.

**Static analysis**
- `lintr` — automatically checks R code for style violations, common errors, and suspicious patterns
- `styler` — auto-formats code to a consistent style, reducing noise in review

**Fresh session test**
Run the full pipeline in a clean R session with no objects in memory. Many reproducibility issues only surface this way. See the reproducibility principle above for how to configure RStudio to make this the default.

**Unit testing** *(especially for methods development projects)*
- `testthat` — write tests for individual functions in `R/` to verify they behave correctly; especially valuable when the correctness of core statistical functions is central to the work
