pipeline {

    agent any

    environment {
        IMAGE_NAME = "flask-ci-app"
        CONTAINER_NAME = "flask-ci-container"
        PORT = "5000"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Run Tests') {
            steps {
                sh '''
                    python3 -m venv venv
                    venv/bin/pip install -r requirements.txt
                    venv/bin/pytest
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                    docker build -t $IMAGE_NAME .
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                    docker rm -f $CONTAINER_NAME || true
                    docker run -d -p 5000:5000 --name $CONTAINER_NAME $IMAGE_NAME
                '''
            }
        }
    }

    post {
        success {
            echo "Docker deployment successful!"
        }
        failure {
            echo "Build failed!"
        }
    }
}
