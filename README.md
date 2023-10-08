# Assignment 1 CLO 835

# 1. Login in to the ec2 instance
```ssh -i <ssh-key> <eip>```

# 2. Install docker and update the images
```sudo yum update -y``` 

```sudo yum install docker -y```

```sudo systemctl start docker``` 

```sudo systemctl status docker```

# 3. Update the aws credentials 

```vi ~/.aws/credentials```

# 4. Export the ECR and login

```export ECR = <ecr uri>```
```aws ecr get-login-password --region us-east-1 | docker login -u AWS ${ECR} --password-stdin```

# 5. Pull the image

``` docker pull <image-uri>```

# 6. Now create the containers.

```docker run -d -e MYSQL_ROOT_PASSWORD=db_pass123 --name mysql-db <image-id>```
```docker run -d -e DBHOST=mysql-db -e DBPORT=3306 -e DBPWD=db_pass123 -e APP_COLOR=blue -p 81:8080 --name webapp1 --link mysql-db:mysql-db```
### Thank You !
