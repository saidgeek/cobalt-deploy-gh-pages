FROM lehmannka/cobalt.rs

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -yqq   \
      apt-utils \
      git
COPY ./entrypoint.sh /entrypoint.sh

WORKDIR /src/

ENTRYPOINT [ "/entrypoint.sh" ]