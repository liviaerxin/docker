## Install Android SDK
[Use sdkmanager to Manage Android SDK](https://developer.android.com/studio/command-line/sdkmanager)  
[Android Version Number with API Level and NDK releases](https://source.android.com/setup/start/build-numbers)  

### Default SDK Version
So far, this image has some default Android SDK of versions including 5.0, 6.0 and 7.1

To add other SDK version, add following code to `Dcokerfile`. 
```sh
# Install Libraries (Android Version 6.0, API Level 23)
ENV ANDROID_API_LEVEL 23
RUN $ANDROID_HOME/tools/bin/sdkmanager \
    "platforms;android-${ANDROID_API_LEVEL}" \
    "platform-tools" \
    "add-ons;addon-google_apis-google-${ANDROID_API_LEVEL}"
```
Futher, managing the SDK version in the image can be implemented by a wrapper script and pass variables when building this docker image. 


## Build Android via Maven
When leveraging the power of Apache Maven to build a Android application, the procedure primarily involves two steps.
1. Install components of the Android SDK such as the necessary libraries into a local Maven Repository.
[Android SDK Jar not in any Maven Repo](https://stackoverflow.com/questions/5253029/why-arent-the-android-sdk-jars-in-any-maven-repository)  
[Maven Android SDK Deployer](https://github.com/simpligility/maven-android-sdk-deployer)  
2. Use Android Maven Plugin to build the Android application.
[~~Spring Android and Maven With Jayway~~](http://spring.io/blog/2010/12/17/spring-android-and-maven-part-1/)  
[~~Jayway Depeicated~~](https://github.com/jayway/maven-android-plugin-samples)  
[Android Maven Plugin](http://simpligility.github.io/android-maven-plugin/)  

##Usage

1. define env
```sh
export DOCKER_IMAGE_NAME=android-maven
docker volume create --name maven-repo
export MAVEN_REPO=maven-repo
```
`$MAVEN_REPO` can also be a docker volume created by docker, here we use the local `.m2` directory.

2. build the image
```sh
docker build -t $DOCKER_IMAGE_NAME .
```

3. build android application
```sh
docker run -it --rm \
  -v "$OPENCV_SRC":/opencv-android-sdk \
  -v "$MAVEN_REPO":/root/.m2 \
  -w /opencv-android-sdk/sdk/java \
  $DOCKER_IMAGE_NAME \
  mvn clean install -DskipTests
```