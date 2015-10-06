from java

RUN mkdir /gerrit /data
WORKDIR /data
VOLUME /data
ENV GERRIT_VERSION 2.11.3
COPY runit.sh /gerrit/runit.sh
COPY etc /gerrit/etc
RUN chmod +x /gerrit/runit.sh
EXPOSE 8080
CMD /gerrit/runit.sh
