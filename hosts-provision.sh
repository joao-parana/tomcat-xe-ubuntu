#!/bin/bash

sudo echo "127.0.0.1          localhost  aquis-manager data-server soma-conf-server" >> /etc/hosts
sudo echo "127.0.0.1          opc-server" >> /etc/hosts
sudo echo "192.168.1.162      database-server" >> /etc/hosts
sudo echo "127.0.0.1          jms-soma-server" >> /etc/hosts
sudo echo "127.0.0.1          soma-conf-server" >> /etc/hosts