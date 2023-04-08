FROM python:3.11-slim-buster

RUN apt-get update; apt-get install -y wget unixodbc

RUN wget http://d5d4ifzqzkhwt.cloudfront.net/sqla16client/sqla16_client_linux_x86x64.tar.gz 
RUN tar -xzvf sqla16_client_linux_x86x64.tar.gz

RUN bash -c "./client1600/setup -nogui -I_accept_the_license_agreement -silent"
RUN rm /opt/sqlanywhere16/lib64/libodbcinst.so /opt/sqlanywhere16/lib64/libodbcinst.so.1

COPY asa.driver.template asa.driver.template
RUN . /opt/sqlanywhere16/bin64/sa_config.sh && odbcinst -i -d -f asa.driver.template

COPY odbc.ini /root/.odbc.ini

ENV SQLANY="/opt/sqlanywhere16"
ENV PATH="$SQLANY/bin64:$SQLANY/bin32:${PATH:-}"
ENV NODE_PATH="$SQLANY/node:${NODE_PATH:-}"
ENV LD_LIBRARY_PATH="$SQLANY/lib32:${LD_LIBRARY_PATH:-}"
ENV LD_LIBRARY_PATH="$SQLANY/lib64:${LD_LIBRARY_PATH:-}"
