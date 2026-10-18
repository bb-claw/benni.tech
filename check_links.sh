#!/bin/bash

set -u

USER_AGENT="Mozilla/5.0 (X11; Linux x86_64; rv:103.0) Gecko/20100101 Firefox/103.0"
err_count=0

while read url; do
  echo -ne "** $url  --> "
  resp_code=$(curl -o /dev/null --no-progress-meter -w "%{http_code}\n" -A "$USER_AGENT" -L "$url" 2>/dev/null || echo $?)

  if [ "$resp_code" != "200" ]; then
    let "err_count = err_count + 1" || true
    echo " *** ERROR: $resp_code ***"
  else
    echo " OK"
  fi
done < <(
  grep -roh 'href="[^"]*"' *.html **/index.html \
    | sed 's/href="//;s/"//' \
    | grep -v '^/' \
    | grep -v '^#' \
    | grep -v '^mailto:' \
    | sort -u
)

echo "NUMBER_OF_ERRORS: $err_count"
exit $err_count
