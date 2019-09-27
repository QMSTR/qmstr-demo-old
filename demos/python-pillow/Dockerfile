FROM qmstr/pythondemobase
RUN apt-get -qq update && DEBIAN_FRONTEND=noninteractive apt-get -y \
    install sudo xvfb \
    git wget python-virtualenv python-numpy python-scipy netpbm \
    python-pyqt5 ghostscript libffi-dev libjpeg-turbo-progs \
    python-dev python-setuptools \
    python3-dev cmake  \
    libtiff5-dev libjpeg8-dev libopenjp2-7-dev zlib1g-dev \
    libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev \
    python-tk python3-tk \
    libharfbuzz-dev libfribidi-dev && apt-get clean

VOLUME /buildroot

WORKDIR /buildroot/Pillow

# FIXME: ensure the installation of the necessary external libaries
# https://pillow.readthedocs.io/en/latest/installation.html#external-libraries
