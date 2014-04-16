#!/bin/bash

set -o nounset
set -o errexit

git reset --hard HEAD
git pull origin master