pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "chethan97/s-cart"
        CONTAINER_NAME = "s-cart-container"
    }

    stages {

        stage('Clone Code') {
            steps {
                git 'https://github.com/Chethangowda97/s-cart.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $DOCKER_IMAGE .
                '''
            }
        }

        stage('Login DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    '''
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh '''
                docker push $DOCKER_IMAGE
                '''
            }
        }

        stage('Remove Old Container') {
            steps {
                sh '''
                docker stop $CONTAINER_NAME || true
                docker rm $CONTAINER_NAME || true
                '''
            }
        }

        stage('Deploy Container') {
            steps {
                sh '''
                docker run -d \
                  --name $CONTAINER_NAME \
                  -p 8081:80 \
                  $DOCKER_IMAGE
                '''
            }
        }

        stage('Verify Running Container') {
            steps {
                sh '''
                docker ps
                '''
            }
        }
    }

    post {

        success {
            echo 'CI/CD Pipeline executed successfully!'
        }

        failure {
            echo 'Pipeline failed. Check Jenkins console logs.'
        }
    }
}
