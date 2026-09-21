FROM ubuntu:26.04
RUN apt-get update \
 && apt-get install -y --no-install-recommends inn2 iproute2 netcat-openbsd \
 && rm -rf /var/lib/apt/lists/*
# INN normally uses port 119. We expose 8119 in the portable lab to avoid privileged-port assumptions.
RUN sed -i 's/^port: .*/port: 8119/' /etc/news/inn.conf || true
EXPOSE 8119
CMD ["/bin/bash", "-lc", "chown -R news:news /var/lib/news /var/spool/news 2>/dev/null || true; su -s /bin/bash news -c 'innd -d -f -P 8119'"]
