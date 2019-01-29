#!/bin/sh
if [ -z "$DOCKER_IMAGE_NAME" ]; then
	echo "DOCKER_IMAGE_NAME env required"
	exit 1
fi

if [ ! -d "$PACKAGE_PATH" ]; then
	echo "PACKAGE_PATH env required"
	exit 1
fi
FILES_FROM_PACKAGE="
	filebeat-5.5.2-amd64.deb \
"
for file in $FILES_FROM_PACKAGE; do
	if [ ! -f "$file" ]; then
		cp -p $PACKAGE_PATH/$file . || exit 1
	fi
done

docker build -t $DOCKER_IMAGE_NAME .
