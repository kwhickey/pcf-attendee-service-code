#!/bin/bash

set -e +x

APP_BG_RC_ROUTE_HOSTNAME="$APP_ROUTE_HOSTNAME-bg-rc"

echo "VARIABLES: 
  APP_ROUTE_DOMAIN=$APP_ROUTE_DOMAIN
  APP_ROUTE_HOSTNAME=$APP_ROUTE_HOSTNAME 
  APP_BG_RC_ROUTE_HOSTNAME=$APP_BG_RC_ROUTE_HOSTNAME
  CF_API=$CF_API
  CF_ORG=$CF_ORG
  CF_SPACE=$CF_SPACE
  CF_USER=$CF_USER"

echo "Attempting Cloud Foundry Login"
cf login -a $CF_API -o $CF_ORG -s $CF_SPACE -u $CF_USER -p $CF_PASSWORD --skip-ssl-validation
cf target
echo "Unmap blue-green release candidate temporary route"
cf unmap-route attendee-service-bg-rc $APP_ROUTE_DOMAIN --hostname $APP_BG_RC_ROUTE_HOSTNAME
echo "Delete previous production version"
cf delete attendee-service
echo "Rename blue-green release candidate app to production app"
cf rename attendee-service-bg-rc attendee-service

echo "Done with blue-green cleanup"
cf apps

echo "Logging out of Cloud Foundry"
cf logout

echo "Done with task"
exit 0
