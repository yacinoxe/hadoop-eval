# version simplifiee M.H.  Yacinoxe
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
#COPY config/* $HADOOP_HOME/etc/hadoop/
RUN mv /tmp/ssh_config ~/.ssh/config && \
    mv /tmp/hadoop-env.sh /usr/local/hadoop/etc/hadoop/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml && \
    mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml && \
    mv /tmp/workers $HADOOP_HOME/etc/hadoop/workers && \
    mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
    mv /tmp/run-wordcount.sh ~/run-wordcount.sh && \
    mv /tmp/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf && \
    mv /tmp/purchases.txt /root/purchases.txt && \
    mv /tmp/purchases2.txt /root/purchases2.txt
 
# Activer SSH pour la communication entre nœuds
#RUN ssh-keygen -t rsa -P '' -f /root/.ssh/id_rsa \
 #   && cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys
 
# ssh without key Hadoop a besoin de SSH sans mot de passe pour lancer ses démons , donc génération de clés, ajout dans authorized_keys
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys
 
WORKDIR $HADOOP_HOME
 
#CMD ["bash"]
# Lance le service SSH  Ouvre un shell interactif bash
CMD [ "sh", "-c", "service ssh start; bash"]
