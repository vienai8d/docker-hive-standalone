FROM openjdk:8

WORKDIR /tmp

ENV HADOOP_VERSION=3.3.0
ENV HIVE_VERSION=3.1.2
ENV DERBY_VERSION=10.14.2.0
ENV HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
ENV HIVE_HOME=/opt/hive-$HIVE_VERSION
ENV DERBY_HOME=/opt/derby-$DERBY_VERSION
ENV PATH=$HADOOP_HOME/bin:$HIVE_HOME/bin:$DERBY_HOME/bin:$PATH

#
# Install Hadoop.
#
RUN wget https://ftp.jaist.ac.jp/pub/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz && \
    tar -zxvf hadoop-$HADOOP_VERSION.tar.gz && mv hadoop-$HADOOP_VERSION $HADOOP_HOME && \
    rm hadoop-$HADOOP_VERSION.tar.gz

#
# Install Hive.
#
RUN wget https://ftp.jaist.ac.jp/pub/apache/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
    tar -zxvf apache-hive-$HIVE_VERSION-bin.tar.gz && mv apache-hive-$HIVE_VERSION-bin $HIVE_HOME && \
    rm apache-hive-$HIVE_VERSION-bin.tar.gz
# Replace guava-19.jar which is bundled in Hive-3.1.2 to guava-27.0-jre.jar because which Hadoop-3.3.0 requires the new one.
RUN wget https://repo1.maven.org/maven2/com/google/guava/guava/27.0-jre/guava-27.0-jre.jar && \
    mv guava-27.0-jre.jar $HIVE_HOME/lib && rm $HIVE_HOME/lib/guava-19.0.jar

#
# Install Derby.
#
RUN wget https://downloads.apache.org//db/derby/db-derby-$DERBY_VERSION/db-derby-$DERBY_VERSION-bin.tar.gz && \
    tar -zxvf db-derby-$DERBY_VERSION-bin.tar.gz && mv db-derby-$DERBY_VERSION-bin $DERBY_HOME && \
    rm db-derby-$DERBY_VERSION-bin.tar.gz

#
# Initialize the metastore schema.
#
RUN schematool -dbType derby -initSchema

ENTRYPOINT ["hive"]
