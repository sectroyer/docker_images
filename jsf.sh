#!/bin/bash
if [ "$1" == "bash" ]
then
	docker exec -it jsf bash
else
	docker run -p 4080:8080 --name jsf  "afinetraining/mojarra:2.2.4" 
	docker rm jsf
fi
