pipeline {
    agent any

    tools {
        maven 'Maven 3'
        jdk 'Java 21'
    }

    stages {
        stage('Checkout') {
            steps {
                // Kept your correct URL and branch
                git branch: 'master', url: 'https://github.com/yashasreepola/hms.git'
            }
        }
        stage('Build & Test') {
            steps {
                bat 'mvn clean package'
            }
        }
        stage('Docker Build') {
            steps {
                bat 'docker build -t yashasreepola/hms-backend:latest .'
            }
        }
        stage('Docker Push') {
            steps {
                // FIXED: Changed 'string' to 'usernamePassword' to match your Jenkins Credentials type
                withCredentials([usernamePassword(credentialsId: 'docker-hub-pwd', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {

                    // Uses the username and password from Jenkins credentials safely
                    bat 'docker login -u %DOCKER_USER% -p %DOCKER_PASS%'

                    bat 'docker push yashasreepola/hms-backend:latest'
                }
            }
        }
    }
}