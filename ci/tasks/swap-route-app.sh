#!/bin/bash

set -ex

echo "VARIABLES: 
  APP_ROUTE_HOSTNAME=$APP_ROUTE_HOSTNAME 
  APP_ROUTE_DOMAIN=$APP_ROUTE_DOMAIN
  CF_API=$CF_API
  CF_ORG=$CF_ORG
  CF_SPACE=$CF_SPACE
  CF_USER=$CF_USER"

echo "Getting Cloud Foundry CLI"
apt-get update
apt-get --assume-yes install wget
wget -q -O - https://packages.cloudfoundry.org/debian/cli.cloudfoundry.org.key | apt-key add -
echo "deb http://packages.cloudfoundry.org/debian stable main" | tee /etc/apt/sources.list.d/cloudfoundry-cli.list
apt-get --assume-yes install apt-transport-https
apt-get update
apt-get --assume-yes install cf-cli

echo "Attempting Cloud Foundry Login"
cf login -a $CF_API -o $CF_ORG -s $CF_SPACE -u $CF_USER -p $CF_PASSWORD --skip-ssl-validation
cf target
echo "Mapping the Blue-Green Release Candidate to Production Route"
cf map-route attendee-service-bluegreen-rc $APP_ROUTE_DOMAIN --hostname $APP_ROUTE_HOSTNAME
echo "Removing route to previous version"
cf unmap-route attendee-service $APP_ROUTE_DOMAIN --hostname $APP_ROUTE_HOSTNAME

echo "Done overtaking production route with release candidate"
cf apps

echo "Logging out of Cloud Foundry"
cf logout

echo "Done with task"
exit 0
