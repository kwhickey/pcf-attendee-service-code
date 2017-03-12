#!/bin/bash

set -ex

pushd attendee-service-source
  echo "Checking files are executable"
  ls -la
  echo "Fetching Dependencies and then Running Tests"
  ./mvnw clean compile test

#  echo "Running Tests"
#  ./mvnw test
popd

exit 0
