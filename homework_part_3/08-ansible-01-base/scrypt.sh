!#/bin/bash


docker run --name ubuntu  -d pycontribs/ubuntu:latest sleep 999999999
docker run --name centos7 -d pycontribs/centos:7 sleep 999999999
docker run --name fedora -d pycontribs/fedora sleep 999999999
cd playbook
ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
docker stop ubuntu centos7 fedora
docker rm ubuntu centos7 fedora
