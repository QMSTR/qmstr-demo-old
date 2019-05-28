FROM qmstr/demo

# install runtime deps
RUN apt-get update && apt-get install -y dpkg-dev debhelper libtool pkgconf libssl-dev libssh2-1-dev python dh-exec groff-base libgnutls28-dev libidn2-0-dev libkrb5-dev libldap2-dev libnghttp2-dev libnss3-dev libpsl-dev librtmp-dev openssh-server quilt stunnel4

VOLUME /buildroot

WORKDIR /buildroot/curl