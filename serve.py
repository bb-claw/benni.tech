#!/usr/bin/env python3
"""Dev server that mimics the nginx theme-switching logic for local preview."""
import http.server
import os

PORT = 8000
STYLES = {"mono", "brutal"}


class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        # Parse ?style= query param and strip it from path
        self._new_style = None
        if "?" in self.path:
            path, qs = self.path.split("?", 1)
            for part in qs.split("&"):
                if part.startswith("style="):
                    val = part[6:]
                    if val in STYLES:
                        self._new_style = val
            self.path = path

        # Active style: query param wins over cookie
        cookie_style = self._read_cookie("style")
        self._active_style = self._new_style or cookie_style or "mono"

        super().do_GET()

    def send_response(self, code, message=None):
        super().send_response(code, message)
        if getattr(self, "_new_style", None) and code == 200:
            self.send_header("Set-Cookie", f"style={self._new_style}; Path=/; SameSite=Lax")

    def copyfile(self, source, outputfile):
        path = self.path.split("?")[0]
        if path.endswith(".html") or path.endswith("/") or path == "":
            content = source.read()
            if getattr(self, "_active_style", "mono") == "brutal":
                content = content.replace(b"/style.css", b"/style-brutal.css")
            outputfile.write(content)
        else:
            super().copyfile(source, outputfile)

    def _read_cookie(self, name):
        for part in self.headers.get("Cookie", "").split(";"):
            part = part.strip()
            if part.startswith(name + "="):
                return part[len(name) + 1:]
        return None

    def log_message(self, fmt, *args):
        print(f"  {self.address_string()} {fmt % args}")


if __name__ == "__main__":
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    print(f"Serving benni.tech at http://localhost:{PORT}")
    print(f"  ?style=mono    — default theme")
    print(f"  ?style=brutal  — brutal theme")
    http.server.test(HandlerClass=Handler, port=PORT, bind="127.0.0.1")
