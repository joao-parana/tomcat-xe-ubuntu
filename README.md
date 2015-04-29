parana/tomcat-xe-ubuntu
====================

Oracle Java JDK 8 plus Oracle Express Edition 11g Release 2 on Ubuntu 14.04.1 LTS

This **Dockerfile** is a [trusted build](https://registry.hub.docker.com/u/parana/tomcat-xe-ubuntu/) of [Docker Registry](https://registry.hub.docker.com/).

### Based on parana/web-xe-ubuntu Image

### Installation

```
docker pull parana/tomcat-xe-ubuntu
```

Define in your .bash_profile this utility function:

```
docker-ip() { 
  boot2docker ip 2> /dev/null 
} 
```

Run as a daemon with 8080, 22 and 1521 ports opened and mapped, setting the hostname to db-server use the command:

```
docker run -d -h tomcat-server -p 1443:8080 -p 4422:22 -p 1521:1521 --name mytomcat parana/tomcat-xe-ubuntu
```

Connect database with following setting:

```
hostname: localhost
port: 1521
sid: xe
username: system
password: oracle
```

Password for SYS & SYSTEM is

```
oracle
```
From your MAC OSX terminal:

```
sqlplus system/oracle@$(docker-ip):1521/XE
```

Login by SSH 

```
ssh root@$(docker-ip) -p 4422
password: admin
```

Connect via WebBrowser with following setting:

hostname: $(docker-ip)
port: 1443

```
open http://$(docker-ip):1443
```

To stop mytomcat container use:

```
docker stop mytomcat
```

To remove mytomcat container use:

```
docker rm mytomcat
```

To see mytomcat container details use:

```
docker ps | grep mytomcat 
```

To remove an old container and start a new one use:

```
docker rm mytomcat 2> /dev/null  ; docker run -d -h tomcat-server -p 1443:8080 -p 44222:22 -p 1521:1521 --name mytomcat parana/tomcat-xe-ubuntu 
```

Another usefull shell. 

Save this on your `~/bin/` directory as `docker-clean` file:

```
#!/bin/sh                                                                                                                                                                            

remove_dangling() {
  echo "Removing dangling images ..."
  docker rmi $(docker images -f dangling=true -q)
}


remove_stopped_containers() {
   echo "Removing stopped containers ..."
   docker rm $(docker ps -qa)
}

case $1 in
   images)
       remove_dangling
       ;;
   containers)
       read -p "Are you sure you want to remove all stopped containers?" -n 1 -r
       echo  #
       if [[ $REPLY =~ ^[Yy]$ ]]
       then
           remove_stopped_containers
       fi
       ;;
   *)
       echo "usage: docker-clean containers|images   -  containers - removes all stopped containers it can.   images - removes dangling (un-needed) image layers - images you no longer need"
       ;;

esac

```

Chears !
