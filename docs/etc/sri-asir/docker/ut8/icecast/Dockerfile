FROM ubuntu:26.04
RUN apt-get update \
 && apt-get install -y --no-install-recommends icecast2 curl \
 && rm -rf /var/lib/apt/lists/*
COPY icecast.xml /etc/icecast2/icecast.xml
EXPOSE 8000
CMD ["icecast", "-c", "/etc/icecast2/icecast.xml"]
