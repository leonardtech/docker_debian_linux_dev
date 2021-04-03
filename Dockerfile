FROM  leonardtech/debian_linux_dev:v1
MAINTAINER leonard_tech@aliyun.com

RUN apt-get update 
RUN apt-get -y install mate-desktop-environment
RUN apt-get -y install tightvncserver autocutsel


RUN rm -rf  /etc/init.d/startup.sh
COPY startup.sh /etc/init.d/startup.sh
RUN  chmod +x /etc/init.d/startup.sh

ADD xstartup /srv/xstartup
RUN chmod +x /srv/xstartup

#COPY vnc_init.sh /srv/vnc_init.sh
#RUN chmod +x /srv/vnc_init.sh

#COPY supervisord.conf /etc/supervisord.conf

EXPOSE 5900 22

ENTRYPOINT ["/etc/init.d/startup.sh"]

 
