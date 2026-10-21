# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Plain static site: hand-written HTML + one CSS file. No build step, no JavaScript, no web fonts, no external requests.

```
index.html              home page: bio, Mini Feed (3 items), changelog link
cv/ projects/ bookmarks/ contact/   one index.html each (clean URLs)
articles/<slug>/        old blog posts (2021, converted from Hugo; same URLs)
about/                  redirect from old Hugo /about/ to /contact/
style-clean.css         default theme (beige/hister)
style-mono.css          terminal/monospace theme
style-brutal.css        brutalist theme
ping.txt                "ok\n" — connectivity-check endpoint (linked from footer)
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

**New mini feed entry** — prepend one `<li>` to the Mini Feed list in `index.html` and remove the oldest so exactly 3 remain:
```html
<li><span class="date">YYYY-MM-DD</span> Text of the note. <a href="...">link</a></li>
```

**New page or article** — copy an existing `*/index.html`, update `<title>`, `<meta name="description">`, and content. For a new top-level page also add it to the `<nav>` in every page.

**New article checklist** — after creating the article:
1. Prepend a `<li>` to `articles/index.html`
2. Prepend an `<item>` to `rss.xml` and update `<lastBuildDate>` (RFC 822: `LC_TIME=en_US.UTF-8 date -d "YYYY-MM-DD" '+%a, %d %b %Y 00:00:00 +0000'`)
3. Prepend a `<li>` to `changelog/index.html`

**Meta descriptions** — every page must have `<meta name="description" content="...">` between the viewport meta and `<title>`. Keep it under 160 characters. `about/index.html` (redirect) is exempt.

**Changelog** — update `changelog/index.html` whenever visible content changes (not for tooling or CSS-only changes). Prepend one `<li>`:
```html
<li><span class="date">YYYY-MM-DD</span> Description of the change.</li>
```

## CSS conventions

Three themes: `style-clean.css` (default), `style-mono.css`, `style-brutal.css`. Colours are CSS variables at the top of each file with a `@media (prefers-color-scheme: dark)` block. No inline styles, no per-page stylesheets.

## CSS versioning (cache-busting)

BunnyCDN caches CSS for 30 days. **When CSS changes**, always:

1. Bump `/* v: YYYY-MM-DD HH:MM */` at the top of every changed CSS file
2. Update `?v=YYYYMMDDHHММ` in all HTML files:
   ```sh
   VER=$(date +%Y%m%d%H%M)
   find . -name "*.html" -not -path "./.git/*" | xargs sed -i "s|style-clean\.css?v=[0-9]*|style-clean.css?v=$VER|g"
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
