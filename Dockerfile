FROM ubuntu

#RUN groupadd -r autowp && useradd -r -g autowp -ms /bin/bash autowp

RUN echo "mysql-server mysql-server/root_password password autowp" | debconf-set-selections && \
    echo "mysql-server mysql-server/root_password_again password autowp" | debconf-set-selections && \
    apt-get update && apt-get install -y \
    php \
    curl \
    less \
    python3 \
    python3-pip \
    mysql-server

RUN rm -rf /var/lib/mysql && \
    mkdir -p /var/lib/mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

ENV MYSQL_ROOT_PASSWORD=autowp MYSQL_USERNAME=autowp MYSQL_PASSWORD=autowp MYSQL_DATABASE=autowp

WORKDIR /autowp

COPY my.cnf /etc/mysql/my.cnf

COPY run.sh ./

COPY ./autowp* ./
COPY ./*.py ./
COPY ./requirements.txt ./

RUN pip3 install -r requirements.txt

RUN bash ./run.sh

ENTRYPOINT ["python3", "./autowp"]

