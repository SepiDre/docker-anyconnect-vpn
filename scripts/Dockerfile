FROM debian
RUN apt-get update && apt-get install -y openconnect iptables expect

ENV ANYCONNECT_SERVER=""
ENV ANYCONNECT_USER=""
ENV ANYCONNECT_PASSWORD=""
ENV ServerCert=""
ENV RDPPort=""
ENV RDPGateway=""
ENV LasernetPort=""

ADD connect.sh /root
RUN chmod +x /root/connect.sh

CMD ["/root/connect.sh"]
