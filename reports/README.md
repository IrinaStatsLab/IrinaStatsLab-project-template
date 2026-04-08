# reports/

Internal reports and slide decks for this project.

Typical contents:
- Quarto documents (`.qmd`) rendered as HTML or PDF reports
- Quarto presentations (`.qmd` with `format: revealjs` or `format: pptx`)

Reports should read from `output/` rather than re-running analyses from scratch,
keeping rendering fast and ensuring outputs reflect the saved pipeline results:

```r
processed <- readRDS("output/rds/processed.rds")
```
