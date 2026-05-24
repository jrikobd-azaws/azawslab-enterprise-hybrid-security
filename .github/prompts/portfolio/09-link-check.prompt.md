# Link and Final Quality Check

Read `STATUS.md` first.
Follow `.github/copilot-instructions.md`.

You are checking one completed document after edit.

## Target File

{{target_file}}

## Task

Review the target file for broken links, placeholder links, stale wording, source-truth drift, and public presentation quality.

## Check

1. All Markdown links are valid or intentionally marked as placeholders.
2. Image paths exist or are intentionally marked as diagram placeholders.
3. No stale `br.azawslab.co.uk` remains.
4. No defensive front-page language appears.
5. Release status matches `STATUS.md`.
6. Release 3 is roadmap/platform evolution.
7. A2, O4, O5, and O6 are complete and evidenced where mentioned.
8. Public writing is confident and human.
9. Tables render cleanly.
10. Text diagrams render cleanly.

## Required Output

Return:

1. Pass/fail summary
2. Broken or placeholder links
3. Wording issues
4. Evidence gaps
5. Recommended corrections
6. Suggested git commands