FROM debian:8.7
MAINTAINER @vando

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
            binutils \
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

RUN mkdir /usr/local/src/es
WORKDIR /usr/local/src/es

RUN wget -qO - http://emulationstation.org/downloads/releases/emulationstation_amd64_latest.deb | ar x -
RUN mkdir DEBIAN &&\
    tar -zxC DEBIAN -f control.tar.gz
RUN sed -e '/^Depends/s/1.54.0/1.55.0/g' \
        -e 's/$/, libboost-date-time1.55.0/' \
	-i DEBIAN/control
RUN tar Jxf data.tar.xz && \
    rm control.tar.gz data.tar.xz debian-binary
RUN mv /usr/local/src/EmulationStation/emulationstation usr/bin
RUN find usr/ -type f -printf '%P ' | xargs md5sum > DEBIAN/md5sums
RUN dpkg -b . /usr/local/src/emulationstation_2.0.1a-1_amd64.deb
