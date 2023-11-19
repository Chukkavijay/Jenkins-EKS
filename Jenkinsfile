##EKS Cluster Creation Pipeline
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "ap-south-1"
    }
    stages {
        stage('Checkout SCM'){
            steps{
                script{
                    checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Chukkavijay/Jenkins-EKS.git']])
                }
            }
        }
        stage('Initializing Terraform'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Format & Validating Terraform Code'){
            steps{
                script{
                    dir('EKS'){
                        sh '''terraform fmt
                              terraform validate
                         '''
                    }
                }
            }
        }
        stage('Previewing Infra using Terraform'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform plan'
                    }
                }
            }
        }
        stage('Creating an EKS Cluster'){
            steps{
                script{
                    dir('EKS') {
                        sh 'terraform apply --auto-approve'
                    }
                }
            }
        }
        stage('Deploying Nginx Application') {
            steps{
                script{
                    dir('EKS/ConfigurationFiles') {
                        sh 'aws eks update-kubeconfig --name my-eks-cluster'
                        sh 'kubectl apply -f deployment.yaml'
                        sh 'kubectl apply -f service.yaml'
                    }
                }
            }
        }
    }
}
=====================================================================================
#EKS Cluster Deletion Pipeline
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "ap-south-1"
    }
    stages {
        stage('Checkout SCM'){
            steps{
                script{
                    checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Chukkavijay/Jenkins-EKS.git']])
                }
            }
        }
        stage('Initializing Terraform'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Previewing Infra using Terraform'){
            steps{
                script{
                    dir('EKS'){
                        sh 'terraform plan'
                    }
                }
            }
        }
        stage('Deleting Nginx Application') {
            steps{
                script{
                    dir('EKS/ConfigurationFiles') {
                        sh 'aws eks update-kubeconfig --name my-eks-cluster'
                        sh 'kubectl delete -f deployment.yaml'
                        sh 'kubectl delete -f service.yaml'
                    }
                }
            }
        }
        stage('Destroying an EKS Cluster'){
            steps{
                script{
                    dir('EKS') {
                        sh 'terraform destroy --auto-approve'
                    }
                }
            }
        }
    }
}
