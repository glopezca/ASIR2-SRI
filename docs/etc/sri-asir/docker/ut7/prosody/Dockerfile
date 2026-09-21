FROM ubuntu:26.04
RUN apt-get update \
 && apt-get install -y --no-install-recommends prosody iproute2 \
 && rm -rf /var/lib/apt/lists/*
COPY prosody.cfg.lua /etc/prosody/prosody.cfg.lua
RUN prosodyctl check config
EXPOSE 5222
CMD ["prosody", "-F"]
