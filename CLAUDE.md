# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Plain static site: hand-written HTML + one CSS file. No build step, no JavaScript, no web fonts, no external requests.

```
index.html              home page: intro, dated notes, article list
cv/ projects/ bookmarks/ contact/   one index.html each (clean URLs)
articles/<slug>/        old blog posts (2021, converted from Hugo; same URLs)
about/                  redirect from old Hugo /about/ to /contact/
style.css               all styling; CSS variables at top for light + dark theme
```

## Preview

```sh
python3 -m http.server 8000
```

## Deploy

```sh
rsync -av --delete --exclude .git --exclude README.md --exclude LICENSE ./ user@host:/var/www/benni.tech/
```

## Adding content

**New note** — prepend one `<li>` to the Notes list in `index.html`:
```html
<li><span class="date">2026-10-06</span> Text of the note. <a href="...">link</a></li>
```

**New page or article** — copy an existing `*/index.html`, update `<title>` and content. For a new top-level page also add it to the `<nav>` in every page.

## CSS conventions

Colours are CSS variables defined at the top of `style.css` with a `@media (prefers-color-scheme: dark)` block overriding them. All styling lives in that single file — no inline styles, no per-page stylesheets.

## CSS versioning (cache-busting)

BunnyCDN caches CSS for 30 days. **When CSS changes**, always:

1. Bump `/* v: YYYY-MM-DD HH:MM */` at the top of every changed CSS file
2. Update `?v=YYYYMMDDHHММ` in all HTML files:
   ```sh
   VER=$(date +%Y%m%d%H%M)
   find . -name "*.html" -not -path "./.git/*" | xargs sed -i "s|style\.css?v=[0-9]*|style.css?v=$VER|g"
   ```

HTML-only changes do not need a version bump (HTML is served `no-cache`).

The pre-commit hook enforces this automatically.

## Git hooks

Hooks live in `.githooks/` and are activated via `git config core.hooksPath .githooks`.

After cloning, run once:
```sh
git config core.hooksPath .githooks
```

| Hook | Checks |
|------|--------|
| `pre-commit` | If CSS staged: verify `/* v: */` bumped and all HTML files staged |
| `commit-msg` | Conventional commits format |

## Commit message format

```
<type>(<scope>): <description>
```

Types: `feat` `fix` `docs` `style` `refactor` `chore` `perf` `ci`

Examples:
- `style(css): fix mobile padding on clean theme`
- `feat(hamradio): add new contest results`
- `fix(css): correct em dash encoding in comments`
- `chore: bump CSS version to 2026-10-19 19:41`
