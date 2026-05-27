pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "chethan97/s-cart"
    }

    stages {

        stage('Clone Code') {
            steps {
                git 'https://github.com/Chethangowda97/s-cart.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE .'
            }
        }

        stage('Login DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {

                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Deploy Container') {
            steps {

                sh '''
                docker stop s-cart-container || true
                docker rm s-cart-container || true

                docker run -d \
                  --name s-cart-container \
                  -p 80:80 \
                  $DOCKER_IMAGE
                '''
            }
        }
    }
}
