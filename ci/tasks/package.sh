#!/bin/bash

set -e +x

sourcedir=attendee-service-source
outputdir=package-output
jarname=attendee-service.jar

echo "VARIABLES: \
  sourcedir=$sourcedir \
  outputdir=$outputdir \
  jarname=$jarname"

pushd $sourcedir
  echo "Packaging JAR"
  ./mvnw clean package -DskipTests
popd

jar_count=`find $sourcedir/target -type f -name *.jar | wc -l`

if [ $jar_count -gt 1 ]; then
  echo "More than one jar found at $sourcedir/target, don't know which one to deploy. Exiting"
  exit 1
fi

if [ $jar_count -eq 0 ]; then
  echo "No jar found at $sourcedir/target. Ensure it was built. Exiting"
  exit 1
fi

echo "Copying jar from $sourcedir/target to $outputdir/$jarname"
find $sourcedir/target -type f -name *.jar -exec cp "{}" $outputdir/$jarname \;

echo "Done packaging"
exit 0
