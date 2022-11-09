FROM rockylinux:8.6

WORKDIR /
ENV TZ=America/Los_Angeles
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.16.1.1-1.el8_6.x86_64

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ > /etc/timezone \
    && dnf -y install \
    epel-release \
    && dnf -y install \
    java-11-openjdk \
    mariadb-server \
    nginx \
    openssh-clients \
    openssh-server \
    passwd \
    python3-pip \
    sudo \
    tree \
    vim \
    wget \
    && dnf clean all && rm -rf /var/cache/dnf \
    && ssh-keygen -t rsa -b 4096 -N '' -f ~/.ssh/id_rsa && ssh-keygen -A \
    && echo docker | passwd root --stdin \
    && useradd rcon && echo password | passwd rcon --stdin \
    && usermod -a -G wheel rcon \
    && mkdir /home/rcon/.ssh \
    && ssh-keygen -t rsa -b 4096 -N '' -f /home/rcon/.ssh/id_rsa \
    && rm -f /var/run/nologin \
    && mkdir -p /opt/jetbrains \
    && wget -O /tmp/TeamCity-2022.04.4.tar.gz https://download.jetbrains.com/teamcity/TeamCity-2022.04.4.tar.gz \
    && tar -C /opt/jetbrains -xzf /tmp/TeamCity-2022.04.4.tar.gz \
    && rm -rf /tmp/TeamCity-2022.04.4.tar.gz \
    && useradd teamcity && echo password | passwd teamcity --stdin \
    && chown -R teamcity:teamcity /opt/jetbrains/TeamCity \
    && mkdir /opt/jetbrains/TeamCity/data \
    && mkdir /opt/jetbrains/TeamCity/logs \
    && mv /opt/jetbrains/TeamCity/webapps/ROOT /opt/jetbrains/TeamCity/webapps/teamcity \
    && mv /opt/jetbrains/TeamCity/conf/server.xml{,.ORIG}

COPY ./tls/privatekey.txt /etc/pki/tls/private/
COPY ./tls/certificate.txt /etc/pki/tls/certs/
COPY ./tls/teamcity.jks /etc/pki/tls/
COPY ./tls/authorized_keys /root/.ssh/authorized_keys
COPY ./tls/authorized_keys /home/rcon/.ssh/authorized_keys
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/setenv.sh /etc/profile.d/
COPY ./conf/server.xml /opt/jetbrains/TeamCity/conf/
COPY ./conf/configure_mariadb.sh /opt/jetbrains/TeamCity/bin/

RUN echo "JAVA_HOME: $JAVA_HOME" \
    && chmod 600 /root/.ssh/authorized_keys \
    && chmod 600 /home/rcon/.ssh/authorized_keys \
    && chown -R rcon:rcon /home/rcon/.ssh 

RUN /usr/libexec/mysql-prepare-db-dir
RUN test -d /var/run/mariadb || mkdir /var/run/mariadb; \
    chmod 0777 /var/run/mariadb; \
    /usr/bin/mysqld_safe --basedir=/usr & \
    sleep 10s \
    && /usr/bin/mysqladmin -u root password 'Ch4n63M3' \
    && mysqladmin shutdown --password='Ch4n63M3' \
    && wget -P /tmp https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-j-8.0.31-1.el8.noarch.rpm \
    && dnf -y -q install /tmp/mysql-connector-j-8.0.31-1.el8.noarch.rpm \
    && mkdir -p /opt/jetbrains/TeamCity/data/lib/jdbc \
    && cp /usr/share/java/mysql-connector-j.jar /opt/jetbrains/TeamCity/data/lib/jdbc/

CMD /usr/sbin/sshd ; /usr/sbin/nginx ; test -d /var/run/mariadb || mkdir /var/run/mariadb ; chmod 0777 /var/run/mariadb ; /usr/bin/mysqld_safe --basedir=/usr

