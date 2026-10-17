# benni.tech

Plain static site: hand-written HTML + one CSS file. No build step, no
JavaScript, no web fonts, no external requests.

```
index.html              first page: intro, dated notes (fefe-style), article list
cv/ projects/ bookmarks/ contact/   one index.html each (clean URLs)
articles/<slug>/        old blog posts (2021, converted from Hugo; same URLs)
about/                  redirect from the old Hugo /about/ page to /contact/
style.css               all styling; colours are CSS variables at the top (light + dark)
ping.txt                "ok\n" — tiny connectivity-check endpoint
```

## Add a note

Add one `<li>` at the top of the Notes list in `index.html`:

```html
<li><span class="date">2026-10-06</span> Text of the note. <a href="...">link</a></li>
```

## Add a page or article

Copy an existing `*/index.html`, change `<title>` and the content. For a new
top-level page also add it to the `<nav>` of every page.

## Preview locally

```sh
python3 -m http.server 8000   # or: busybox httpd -f -p 8000
```

## Deploy

Copy the files to any static web server document root, e.g.:

```sh
rsync -av --delete --exclude .git --exclude README.md --exclude LICENSE ./ user@host:/var/www/benni.tech/
```

## Use as an Internet check

```sh
curl -fsS --max-time 5 https://benni.tech/ping.txt   # prints "ok" when online
```

Exit code 0 = online. Serve `ping.txt` with caching disabled so a proxy/cache
can't answer for a dead uplink, e.g. nginx:

```nginx
location = /ping.txt { add_header Cache-Control "no-store"; }
```
