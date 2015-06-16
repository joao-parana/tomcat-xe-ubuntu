#### Projeto somaAdmin

Você deve executar:

    cd ~/Desktop/Development/tomcat-xe-ubuntu

Para build use : docker build -t parana/tomcat-xe-ubuntu

Para Start use : docker run -d -h db-server -p 1443:1443 -p 4422:22 -p 1521:1521 -p 8080:8080 --name mytomcat parana/tomcat-xe-ubuntu

Para Reiniciar use: docker restart mytomcat 

Para Stop use  : docker stop mytomcat

docker ps | grep tomcat-xe-ubuntu  **mostra o ID do container**

docker exec -i my_tomcat /bin/bash  **permite abrir uma shell no hosting do SOMA**

open http://192.168.59.103:1443 **Abre a página do site**

##### Arquivos Relevantes

Dockerfile
copy-tomcat-to-dev
help.md
**tomcat**
README.md
db-provision.sh     
**usr-app-soma**
