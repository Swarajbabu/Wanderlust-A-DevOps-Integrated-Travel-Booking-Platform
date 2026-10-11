pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = '861809200696'
        AWS_DEFAULT_REGION = 'ap-south-1'
        ECR_REPO_NAME = 'wanderlust-app'
        EKS_CLUSTER_NAME = 'wanderlust-cluster'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        ECR_REGISTRY = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image: ${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG}"
                sh "docker build -t ${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG} -t ${ECR_REGISTRY}/${ECR_REPO_NAME}:latest ."
            }
        }

        stage('Push Image to AWS ECR') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    echo "Logging into AWS ECR and pushing image..."
                    sh """
                        aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                        docker push ${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG}
                        docker push ${ECR_REGISTRY}/${ECR_REPO_NAME}:latest
                    """
                }
            }
        }

        stage('Deploy to AWS EKS') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'aws-credentials', usernameVariable: 'AWS_ACCESS_KEY_ID', passwordVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                    echo "Deploying new version to AWS EKS cluster..."
                    sh """
                        # Connect Jenkins to EKS cluster
                        aws eks update-kubeconfig --region ${AWS_DEFAULT_REGION} --name ${EKS_CLUSTER_NAME}

                        # Update Kubernetes Deployment with the new image tag
                        kubectl set image deployment/wanderlust-deployment wanderlust-container=${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG}

                        # Verify zero-downtime rolling update succeeds
                        kubectl rollout status deployment/wanderlust-deployment --timeout=180s
                    """
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up local Docker images to save EC2 disk space..."
            sh "docker rmi ${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG} || true"
        }
        success {
            echo "CI/CD Pipeline Completed Successfully! Wanderlust version ${IMAGE_TAG} is live on EKS!"
        }
        failure {
            echo "Pipeline Failed! Please check stage logs."
        }
        
    }
}