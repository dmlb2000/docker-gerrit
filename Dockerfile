from java

RUN mkdir /gerrit /data
WORKDIR /data
VOLUME /data
RUN curl -L -o /gerrit/gerrit.war https://www.gerritcodereview.com/download/gerrit-2.11.3.war
COPY runit.sh /gerrit/runit.sh
COPY etc /gerrit/etc
RUN chmod +x /gerrit/runit.sh
EXPOSE 8080
CMD /gerrit/runit.sh
