FROM ubuntu:24.04

# پیش‌نیازها
RUN apt-get update && apt-get install -y wget apt-transport-https gnupg2 systemctl

# کپی اسکریپت کانفیگ
COPY setup-agent.sh /setup-agent.sh
RUN chmod +x /setup-agent.sh

# تعریف ENV برای IP و Hostname
ENV ZBX_SERVER=192.168.127.137
ENV HOSTNAME=my-agent

# اجرای اسکریپت هنگام run کانتینر
CMD ["/setup-agent.sh", "$ZBX_SERVER", "$HOSTNAME"]

