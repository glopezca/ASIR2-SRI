FROM ubuntu:26.04
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      vsftpd openssh-server netcat-openbsd \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /run/sshd /srv/ftp/upload \
 && useradd -m -s /bin/bash alumno \
 && echo 'alumno:ASIR-Lab-2026!' | chpasswd \
 && chown alumno:alumno /srv/ftp/upload \
 && chmod 733 /srv/ftp/upload
COPY vsftpd.conf /etc/vsftpd.conf
RUN ssh-keygen -A
EXPOSE 21 22 40000-40009
CMD ["/usr/local/bin/start.sh"]
