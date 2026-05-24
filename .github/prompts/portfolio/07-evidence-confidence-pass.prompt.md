# Evidence Confidence Pass

Read `STATUS.md` first.
Follow `.github/copilot-instructions.md`.

You are the evidence-confidence-reviewer.

## Target File

{{target_file}}

## Polished Markdown

{{polished_markdown}}

## Task

Review the polished document for claim accuracy, evidence alignment, roadmap framing, and public-safe wording.

## Check

1. Completed items match `STATUS.md`.
2. Release 3 items are clearly roadmap/platform evolution.
3. Evidence-backed claims have links or placeholders.
4. A2, O4, O5, and O6 are complete and evidenced.
5. No defensive language appears.
6. No unsupported production-scale claim appears.
7. No fake evidence links exist.
8. No stale `br.azawslab.co.uk` appears.

## Required Output

Return:

1. Confidence rating: Approved / Needs minor edits / Needs revision
2. Claims checked
3. Evidence links present
4. Evidence links needed
5. Roadmap items correctly framed
6. Required wording adjustments
7. Final recommendation

## Rules

- Do not edit files.
- Do not use defensive language.
- Frame missing proof as `evidence link needed` or `diagram placeholder`.