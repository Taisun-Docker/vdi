FROM lsiobase/ubuntu:bionic
LABEL maintainer="Thelamer"

RUN \
 echo "**** install deps ****" && \
 apt-get update && \
 DEBIAN_FRONTEND=noninteractive \
 apt-get install -y --install-recommends \
	apt-transport-https \
	ca-certificates \
	curl \
 	dbus-x11 \
	firefox \
	fuse \
	gawk \
	git \
	gnupg2 \
	libfuse2 \
	libx11-dev \
	libxfixes3 \
	libxml2 \
	libxrandr2 \
	pulseaudio \
	software-properties-common \
	sudo \
	terminator \
	tmux \
	vim \
	wget \
	x11-apps \
	x11-xserver-utils \
	xfce4 \
	xfce4-goodies \
	xfonts-base \
	xorgxrdp \
	xrdp \
	xserver-xorg-core \
	xutils \
	zlib1g && \
 curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
 add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
 apt-get update && \
 apt-get install -y --no-install-recommends \
	docker-ce && \
 echo "**** Cleanup and user perms ****" && \
 echo "abc:taisun" | chpasswd && \
 usermod -aG sudo abc && \
 apt-get autoclean && \
 rm -rf \
	/var/lib/apt/lists/* \
	/var/tmp/* \
	/tmp/*

# add local files
COPY /ubunturoot /

# ports and volumes
EXPOSE 3389
VOLUME /config
