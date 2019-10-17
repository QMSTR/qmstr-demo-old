#!/bin/bash
set -e

source ../../build.inc

# connect targets to python-sqlalchemy-ext
LIBDIR=sqlalchemy/debian/python-sqlalchemy-ext/usr/lib/python2.7/dist-packages/sqlalchemy/
DOCDIR=sqlalchemy/debian/python-sqlalchemy-ext/usr/share/doc/python-sqlalchemy-ext/

qmstrctl create file:${DOCDIR}NEWS.Debian.gz
qmstrctl create file:${DOCDIR}changelog.Debian.gz
qmstrctl create file:${DOCDIR}copyright

qmstrctl connect package:python-sqlalchemy-ext_1.3.5+ds1-2_amd64.deb \
    file:hash:$(hashthis ${LIBDIR}cprocessors.x86_64-linux-gnu.so) \
    file:hash:$(hashthis ${LIBDIR}cresultproxy.x86_64-linux-gnu.so) \
    file:hash:$(hashthis ${LIBDIR}cutils.x86_64-linux-gnu.so) \
    file:${DOCDIR}NEWS.Debian.gz \
    file:${DOCDIR}changelog.Debian.gz \
    file:${DOCDIR}copyright


# connect targets to python3-sqlalchemy-ext
P3LIBDIR=sqlalchemy/debian/python3-sqlalchemy-ext/usr/lib/python3/dist-packages/sqlalchemy/
P3DOCDIR=sqlalchemy/debian/python3-sqlalchemy-ext/usr/share/doc/python3-sqlalchemy-ext/

qmstrctl create file:${P3DOCDIR}NEWS.Debian.gz
qmstrctl create file:${P3DOCDIR}changelog.Debian.gz
qmstrctl create file:${P3DOCDIR}copyright

qmstrctl connect package:python3-sqlalchemy-ext_1.3.5+ds1-2_amd64.deb \
    file:hash:$(hashthis ${P3LIBDIR}cprocessors.cpython-37m-x86_64-linux-gnu.so) \
    file:hash:$(hashthis ${P3LIBDIR}cresultproxy.cpython-37m-x86_64-linux-gnu.so) \
    file:hash:$(hashthis ${P3LIBDIR}cutils.cpython-37m-x86_64-linux-gnu.so) \
    file:${P3DOCDIR}NEWS.Debian.gz \
    file:${P3DOCDIR}changelog.Debian.gz \
    file:${P3DOCDIR}copyright
