FROM nikolaik/python-nodejs:python3.8-nodejs12-alpine

# From https://github.com/corretto/corretto-docker/blob/master/11/jdk/alpine/Dockerfile
ARG version=11.0.9.12.1

RUN wget -O /THIRD-PARTY-LICENSES-20200824.tar.gz https://corretto.aws/downloads/resources/licenses/alpine/THIRD-PARTY-LICENSES-20200824.tar.gz && \
    echo "82f3e50e71b2aee21321b2b33de372feed5befad6ef2196ddec92311bc09becb  /THIRD-PARTY-LICENSES-20200824.tar.gz" | sha256sum -c - && \
    tar x -ovzf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    rm -rf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    wget -O /etc/apk/keys/amazoncorretto.rsa.pub https://apk.corretto.aws/amazoncorretto.rsa.pub && \
    SHA_SUM="6cfdf08be09f32ca298e2d5bd4a359ee2b275765c09b56d514624bf831eafb91" && \
    echo "${SHA_SUM}  /etc/apk/keys/amazoncorretto.rsa.pub" | sha256sum -c - && \
    echo "https://apk.corretto.aws" >> /etc/apk/repositories && \
    apk add --no-cache amazon-corretto-11=$version-r0

# Install gradle
RUN wget -O /gradle.zip https://services.gradle.org/distributions/gradle-6.7.1-bin.zip && \
  unzip -d /opt /gradle.zip && \
  rm /gradle.zip


ENV LANG C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV PATH=$PATH:/usr/lib/jvm/default-jvm/bin:/opt/gradle-6.7.1/bin

ENV SAM_CLI_TELEMETRY 0

RUN apk --update --no-cache add jq curl bash gcc git make musl-dev libc6-compat tar && \
  curl https://dl.google.com/go/go1.14.6.linux-amd64.tar.gz | tar -xvzf - -C /usr/local
ENV GOROOT /usr/local/go
ENV PATH ${PATH}:${GOROOT}/bin
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
