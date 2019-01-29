##Usage

1. build the image
```sh
docker build -t android-ndk-maven .
```

3. build android application
```sh
docker run -it --rm \
  -v "$OPENCV_SRC":/opencv-android-sdk \
  -v "$MAVEN_REPO":/root/.m2 \
  -w /opencv-android-sdk/sdk/java \
  android-ndk-maven \
  mvn clean install -DskipTests
```