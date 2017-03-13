#!/bin/bash

set -ex

if [ -z $ATTENDEE_SERVICE_DOMAIN ]; then
  echo "ATTENDEE_SERVICE_DOMAIN not set"
  exit 1
fi

if [ -z $ATTENDEE_SERVICE_HOSTNAME ]; then
  echo "ATTENDEE_SERVICE_HOSTNAME not set"
  exit 1
fi

echo "... updating apt-get and ensuring curl"
apt-get update && apt-get install -y curl

pushd attendee-service-source
  echo "Running smoke tests for Attendee Service deployed at $ATTENDEE_SERVICE_URL"
  smoke-tests/bin/test "http://$ATTENDEE_SERVICE_HOSTNAME-bg-rc.$ATTENDEE_SERVICE_DOMAIN"
popd

exit 0
