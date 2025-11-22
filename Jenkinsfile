pipeline {
    agent any

    tools {
        maven 'Maven 3'
        jdk 'Java 21'
    }

    stages {
        stage('Checkout') {
            steps {
                // Kept your correct URL
                git branch: 'master', url: 'https://github.com/yashasreepola/hms.git'
            }
        }
        stage('Build & Test') {
            steps {
                // CHANGE: Used 'bat' instead of 'sh' for Windows
                bat 'mvn clean package'
            }
        }
        stage('Docker Build') {
            steps {
                // CHANGE: Used 'bat'
                // REMINDER: Replace 'my-docker-hub-username' with your actual Docker Hub ID
                bat 'docker build -t yashasreepola/hms-backend:latest .'
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-pwd', variable: 'DOCKER_PASSWORD')]) {
                    // CHANGE: Used 'bat' and %VARIABLE% syntax for Windows
                    // REMINDER: Replace 'my-docker-hub-username' with your actual Docker Hub ID
                    bat 'docker login -u yashasreepola -p %DOCKER_PASSWORD%'
                    bat 'docker push yashasreepola/hms-backend:latest'
                }
            }
        }
    }
}