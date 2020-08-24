FROM debian
RUN apt-get update && apt-get install -y openconnect nftables expect route 

ADD connect.sh /root
RUN chmod +x /root/connect.sh

CMD ["/root/connect.sh"]
