# This code is generated on Dockerfile
# so I don't need to copy this to image.
/bin/start-oracle
sleep 15
catalina.sh start # doing : CMD ["catalina.sh", "run"]
echo "$1 $2 $3 $4 $ $5" >> $SOMA_HOME/logs/soma.log
