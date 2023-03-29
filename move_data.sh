#!/bin/bash

set -Eeuo pipefail

# Get the last PK
>&2 echo "Fetching the greatest primary key..."
pk="$(curl --fail --silent \
    "$URL?select=$PK_NAME&order=$PK_NAME.desc&limit=1" \
    --header "Authorization: Bearer $CONSUMER_TOKEN" \
    --header "Accept: text/csv" | tail --lines=1)"

# Empty table
if [ ! -n "$pk" ]
then
    >&2 echo "The table is empty."
    exit
fi

# Fetch the data and convert it
>&2 echo "Fetching the data..."
curl --fail --silent \
    "$URL?$PK_NAME=lte.$pk" \
    --header "Authorization: Bearer $CONSUMER_TOKEN" \
    --header "Accept: application/json" |
     mlr --ijson --ocsv --ofs tab --quote-none cat |
    awk -F$'\t' '{OFS=FS} { for (i=1; i<=NF; i++) $i=gensub(/^([0-9]{4}-[0-9]{2}-[0-9]{2})T([0-9]{2}:[0-9]{2}:[0-9]{2})([+-][0-9]{2}:[0-9]{2})$/, "\\1 \\2 \\3", "g", $i); print}' > exported.tsv

# Run the command
>&2 echo "Executing the program..."
"$@"
>&2 echo "Program executed successfully."

# Delete (optional)
if [ "$DELETE" = true ]
then
    >&2 echo "Deleting the original data..."
    curl --fail --silent --request DELETE \
        "$URL?$PK_NAME=lte.$pk" \
        --header "Authorization: Bearer $CONSUMER_TOKEN"
    >&2 echo "Data deleted."
fi
