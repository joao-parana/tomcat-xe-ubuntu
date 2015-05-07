# Dependencia: https://github.com/joao-parana/web-xe-ubuntu
FROM parana/web-xe-ubuntu

# Responsável
MAINTAINER João Antonio Ferreira "joao.parana@gmail.com"

# Install tomcat8
ENV CATALINA_HOME     /usr/local/tomcat
ENV CATALINA_BASE     /usr/local/tomcat
ENV SOMA_HOME         /usr/local/soma
ENV SOMA_TBSPACE_DIR  /usr/local/soma/oradata
ENV ORACLE_HOME       /u01/app/oracle/product/11.2.0/xe
ENV ORACLE_SID        XE

ENV PATH $SOMA_HOME/bin:$ORACLE_HOME/bin:$CATALINA_HOME/bin:$PATH

RUN mkdir -p "$CATALINA_HOME"
RUN mkdir -p "$SOMA_HOME"
RUN mkdir -p "$SOMA_HOME/logs"
RUN mkdir -p "$SOMA_HOME/setup"

WORKDIR $CATALINA_HOME

# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
  05AB33110949707C93A279E3D3EFE6B686867BA6 \
  07E48665A34DCAFAE522E5E6266191C37C037D42 \
  47309207D818FFD8DCD3F83F1931D684307A10A5 \
  541FBE7D8F78B25E055DDEE13C370389288584E7 \
  61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
  79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
  9BA44C2621385CB966EBA586F72C284D731FABEE \
  A27677289986DB50844682F8ACB77FC2E86E29AC \
  A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
  DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
  F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
  F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.21
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
  && curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
  && curl -fSL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
  && gpg --verify tomcat.tar.gz.asc \
  && tar -xvf tomcat.tar.gz --strip-components=1 \
  && rm bin/*.bat \
  && rm tomcat.tar.gz*

RUN mkdir $CATALINA_HOME/shared
#
# RUN chmod 777 $CATALINA_HOME 
# RUN chmod 777 $CATALINA_HOME/conf
# RUN chmod 777 $CATALINA_HOME/shared
# RUN chmod 777 $CATALINA_HOME/webapps
# 
RUN mkdir -p  $SOMA_TBSPACE_DIR
# RUN chmod 777 $SOMA_TBSPACE_DIR

RUN echo 'SOMA_JDBC_USER=soma' >  $CATALINA_HOME/bin/setenv.sh
RUN echo 'SOMA_JDBC_PASS=soma' >> $CATALINA_HOME/bin/setenv.sh
RUN echo 'SOMA_JPA_LOG_FILE=$SOMA_HOME/logs/eclipselink.log' >> $CATALINA_HOME/bin/setenv.sh
RUN echo '#' >> $CATALINA_HOME/bin/setenv.sh
RUN echo '- - - - - - - - - - - - - -- - - - ' 
RUN cat  $CATALINA_HOME/bin/setenv.sh
RUN chmod a+rx $CATALINA_HOME/bin/setenv.sh
RUN mkdir -p $CATALINA_HOME/shared

# catalina.properties : na propriedade "common.loader" foi incluido no final 
# da linha o conteúdo abaixo:
#     ,"${catalina.base}/shared","${catalina.base}/shared/*.jar"
# Agora só precisamos copiar o arquivo pro lugar correto
# ADD tomcat/conf/catalina.properties $CATALINA_HOME/conf/catalina.properties
# RUN ls -lat $CATALINA_HOME/conf
# RUN grep common.loader $CATALINA_HOME/conf/catalina.properties

RUN echo '---- ls -lat /bin/start-oracle  ----' 
RUN ls -lat /bin | head
RUN echo '---- cat /bin/start-oracle  ----' 
RUN cat /bin/start-oracle
RUN echo '--------------------------------'
RUN echo '---- building start-oracle shell   ----' 
# doing : CMD ["catalina.sh", "run"]
RUN echo "#" > /bin/start-xe-and-jee.sh
RUN echo "#" >> /bin/start-xe-and-jee.sh
RUN echo "#" >> /bin/start-xe-and-jee.sh
RUN echo "echo I am going to RUN Tomcat 8 Application" >> /bin/start-xe-and-jee.sh
RUN echo 'echo `pwd` ' >> /bin/start-xe-and-jee.sh
RUN echo "echo Starting Tomcat 8" >> /bin/start-xe-and-jee.sh
RUN echo 'catalina.sh start' >> /bin/start-xe-and-jee.sh
RUN echo '/bin/start-oracle' >> /bin/start-xe-and-jee.sh
# RUN echo 'sleep 15' >> /bin/start-xe-and-jee.sh
# RUN echo 'echo "$1 $2 $3 $4 $5" >> $SOMA_HOME/logs/soma.log' >> /bin/start-xe-and-jee.sh
RUN chmod 777 /bin/start-xe-and-jee.sh
RUN echo '---- cat /bin/start-xe-and-jee.sh  ----' 
RUN cat /bin/start-xe-and-jee.sh

# Tomcat 8 Default port 8080 conflits with Apex
RUN sed -i -E "s/8080/1443/g" $CATALINA_HOME/conf/server.xml
# ADD tomcat/conf/server.xml $CATALINA_HOME/conf/server.xml
# RUN grep Listener $CATALINA_HOME/conf/server.xml
RUN echo '---- cat $CATALINA_HOME/conf/server.xml  ----' 
RUN cat $CATALINA_HOME/conf/server.xml

ADD db-provision.sh $SOMA_HOME/setup/db-provision.sh

EXPOSE 1443
EXPOSE 8080
EXPOSE 1521
EXPOSE 22

RUN echo 'É  necessário executar esse contêiner assim : docker run -d -h db-server -v ~/dev/shared:/usr/local/tomcat/shared  ... '

CMD ["sh", "/bin/start-xe-and-jee.sh", "Iniciando"]

