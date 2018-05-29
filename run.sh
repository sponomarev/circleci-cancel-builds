#!/usr/bin/env sh

BASE_URL="https://circleci.com/api/v1.1/project/github/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}"
AUTH_PARAMS="circle-token=${CIRCLE_TOKEN}"

getRunningJobs() {
  local runningJobs

  runningJobs=$(curl -s -S "$BASE_URL/tree/$CIRCLE_BRANCH?$AUTH_PARAMS" | jq 'map(if .status == "running" then .build_num else "None" end) - ["None"] | .[]')
  echo "$runningJobs"
}

cancelRunningJobs() {
  local runningJobs
  runningJobs=$(getRunningJobs)

  for buildNum in $runningJobs;
  do
    echo Canceling "$buildNum"
    curl -s -S -X POST "$BASE_URL/$buildNum/cancel?$AUTH_PARAMS" > /dev/null
  done
}

cancelRunningJobs
