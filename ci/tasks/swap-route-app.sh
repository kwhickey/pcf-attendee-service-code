#!/bin/bash

set -e +x

echo "VARIABLES: 
  APP_ROUTE_HOSTNAME=$APP_ROUTE_HOSTNAME 
  APP_ROUTE_DOMAIN=$APP_ROUTE_DOMAIN
  CF_API=$CF_API
  CF_ORG=$CF_ORG
  CF_SPACE=$CF_SPACE
  CF_USER=$CF_USER"

echo "Attempting Cloud Foundry Login"
cf login -a $CF_API -o $CF_ORG -s $CF_SPACE -u $CF_USER -p $CF_PASSWORD --skip-ssl-validation
cf target
echo "Mapping the Blue-Green Release Candidate to Production Route"
cf map-route attendee-service-bg-rc $APP_ROUTE_DOMAIN --hostname $APP_ROUTE_HOSTNAME
echo "Removing route to previous version"
cf unmap-route attendee-service $APP_ROUTE_DOMAIN --hostname $APP_ROUTE_HOSTNAME

echo "Done overtaking production route with release candidate"
cf apps

echo "Logging out of Cloud Foundry"
cf logout

echo "Done with task"
exit 0