         ___        ______     ____ _                 _  ___  
        / \ \      / / ___|   / ___| | ___  _   _  __| |/ _ \ 
       / _ \ \ /\ / /\___ \  | |   | |/ _ \| | | |/ _` | (_) |
      / ___ \ V  V /  ___) | | |___| | (_) | |_| | (_| |\__, |
     /_/   \_\_/\_/  |____/   \____|_|\___/ \__,_|\__,_|  /_/ 
 ----------------------------------------------------------------- 


steps after ssh into the machine:

install docker and add ec2user to docker group
- sudo yum install docker -y
- sudo systemctl start docker
- sudo usermod -aG docker $USER
- newgrp docker


add aws credentials (better to create iam role and attach it to the machine using terraform)
- mkdir .aws
- vi ~/.aws/credentials and add the credentials

docker login to ecr and pull the images
- 
- docker pull 837853736685.dkr.ecr.us-east-1.amazonaws.com/mysql:1.0
- docker pull 837853736685.dkr.ecr.us-east-1.amazonaws.com/app:1.0

run mysql container
- docker run --network bridge -d --name mysql -e MYSQL_ROOT_PASSWORD=pw   837853736685.dkr.ecr.us-east-1.amazonaws.com/mysql:1.0

export env that will be used from the application containers:
- export DBHOST=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mysql)
- export DBPORT=3306
- export DBUSER=root
- export DATABASE=employees
- export DBPWD=pw

deploy three containers with different colors
docker run -d --network bridge  -p 8081:8080  -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR=pink 837853736685.dkr.ecr.us-east-1.amazonaws.com/app:1.0
docker run -d --network bridge  -p 8082:8080  -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR=blue 837853736685.dkr.ecr.us-east-1.amazonaws.com/app:1.0
docker run -d --network bridge  -p 8083:8080  -e DBHOST=$DBHOST -e DBPORT=$DBPORT -e  DBUSER=$DBUSER -e DBPWD=$DBPWD -e APP_COLOR=lime 837853736685.dkr.ecr.us-east-1.amazonaws.com/app:1.0

then access these applications using the machine ip and ports 8081, 8082, or 8083
