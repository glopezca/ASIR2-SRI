FROM ubuntu:26.04
RUN apt-get update \
 && apt-get install -y --no-install-recommends inspircd iproute2 \
 && rm -rf /var/lib/apt/lists/*
EXPOSE 6667
CMD ["inspircd", "--nofork", "--nolog", "--runasroot"]
