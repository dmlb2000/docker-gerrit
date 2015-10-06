docker run -i -t --rm --link gerrit-mysql:mysql -p 8080:8080 -v $HOME/gerrit/data:/data -e GERRIT_ADDR=192.168.99.100 --privileged gerrit
