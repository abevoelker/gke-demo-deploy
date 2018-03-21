#!/bin/bash
set -u

SUB_VARS='$PROJECT_ID:$BUCKET_NAME:$COMMIT_SHA:$CONNECTION_NAME'

# check required variables
for i in $(echo $SUB_VARS | tr ":" "\n")
do
  varname=${i:1}
  if [ -z "${!varname-}" ]; then
    echo "error: must provide variable \$$varname"
    exit 1
  fi
done

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
for f in $(find $DIR/templates -type f)
do
  [[ $f =~ $DIR\/templates(.*) ]] && export OUTPUT_FILE=".${BASH_REMATCH[1]}"
  mkdir -p $(dirname $OUTPUT_FILE)
  envsubst $SUB_VARS <$f >$OUTPUT_FILE
  echo $OUTPUT_FILE
done
