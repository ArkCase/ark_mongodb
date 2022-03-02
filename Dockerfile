FROM 345280441424.dkr.ecr.ap-south-1.amazonaws.com/ark_base:latest

LABEL ORG="Armedia LLC" \
      APP="Mongodb" \
      VERSION="1.0" \
      IMAGE_SOURCE=https://github.com/ArkCase/ark_mongodb \
      MAINTAINER="Armedia LLC"

ENV MONGO_USERID=2000 \
    MONGO_GROUPID=2020 \
    MONGO_GROUPNAME=mongod \
    MONGO_USER=mongod 

ARG MONGO_VERSION=5.0.6
#Install dependencies

RUN yum update -y && yum install -y libcurl openssl xz-libs &&\
    groupadd -g ${MONGO_GROUPID} ${MONGO_GROUPNAME} && \
    useradd -u ${MONGO_USERID} -g ${MONGO_GROUPNAME} ${MONGO_USER}
ENV MONGO_URL="https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-rhel70-${MONGO_VERSION}.tgz"
ENV MONGOSH_URL="https://downloads.mongodb.com/compass/mongosh-1.2.2-linux-x64.tgz"


WORKDIR /opt
ADD ${MONGO_URL} /opt/
ADD ${MONGOSH_URL} /opt/
RUN set -ex;\
    tar -xzvf mongodb-linux-x86_64-rhel70-${MONGO_VERSION}.tgz; tar -xzvf mongosh-1.2.2-linux-x64.tgz ;\
    rm mongodb-linux-x86_64-rhel70-${MONGO_VERSION}.tgz mongosh-1.2.2-linux-x64.tgz;\
    ln -s $(pwd)/mongodb-linux-x86_64-rhel70-${MONGO_VERSION}/bin/* /usr/local/bin/ ;\
    ln -s $(pwd)/mongosh-1.2.2-linux-x64/bin/* /usr/local/bin/ ;\
    mkdir -p /var/lib/mongo; mkdir -p /var/log/mongodb; \
    chown -R  ${MONGO_USER}:${MONGO_USER} /var/lib/mongo; chown -R  ${MONGO_USER}:${MONGO_USER} /var/log/mongodb;
EXPOSE 27017
USER ${MONGO_USER}

CMD [ "mongod","--dbpath","/var/lib/mongo"]
#,"--logpath","/var/log/mongodb/mongod.log"]