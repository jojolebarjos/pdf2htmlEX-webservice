
FROM alpine:3.8

RUN \
    apk --update --no-cache add \
        alpine-sdk \
        autoconf \
        automake \
        cairo-dev \
        cmake \
        coreutils \
        git \
        glib-dev \
        g++ \
        fontconfig-dev \
        freetype-dev \
        lcms2-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        libtool \
        libxml2-dev \
        m4 \
        make \
        nss-dev \
        openjpeg-dev \
        pango-dev \
        patch \
        perl \
        python-dev \
        tiff-dev \
        zlib-dev

WORKDIR /opt

RUN \
    git clone --branch poppler-0.63.0 --depth 1 https://github.com/jojolebarjos/poppler.git && \
    cd poppler && \
    cmake \
        -DBUILD_CPP_TESTS=OFF \
        -DBUILD_GTK_TESTS=OFF \
        -DBUILD_QT5_TESTS=OFF \
        -DCMAKE_BUILD_TYPE=Release \
        -DENABLE_CPP=OFF \
        -DENABLE_DCTDECODER=libjpeg \
        -DENABLE_GLIB=OFF \
        -DENABLE_GOBJECT_INTROSPECTION=OFF \
        -DENABLE_LIBCURL=OFF \
        -DENABLE_LIBOPENJPEG=openjpeg2 \
        -DENABLE_QT5=OFF \
        -DENABLE_SPLASH=ON \
        -DENABLE_UTILS=ON \
        -DENABLE_XPDF_HEADERS=ON \
        -DCMAKE_INSTALL_LIBDIR=lib && \
    make && \
    make install

RUN \
    git clone --depth 1 https://github.com/fontforge/libuninameslist.git && \
    cd libuninameslist && \
    autoreconf -i && \
    automake && \
    ./configure && \
    make && \
    make install

RUN \
    git clone --single-branch --branch 20170731 --depth 1 https://github.com/fontforge/fontforge.git && \
    cd fontforge && \
    ./bootstrap && \
    ./configure && \
    make && \
    make install

RUN \
    git clone --depth 1 https://github.com/Rockstar04/pdf2htmlEX.git && \
    cd pdf2htmlEX && \
    cmake \
        -DCMAKE_BUILD_TYPE=Release && \
    make && \
    make install
