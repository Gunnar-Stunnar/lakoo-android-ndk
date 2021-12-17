FROM openjdk:19-slim-buster
LABEL maintainer "William Chong <williamchong@lakoo.com>"

RUN mkdir -p /opt/android-sdk-linux && mkdir -p ~/.android && touch ~/.android/repositories.cfg
WORKDIR /opt

ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}:${ANDROID_HOME}/tools
ENV ANDROID_NDK /opt/android-ndk-linux
ENV ANDROID_NDK_HOME /opt/android-ndk-linux
# ENV SDKMANAGER_OPTS "--add-modules java.se.ee"

RUN apt-get update && apt-get install -y --no-install-recommends \
	unzip \
	wget
RUN cd /opt/android-sdk-linux && \
	wget -q --output-document=sdk-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-7583922_latest.zip && \
	unzip sdk-tools.zip && \
	rm -f sdk-tools.zip

RUN cd /opt/android-sdk-linux/cmdline-tools && mkdir tools && ls | grep -v tools | xargs mv -t tools

ENV PATH="/opt/android-sdk-linux/cmdline-tools/tools/bin:${PATH}"

RUN	echo y | sdkmanager "build-tools;28.0.3" "platforms;android-28"
RUN	echo y | sdkmanager "extras;android;m2repository" "extras;google;m2repository" "extras;google;google_play_services" && sdkmanager "cmake;3.6.4111459"
RUN wget -q --output-document=android-ndk.zip https://dl.google.com/android/repository/android-ndk-r23b-linux.zip && \
	unzip android-ndk.zip && \
	rm -f android-ndk.zip && \
	mv android-ndk-r23b android-ndk-linux
