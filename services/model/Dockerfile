FROM bash:alpine3.19 AS download

RUN apk update && apk add parallel aria2
COPY . . 
RUN chmod +x download.sh
ENTRYPOINT ["./download.sh"]