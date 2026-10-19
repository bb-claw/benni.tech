# .githooks/

Git hooks for this repository. Activate once after cloning:

```sh
git config core.hooksPath .githooks
```

## Hooks

| Hook | Trigger | Checks |
|------|---------|--------|
| `pre-commit` | every commit | If CSS staged: `/* v: */` comment bumped; all HTML files staged with updated `?v=` |
| `commit-msg` | every commit | Conventional commits format; passes merge/revert/fixup messages through |
| `pre-push` | every push | `CLAUDE.md` ≤ 200 lines; `memory/*.md` ≤ 150 lines each |

## Skip (emergencies only)

```sh
git commit --no-verify
git push --no-verify
```
