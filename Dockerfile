FROM debian:8.7
MAINTAINER @vando

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            build-essential \
            ca-certificates \
            cmake \
            fonts-droid \
            git \
            libasound2-dev \
            libboost-date-time-dev \
            libboost-filesystem-dev \
            libboost-locale-dev \
            libboost-system-dev \
            libcurl4-openssl-dev \
            libeigen3-dev \
            libfreeimage-dev \
            libfreetype6-dev \
            libgl1-mesa-dev \
            libsdl2-dev \
            openssl
	    
RUN git clone --depth=1 --branch=master https://github.com/Aloshi/EmulationStation.git /usr/local/src/EmulationStation
RUN cd /usr/local/src/EmulationStation && \
    cmake -DCMAKE_INSTALL_PREFIX=. && \
    make 

RUN mkdir -p /usr/local/src/es/usr/bin \
             /usr/local/src/es/usr/share/doc/emulationstation \
             /usr/local/src/es/etc/emulationstation
RUN cp /usr/local/src/EmulationStation/emulationstation /usr/local/src/es/usr/bin
ADD files/DEBIAN /usr/local/src/es/DEBIAN
ADD files/themes /usr/local/src/es/etc/emulationstation/themes
ADD files/copyright /usr/local/src/es/usr/share/doc/emulationstation/copyright
ADD files/changelog.Debian /tmp/changelog.Debian
RUN gzip -c /tmp/changelog.Debian > /usr/local/src/es/usr/share/doc/emulationstation/changelog.Debian.gz

RUN find /usr/local/src/es -type d -perm -2000 -exec chmod g-s {} \;
RUN cd  /usr/local/src/es && \
    find usr/ -type f -exec md5sum {} \; > DEBIAN/md5sums && \
    dpkg -b . /usr/local/src/emulationstation_2.0.1a-1_amd64.deb
