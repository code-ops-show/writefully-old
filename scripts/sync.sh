#!/bin/bash

set -o nounset
set -o errexit

ContentFolder="$1"
SiteName="$2"

SitePath="$1/$2"

# cd into the site content directory
cd $SitePath

# sync the changes from origin
git fetch origin master
git reset --hard FETCH_HEAD
git clean -df