FROM ubuntu

RUN groupadd -r autowp && useradd -r -g autowp -ms /bin/bash autowp

RUN echo "mysql-server mysql-server/root_password password autowp" | debconf-set-selections && \
    echo "mysql-server mysql-server/root_password_again password autowp" | debconf-set-selections && \
    apt-get update && apt-get install -y \
    php \
    curl \
    less \
    python3 \
    python3-pip \
    mysql-server

RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o wp && \
    chmod +x wp && \
    chown autowp:autowp wp && \
    mv wp /usr/local/bin

USER autowp

WORKDIR /home/autowp

COPY ./autowp* /home/autowp/
COPY ./*.py /home/autowp/
COPY ./requirements.txt /home/autowp/

RUN pip3 install -r requirements.txt

CMD /usr/bin/mysqld --initialize

ENTRYPOINT ["python3", "./autowp"]

