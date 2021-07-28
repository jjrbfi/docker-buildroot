FROM ubuntu:20.04

MAINTAINER Jaime Roque Barrios <first.last.last@student.samk.fi>
LABEL Description="Ubuntu 20.04 - For Buildroot work enviroment with X11" Version="1.0"

# Software version
ENV BUILDROOT_VERSION='2021.02.3'

# Install packages without prompting the user to answer any questions
ENV DEBIAN_FRONTEND noninteractive 

# Install packages
RUN apt-get update && apt-get install -y \
locales \
lsb-release \
mesa-utils \
git \
subversion \
vim \
nano \
terminator \
xterm \
wget \
curl \
htop \
libssl-dev \
dbus-x11 \
software-properties-common \
build-essential \
ncurses-base \
ncurses-bin \
libncurses5-dev \
dialog \
gdb valgrind && \
apt-get clean && rm -rf /var/lib/apt/lists/*

# Locale
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN echo "LANG=en_US.UTF-8" > /etc/locale.conf
RUN locale-gen en_US.UTF-8

# Install Buildroot (Directory owner changed in entrypoint_setup.sh)
RUN wget https://www.buildroot.org/downloads/buildroot-$BUILDROOT_VERSION.tar.gz -O /opt/buildroot.tar.gz \
  && cd /opt \
  && tar -xf buildroot.tar.gz

# Terminator Config
RUN mkdir -p /root/.config/terminator/
COPY assets/terminator_config /root/.config/terminator/config 

# VIM Config
COPY assets/vim_config /root/.vimrc 

# Entry script - This will also run terminator
COPY assets/entrypoint_setup.sh /
ENTRYPOINT ["/entrypoint_setup.sh"]

# ---
CMD ["terminator"]
