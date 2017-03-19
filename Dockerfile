FROM couchbase:enterprise-4.6.1

MAINTAINER ceej@couchbase.com

# Oracle JDK.
RUN mkdir /tmp/deploy && \
    cd /tmp/deploy && \
    curl -L --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
        http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jre-8u121-linux-x64.tar.gz  -o jre.tgz && \
    cd /usr/local && \
    tar xvzf /tmp/deploy/jre.tgz && \
    ln -s jre* java && \
    for file in /usr/local/java/bin/*; do ln -s $file /usr/local/bin; done && \
    rm -rf /tmp/deploy
ENV JAVA_HOME=/usr/local/java

# Analytics.
COPY build /opt/couchbase
RUN chown -R couchbase:couchbase /opt/couchbase/cbas
COPY cbq-wrapper.sh /usr/local/bin/cbq

COPY analytics-entrypoint.sh /
ENTRYPOINT ["/analytics-entrypoint.sh"]
CMD ["analytics-demo"]


