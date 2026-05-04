# Global Claude instructions

## GitHub issue fix workflow

When fixing a GitHub issue, follow this sequence:

1. **Work in a fresh git worktree branched off the latest `main`.** Fetch `origin/main` first; do not branch from whatever HEAD happens to be.
2. **Plan the fix before implementing.** Produce an explicit plan of the change before writing code.
3. **After implementing, make sure the pre-commit hook passes.** If it fails, fix the underlying issue rather than bypassing it (no `--no-verify`).
4. **Start the dev server with `vp run dev`** so the user can test the fix in the browser.
5. **Tell the user the dev server URL in the session** as soon as it's up — report whatever URL the server actually prints (typically `http://localhost:3000`).
6. **Always open a PR** for the GitHub issue once the fix is implemented and validated.

This applies to any request framed as "fix issue #N", "this GH issue", "the bug from <issue link>", or similar. It does not apply to ad-hoc edits or feature work the user requested directly without referencing an issue. If the user explicitly opts out of any step for a given task, respect that for the current task only — the default still holds next time.
