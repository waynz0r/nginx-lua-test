FROM danday74/nginx-lua
MAINTAINER Zsolt Varga <zsolt.varga@console.hu>

ADD lua /nginx/lua
COPY nginx.conf /nginx/conf/nginx.conf

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /nginx/logs/access.log \
    && ln -sf /dev/stderr /nginx/logs/error.log
