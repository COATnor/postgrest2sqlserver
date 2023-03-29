#!/bin/bash

set -Eeuo pipefail

pk="$(curl --fail --silent \
    "$URL?select=$PK_NAME&order=$PK_NAME.desc&limit=1" \
    --header "Authorization: Bearer $CONSUMER_TOKEN" \
    --header "Accept: text/csv" | tail --lines=1)"

curl --fail --silent \
    "$URL?$PK_NAME=lte.$pk" \
    --header "Authorization: Bearer $CONSUMER_TOKEN" \
    --header "Accept: application/json" |
     mlr --ijson --ocsv --ofs tab --quote-none cat > exported.tsv

"$@"

if [ "$DELETE" = true ]
then
    curl --fail --silent --request DELETE \
        "$URL?$PK_NAME=lte.$pk" \
        --header "Authorization: Bearer $CONSUMER_TOKEN"
fi
