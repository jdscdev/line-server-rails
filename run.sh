#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: ./run.sh <filename>"
  exit 1
fi

export LINE_SERVER_FILE=$1

bundle install
rails server
