#!/bin/sh

# Prebuild Android SDK components in to Maven repo `/root/.m2` when `/root/.m2` be mounted
# mvn -f /maven-android-sdk-deployer/repositories/pom.xml install

# mvn -f /maven-android-sdk-deployer/pom.xml install -P 5.0 # API Level 21, maven:android 5.0.1_r2 
# mvn -f /maven-android-sdk-deployer/pom.xml install -P 6.0 # API Level 23, maven:android 6.0_r3
# mvn -f /maven-android-sdk-deployer/pom.xml install -P 7.1 # API Level 25, maven:android 7.1.1_r3


# mvn -f /maven-android-sdk-deployer/pom.xml install
rsync -au $ANDROID_MAVEN_REPO/ /root/.m2/repository/

exec /usr/local/bin/mvn-entrypoint.sh "$@"