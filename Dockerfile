FROM ubuntu:16.04

ENV DEX_TOOLS_VERSION "2.0"
ENV APKTOOL_VERSION "2.4.1"
ENV JD_CMD_VERSION "0.9.1.Final"
ENV PROCYON_VERSION "0.5.36"

RUN DEBIAN_FRONTEND=noninteractive

RUN apt-get -qq update
RUN apt-get -yqq upgrade

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install --fix-missing -y -f openjdk-8-jre
RUN apt-get install -yqq unzip wget

RUN mkdir /tools

# Install Procyon Tools

RUN mkdir /tools/procyon
RUN wget -q -O "/tools/procyon/procyon.jar" "https://bitbucket.org/mstrobel/procyon/downloads/procyon-decompiler-$PROCYON_VERSION.jar"
RUN chmod +x "/tools/procyon/procyon.jar"

# Install Dex Tools

RUN wget -q -O "dex-tools.zip" "https://github.com/pxb1988/dex2jar/releases/download/$DEX_TOOLS_VERSION/dex-tools-$DEX_TOOLS_VERSION.zip"
RUN unzip -q "dex-tools.zip" -d /tools
RUN mv "/tools/dex2jar-$DEX_TOOLS_VERSION" "/tools/dex-tools"
RUN find "/tools/dex-tools" -type f -name "*.sh" -exec chmod +x {} \;

# Install APK Tool

RUN mkdir /tools/apktool
RUN wget -q -O "/tools/apktool/apktool" "https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool"
RUN chmod +x "/tools/apktool/apktool"
RUN wget -q -O "/tools/apktool/apktool.jar" "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_$APKTOOL_VERSION.jar"
RUN chmod +x "/tools/apktool/apktool.jar"

# Install jd-cmd

RUN wget -q -O "jd-cmd.zip" "https://github.com/kwart/jd-cmd/releases/download/jd-cmd-$JD_CMD_VERSION/jd-cli-$JD_CMD_VERSION-dist.zip"
RUN mkdir /tools/jd-cmd
RUN unzip -q "jd-cmd.zip" -d /tools/jd-cmd
RUN chmod +x "/tools/jd-cmd/jd-cli"

RUN apt-get autoremove -yqq
RUN apt-get clean
RUN rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /work
VOLUME ["/work"]