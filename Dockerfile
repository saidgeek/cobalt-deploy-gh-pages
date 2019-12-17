FROM lehmannka/cobalt.rs

RUN apt update && apt install -y git
COPY ./entrypoint.sh /entrypoint.sh

WORKDIR /src/

ENTRYPOINT [ "/entrypoint.sh" ]