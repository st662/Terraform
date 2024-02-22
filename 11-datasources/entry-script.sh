#!/bin/bash
sudo apt-get update -y 
sudo apt-get install docker.io -y
sudo systemctl start docker
sudo usermod -aG docker ubuntu
sudo docker run -p 8080:80 nginx