#!/bin/bash

set -ex

url=""

if [ -z $ATTENDEE_SERVICE_DOMAIN ]; then
  echo "ATTENDEE_SERVICE_DOMAIN not set"
  exit 1
fi

if [ -z $ATTENDEE_SERVICE_HOSTNAME ]; then
  echo "ATTENDEE_SERVICE_HOSTNAME not set"
  exit 1
fi

if [ -z $ATTENDEE_SERVICE_HOSTNAME_SUFFIX ]; then
  url="http://${ATTENDEE_SERVICE_HOSTNAME}.${ATTENDEE_SERVICE_DOMAIN}"
  echo "No suffix supplied to hostname. Using standard hostname. Full URL: $url"
else
  url="http://${ATTENDEE_SERVICE_HOSTNAME}-${ATTENDEE_SERVICE_HOSTNAME_SUFFIX}.${ATTENDEE_SERVICE_DOMAIN}"
  echo "Using a suffix on the hostname: $ATTENDEE_SERVICE_HOSTNAME_SUFFIX. Full URL: $url"
fi

echo "... updating apt-get and ensuring curl"
apt-get update && apt-get install -y curl

pushd attendee-service-source
  echo "Running smoke tests for Attendee Service deployed at: $url"
  smoke-tests/bin/test $url
popd

exit 0
