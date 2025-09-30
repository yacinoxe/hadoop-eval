FROM ubuntu:20.04

# Variables d’environnement Hadoop
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Installer dépendances (Java + SSH)
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    ssh rsync vim curl wget \
    && rm -rf /var/lib/apt/lists/*

# Télécharger et installer Hadoop
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz \
    && tar -xvzf hadoop-3.3.6.tar.gz \
    && mv hadoop-3.3.6 $HADOOP_HOME \
    && rm hadoop-3.3.6.tar.gz

# Copier la config préparée
COPY config/* $HADOOP_HOME/etc/hadoop/

# Activer SSH pour la communication entre nœuds
RUN ssh-keygen -t rsa -P '' -f /root/.ssh/id_rsa \
    && cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

WORKDIR $HADOOP_HOME

CMD ["bash"]
