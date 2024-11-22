#!/bin/bash

GITEA_URL="http://192.168.145.131:3000"
GITEA_TOKEN="4a82d013d0e60e799b567a71f73773a50c0f1902"

REPOS=("bit") # List of GitHub repositories

for repo in "${REPOS[@]}"
do
  curl -X POST "$GITEA_URL/api/v1/repos/migrate" \
    -H "Authorization: token $GITEA_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
      "clone_addr": "https://github.com/newcl/'"$repo"'.git",
      "uid": 1,
      "repo_name": "'"$repo"'"
    }'
done

