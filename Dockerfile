FROM node:6-slim

# ssh
ENV SSH_PASSWD "root:Docker!"
RUN apt-get update \
        && apt-get install -y --no-install-recommends dialog \
        && apt-get update \
    && apt-get install -y --no-install-recommends openssh-server \
    && echo "$SSH_PASSWD" | chpasswd 

WORKDIR /usr/local/bin/

COPY . .
RUN chmod u+x init.sh
RUN mv sshd_config /etc/ssh/
RUN mv init.sh /usr/local/bin/

# install nginx
RUN apt-get install -y nginx
RUN npm install -g pm2

RUN sed -i -e 's/\r$//' /usr/local/bin/init.sh

EXPOSE 2222
EXPOSE 80
CMD [ "init.sh" ]