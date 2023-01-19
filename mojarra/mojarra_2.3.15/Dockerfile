FROM vulhub/java:11.0.8-jdk

LABEL maintainer="sectroyer <sectroyer@gmail.com>"
ENV PATH=${PATH}:/opt/maven/bin

RUN set -ex \
    && mkdir /opt/maven \
    && wget -qO- https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.6.3/apache-maven-3.6.3-bin.tar.gz | tar xz --strip-components 1 -C /opt/maven

COPY . /usr/src/
RUN set -ex \
    && cd /usr/src/ \
    && mvn -Dhttps.protocols=TLSv1.2 compile jetty:effective-web-xml

EXPOSE 8080
WORKDIR /usr/src
CMD ["mvn", "jetty:run"]
