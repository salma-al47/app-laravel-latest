pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "backend"
        GITHUB_REPO_URL = "https://github.com/salma-al47/app-laravel-latest.git"
        DOCKERHUB_REGISTRY = 'https://index.docker.io/v1/'
    }

    stages {
        stage('Checkout') {
            steps {
                // Étape pour récupérer le code depuis GitHub
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Étape pour construire l'image Docker
                sh "docker build -t \$DOCKER_IMAGE_NAME -f backend.dockerfile ."
            }
        }

       
        stage('Push to Docker Hub') {
            steps {
                // Connexion à Docker Hub en utilisant les informations d'identification
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                        sh "echo \$DOCKERHUB_PASSWORD | docker login -u \$DOCKERHUB_USERNAME --password-stdin"
                    }
                }

                // Pousser l'image sur Docker Hub
                sh "docker tag backend salmaal/app-laravel:v0.0.1"
                sh "docker images"
                sh "docker push salmaal/app-laravel:v0.0.1"
            }
        }
    }
}

        stage('Deploy') {
            steps {
                  sh "docker pull salmaal/app-laravel:v0.0.1"
                  sh "docker run -d backend -p 8080:80 salmaal/app-laravel:v0.0.1"

                  sh "docker ps"
     }
}