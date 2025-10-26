
Google Doc Link : https://docs.google.com/document/d/14noaCP8_8HQ3YBXz9yxjalMkyi7mYo1SLOLEcEJFvW4/edit?usp=sharing



Application Deployment
Project 1
Khandekar Md Faruque
		(Deploy the given React application to a production ready state)


Application:
Clone the below mentioned repository and deploy the application (Run application in port 3000).
Repo URL : https://github.com/Vennilavan12/Brain-Tasks-App.git



Docker:
Dockerize the application by creating Dockerfile
Build an application and check output using docker image.



Docker file created
FROM public.ecr.aws/nginx/nginx:alpine
RUN rm -rf /usr/share/nginx/html/*
COPY dist/ /usr/share/nginx/html/
Expose 80
CMD ["nginx", "-g", "daemon off;"]

Built docker image from docker file
docker build -t brainapp .
Run docker container from docker image
docker run -itd --name brinappc -p 3000:80 brainapp (port forwarded to 3000)



the application is containerized correctly and working fine by enabling port 3000 in security group


ECR:
Create an AWS ECR repository for store docker images.
aws ecr create-repository --repository-name braintasks-app



Repository created in aws console


Docker image pushed to ECR repo
docker tag brainapp:latest 312669614823.dkr.ecr.us-east-1.amazonaws.com/braintasks-app:latest

docker push 312669614823.dkr.ecr.us-east-1.amazonaws.com/braintasks-app:latest

Kubernetes:
Setup Kubernetes in AWS EKS and Confirm EKS cluster is running.
Write deployment and service YAML files.
Deploy using kubectl via Codedeploy.
Installing eksctl and kubectl



Creating cluster
eksctl create cluster \
--name brainapp-cluster \
--region us-east-1 \
--nodegroup-name brainapp-workers \
--node-type t3.medium \
--nodes 2 \
--nodes-min 2 \
--nodes-max 2 \
--managed




Created cluster named brainapp-cluster using eksctl from an ec2 using necessary permissions





Cluster is ready.



Node and node-groups



CodeBuild:
Create a CodeBuild project:
Source: Connect to your repository
Environment: Use managed image (Amazon Linux, Ubuntu)
Write and define commands in buildspec.yml.


Codebuild project created

Github repository connected

Created buildspec.yml file 

version: 0.2
phases:
 pre_build:
   commands:
     - echo Logging in to Amazon ECR...
     - aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 312669614823.dkr.ecr.us-east-1.amazonaws.com
     - curl -LO https://dl.k8s.io/release/v1.32.0/bin/linux/amd64/kubectl
     - chmod +x kubectl
     - mv kubectl /usr/local/bin/
 build:
   commands:
     - docker build -t brainapp .
     - docker tag brainapp:latest 312669614823.dkr.ecr.us-east-1.amazonaws.com/braintasks-app:latest
 post_build:
   commands:
     - docker push 312669614823.dkr.ecr.us-east-1.amazonaws.com/braintasks-app:latest
     - aws eks update-kubeconfig --region us-east-1 --name brainapp-cluster
     - export KUBECONFIG=/root/.kube/config
     - kubectl apply -f deployment.yaml --validate=false
     - kubectl apply -f service.yaml




Buildspec.yml file uploaded to codebuild.

CodeDeploy:
Create codedeploy application.
create appspec.yml file to deploy applications in EKS.


Version Control:
Push the codebase to a Git provider (GitHub).
Use CLI commands to push code.


Pushed code to github

CodePipeline:
Source: GitHub
Build: AWS CodeBuild project
Deploy: AWS CodeDeploy or deploy to EKS via Lambda or custom script.
Successfully created and deployed a pipeline and connect the source(github) using kubectl in codeBuild deployed it to the EKS cluster.




Output:



Monitoring:
Use CloudWatch Logs to track build, deploy, and application logs.



ELoadbalancer:



NOTE:

Since the port 3000 is a non standard port we have to explicitly mention the dns:portnumber 
Example:
http://a88f2aea561f344209c5208936e64b73-904040183.ap-south-1.elb.amazonaws.com:3000/
