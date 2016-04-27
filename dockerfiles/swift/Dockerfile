# This image uses serversideswift/swift as a base image. Take a look at the dockerfile at
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

WORKDIR /app

# copies Package.swift and fetches all packages. We do this here because this way we can use dockers
# caching layer and don't have to fetch every dependency whenever a tiny piece of code changes.
COPY ./Package.swift /app/Package.swift
RUN swift build --fetch

# copies the sources to /app and creates a new user called swift that owns the directory.
COPY ./Sources /app
RUN groupadd -r swift && useradd -r -g swift swift
RUN chown -R swift /app

# WARNING: SwiftyJSON takes around 30mins to build with release configuration, we are using the
# debug configuration for now until https://github.com/apple/swift/commit/2cdd7d64e1e2add7bcfd5452d36e7f5fc6c86a03
# is merged
RUN swift build --configuration debug -Xcc -fblocks -Xlinker -ldispatch -Xcc -I/usr/local/include/libbson-1.0/
USER SWIFT
CMD [".build/debug/#PROJECT_NAME#"]
# ----------------------------------------------------------------------------
# build the code with the release configuration and link blocks, ldispatch and libbson
#RUN swift build --configuration release -Xcc -fblocks -Xlinker -ldispatch -Xcc -I/usr/local/include/libbson-1.0/

#All commands that follow are run as the swift user. This is a layer of security. If someone manages
# to break into the running container and execute a remote shell, it won't be a root shell at least.
#USER swift
#CMD [".build/release/#PROJECT_NAME#"]
# ----------------------------------------------------------------------------