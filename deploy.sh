#!/bin/bash
cd /home/ubuntu/Brain-Task-App
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
