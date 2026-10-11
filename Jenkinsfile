pipeline {
    agent any

    environment {
        AWS_ACCOUNT_ID = '861809200696'
        AWS_DEFAULT_REGION = 'ap-south-1'
        ECR_REPO_NAME = 'wanderlust-app'
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
                    echo "Logging into AWS ECR..."
                    sh """
                        aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
                        docker push ${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG}
                        docker push ${ECR_REGISTRY}/${ECR_REPO_NAME}:latest
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
            echo "CI/CD Pipeline Completed Successfully! New image pushed: ${ECR_REGISTRY}/${ECR_REPO_NAME}:${IMAGE_TAG}"
        }
        failure {
            echo "Pipeline Failed! Please check stage logs."
        }
    }
}