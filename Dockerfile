# version simplifiée M.H.  Yacinoxe
FROM ubuntu:20.04

# Variables d’environnement Hadoop
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV SPARK_HOME=/usr/local/spark

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

# Créer le dossier .ssh
RUN mkdir -p /root/.ssh

# Copier les fichiers de config Hadoop et SSH
COPY config/ssh_config /root/.ssh/config
COPY config/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh
COPY config/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY config/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY config/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY config/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
COPY config/workers $HADOOP_HOME/etc/hadoop/workers

# Copier les scripts
COPY config/start-hadoop.sh /root/start-hadoop.sh
COPY config/run-wordcount.sh /root/run-wordcount.sh

# Config Spark
COPY config/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf



# Activer SSH sans mot de passe
RUN ssh-keygen -t rsa -P '' -f /root/.ssh/id_rsa && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys && \
    chmod 0600 /root/.ssh/authorized_keys

WORKDIR $HADOOP_HOME

# Lancer le service SSH puis ouvrir un shell

#CMD [ "sh", "-c", "service ssh start; bash"]
CMD [ "sh", "-c", "service ssh start && tail -f /dev/null"]
