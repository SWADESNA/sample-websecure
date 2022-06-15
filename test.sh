#!/usr/bin/env bash

# This test assume the project has already been deployed using either 'doctl sls' or AP

URL="$1"

# The following works if you have deployed to your sandbox namespace using doctl
# For AP, provide the URL as an argument

if [ -z "$URL" ]; then 
  URL=$(doctl sls fn get sample/hello --url)
fi
if [ -z "$URL" ]; then 
  echo "Could not determine URL"
  exit 1
fi

echo "Attempting to invoke without providing required auth"
NO_AUTH=$(curl -s "$URL" | jq -r .error)
if [ "$NO_AUTH" == "Authentication is possible but has failed or not yet been provided." ]; then
  echo "Rejected as expected"
else
  echo "Unexpected response '$NO_AUTH'"
  exit 1
fi

echo "Attempting to invoke while providing required auth in designated header"
AUTH=$(curl -s -H "X-Require-Whisk-Auth: well-not-very-secret-after-all" "$URL")
if [ "$AUTH" == "Hello stranger!" ]; then
  echo "Execution was successful"
else
  echo "Unexpected response '$AUTH'"
  exit 1
fi
