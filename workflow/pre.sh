#!/usr/bin/env bash

master_image_name="devopsansiblede/baseimage"

# store current working directory
workingDir=$( pwd )

# change to directory of current script
cd "$( dirname $0 )"

# get branches to work on
echo "Branches / Apps are the next ToDo ... not implemented yet ..."

# get image name for current branch
echo "First of all, we are building the image base image “${master_image_name}”"
echo "::set-output name=base_image::${master_image_name}"

# get build-args for current branch
json=$( cat ./jdk_versions.json | jq -c )
echo "This list of tags will be built with Eclipse Adoptium OpenJDK version installed:"
echo "$json" | jq -r 'keys[] as $k | "   ◆ \($k):\t\(.[$k]) "'
echo "::set-output name=tag_jdk::$( echo "$json" | jq 'keys[] as $k | { "\($k)": "JDK_NAME=\(.[$k])" }' | jq -sc add )"
echo "::set-output name=tags::$( echo "$json" | jq -c '{ "tags": keys }' )"

# change dir back to working directory
cd "${workingDir}"
