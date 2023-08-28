pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "backend"
        GITHUB_REPO_URL = "https://github.com/salma-al47/app-laravel-latest.git"
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
                sh "docker build -t $DOCKER_IMAGE_NAME ."
            }
        }
      
        stage('Test') {
            steps {
                sh "phpunit" 
            }
        }

        stage('Push to Docker Hub') {
            steps {
                // Connexion à Docker Hub
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub_credentials', passwordVariable: 'DOCKERHUB_PASSWORD', usernameVariable: 'DOCKERHUB_USERNAME')]) {
                        sh "docker login -u $DOCKERHUB_USERNAME -p $DOCKERHUB_PASSWORD"
                    }
                }

                // Pousser l'image sur Docker Hub
                sh "docker push $DOCKER_IMAGE_NAME"
            }
        }
    }
}



 
