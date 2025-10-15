FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# --- Dependências básicas ---
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa openjdk-17-jdk wget sudo \
    clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++6 \
    && apt-get clean

# --- Flutter 3.24.5 ---
ENV FLUTTER_HOME=/opt/flutter
RUN git clone https://github.com/flutter/flutter.git -b 3.27.1 $FLUTTER_HOME
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"

# --- Android SDK ---
ENV ANDROID_SDK_ROOT=/opt/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
    cd ${ANDROID_SDK_ROOT}/cmdline-tools && \
    wget https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip -O sdk-tools.zip && \
    unzip sdk-tools.zip && \
    rm sdk-tools.zip && \
    mv cmdline-tools latest

ENV PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH"

# --- Instala SDKs Android ---
RUN yes | sdkmanager --licenses && \
    sdkmanager --sdk_root=$ANDROID_SDK_ROOT \
        "platform-tools" \
        "platforms;android-35" \
        "build-tools;35.0.0"

# --- Variáveis Java ---
ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
ENV PATH="$FLUTTER_HOME/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH"

# --- Atualiza Gradle e Kotlin ---
RUN mkdir -p /opt/gradle && \
    wget https://services.gradle.org/distributions/gradle-8.2-bin.zip -O /opt/gradle/gradle-8.2-bin.zip && \
    unzip -d /opt/gradle /opt/gradle/gradle-8.2-bin.zip && \
    rm /opt/gradle/gradle-8.2-bin.zip
ENV GRADLE_HOME=/opt/gradle/gradle-8.2
ENV PATH="$GRADLE_HOME/bin:$PATH"

ENV KOTLIN_VERSION=1.9.24
RUN wget https://github.com/JetBrains/kotlin/releases/download/v$KOTLIN_VERSION/kotlin-compiler-$KOTLIN_VERSION.zip -O /tmp/kotlin.zip && \
    unzip /tmp/kotlin.zip -d /opt/kotlin && \
    rm /tmp/kotlin.zip
ENV PATH="/opt/kotlin/kotlinc/bin:$PATH"

# --- Configuração Flutter ---
RUN flutter doctor -v
RUN flutter config --android-sdk $ANDROID_SDK_ROOT
RUN flutter precache --android

# --- Copia app ---
WORKDIR /app
COPY . /app

# --- Entrypoint ---
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
