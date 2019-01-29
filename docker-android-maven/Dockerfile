FROM maven:3.6.0-jdk-8
# x86_64

# RUN apt-get update && \
# 	apt-get install -y --no-install-recommends \
# 		db-util \
# 		locales \
# 		supervisor \
# 		vsftpd \
# 		logrotate \
# 	&& rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get autoclean && apt-get autoremove

# # install android ndk
# ENV ANDROID_NDK_HOME "/usr/local/android-ndk"
# COPY android-ndk-r13b-linux-x86_64.zip $ANDROID_NDK_HOME


# Download Android SDK
ENV SDK_URL "https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip"
ENV ANDROID_HOME "/usr/local/android-sdk"

RUN mkdir "$ANDROID_HOME" .android && \
    cd "$ANDROID_HOME" && \
    curl -o sdk.zip $SDK_URL && \
    unzip sdk.zip && \
    rm sdk.zip && \
    yes | $ANDROID_HOME/tools/bin/sdkmanager --licenses

# Update sdkmanager for futher installation
RUN touch /root/.android/repositories.cfg
RUN $ANDROID_HOME/tools/bin/sdkmanager --update

# Install Android Build Tool(Backward Compatible)
ENV ANDROID_BUILD_TOOLS_VERSION 28.0.3
RUN $ANDROID_HOME/tools/bin/sdkmanager \
    "platform-tools" \
    "build-tools;${ANDROID_BUILD_TOOLS_VERSION}" \
    "extras;android;m2repository" \
    "extras;google;m2repository"

# Install Libraries (Android Version 5.0, API Level 21)
ENV ANDROID_API_LEVEL 21
RUN $ANDROID_HOME/tools/bin/sdkmanager \
    "platforms;android-${ANDROID_API_LEVEL}" \
    "add-ons;addon-google_apis-google-${ANDROID_API_LEVEL}"

# Install Libraries (Android Version 6.0, API Level 23)
ENV ANDROID_API_LEVEL 23
RUN $ANDROID_HOME/tools/bin/sdkmanager \
    "platforms;android-${ANDROID_API_LEVEL}" \
    "add-ons;addon-google_apis-google-${ANDROID_API_LEVEL}"

# Install Libraries (Android Version 7.1, API Level 25)
ENV ANDROID_API_LEVEL 25
RUN $ANDROID_HOME/tools/bin/sdkmanager \
    "platforms;android-${ANDROID_API_LEVEL}"

# Install Maven Android SDK Deployer
ADD maven-android-sdk-deployer.tar.xz /
ENV ANDROID_MAVEN_REPO "/android/.m2/repository"

RUN mvn -f /maven-android-sdk-deployer/repositories/pom.xml install
# API Level 21, maven:android 5.0.1_r2 
RUN mvn -f /maven-android-sdk-deployer/pom.xml install -P 5.0
# API Level 23, maven:android 6.0_r3
RUN mvn -f /maven-android-sdk-deployer/pom.xml install -P 6.0
# API Level 25, maven:android 7.1.1_r3
RUN mvn -f /maven-android-sdk-deployer/pom.xml install -P 7.1

RUN mkdir -p $ANDROID_MAVEN_REPO
RUN mv /root/.m2/repository/* $ANDROID_MAVEN_REPO

WORKDIR /application

RUN apt-get update && \
  apt-get install -y --no-install-recommends \
      rsync \
      build-essential \
  && rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get autoclean && apt-get autoremove


COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["mvn"]