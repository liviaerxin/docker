FROM android-maven:latest
# IMAGE WILL INCLUDE JDK, MAVEN, AND ANDROID SDK/NDK

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
		file \
	&& rm -rf /var/lib/apt/lists/* && apt-get clean && apt-get autoclean && apt-get autoremove

# # install android ndk
# ENV ANDROID_NDK_HOME "/usr/local/android-ndk"
# COPY android-ndk-r13b-linux-x86_64.zip $ANDROID_NDK_HOME

# Download Android NDK
ENV NDK_URL "https://dl.google.com/android/repository/android-ndk-r13b-linux-x86_64.zip"
ENV NDK "/usr/local/android-ndk-r13b"

RUN cd /usr/local/ && \
    curl -o ndk.zip $NDK_URL && \
    unzip ndk.zip && \
    rm ndk.zip

ENV PATH $PATH:$NDK