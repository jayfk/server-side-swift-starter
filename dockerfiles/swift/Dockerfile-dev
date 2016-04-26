# This image inherits from serversideswift/swift. Take a look at the dockerfile at
# https://github.com/serversideswift/swift-docker/blob/master/Dockerfile
FROM serversideswift/swift:DEVELOPMENT-SNAPSHOT-2016-03-24-a

# installs the mongoc driver and libbson
RUN curl -L https://github.com/mongodb/mongo-c-driver/releases/download/1.3.0/mongo-c-driver-1.3.0.tar.gz > mongo-c-driver-1.3.0.tar.gz && \
    tar xzf mongo-c-driver-1.3.0.tar.gz && \
    cd mongo-c-driver-1.3.0 && \
    ./configure && \
    make && \
    make install && \
    cp -lf /usr/local/lib/libbson* /usr/lib && \
    sed -i 's/<bson.h>/"bson.h"/g' /usr/local/include/libbson-1.0/bcon.h && \
    echo /usr/local/lib > /etc/ld.so.conf.d/mongoc.conf && \
    ldconfig

# Install inotify-tools for autoreload
RUN apt-get update && \
    apt-get install -y \
        inotify-tools && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /app

COPY ./dockerfiles/swift/autoreload.sh /autoreload.sh
CMD ["sh", "/autoreload.sh"]