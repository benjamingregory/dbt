FROM openjdk:8-jre

ENV HADOOP_VERSION 2.9.2
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CONF_DIR /opt/hadoop/etc/hadoop

RUN apt-get update && \
  apt-get install -yf libpostgresql-jdbc-java procps openssh-server && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# get + unpack hadoop to /opt/hadoop
RUN mkdir ${HADOOP_HOME} && \
  curl http://apache.cs.utah.edu/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz -o hadoop.tar.gz && \
  tar -xf hadoop.tar.gz -C ${HADOOP_HOME} --strip-components=1 && \
  rm hadoop.tar.gz

# set up ssh for passwordless auth
# TODO: I don't think I need this if I don't have a cluster
# RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
# RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys
# RUN service ssh start
# # Do I need this?
# # RUN sed -i 's/^UsePAM yes/UsePAM no/g'

# copy our local configs over
COPY conf/* ${HADOOP_CONF_DIR}/

# helper script that starts sshd and runs an hdfs command (requires the passwordless auth + ssh + hdfs working)
# TODO: I don't think I need this if I don't have a cluster
# COPY run_hdfs.sh /usr/local/bin
# RUN chmod +x /usr/local/bin/run_hdfs.sh

# RUN run_hdfs.sh -mkdir -p /user/root
# RUN run_hdfs.sh -put ${HADOOP_HOME}/etc/hadoop/ input

COPY run_yarn.sh /usr/local/bin
RUN chmod +x /usr/local/bin/run_yarn.sh

# our config sets hadoop.tmp.dir to /hadoop, and these values derive from that.
RUN mkdir -p /hadoop/dfs/data /hadoop/dfs/name /hadoop/dfs/namesecondary && \
    ${HADOOP_HOME}/bin/hdfs namenode -format
VOLUME /hadoop

# 9000 - metadata
# 50010 - data
# 50020 - IPC
# 22 - ssh
EXPOSE 9000 50010 50020

CMD ["/opt/hadoop/bin/hdfs"]
