#!/bin/bash

set -ex

pushd attendee-service-source
  echo "Checking files are executable"
  ls -la
  echo "Fetching Dependencies"
  ./mvnw clean compile > /dev/null

  echo "Running Tests"
  ./mvnw test
popd

exit 0
