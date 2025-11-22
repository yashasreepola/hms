pipeline {
    agent any

    tools {
        maven 'Maven 3'
        // CHANGE: This must match the name of the JDK you installed in Jenkins -> Global Tool Configuration
        jdk 'Java 21'
    }

    stages {
        stage('Checkout') {
            steps {
                // Replace with your actual GitHub repository URL
                git branch: 'main', url: 'https://github.com/yashasreepola/hms.git'
            }
        }
        stage('Build & Test') {
            steps {
                // This uses the JDK 21 defined in tools above
                sh 'mvn clean package'
            }
        }
        stage('Docker Build') {
            steps {
                // This uses the Dockerfile generated above (which uses Java 21)
                sh 'docker build -t yashasreepola/hms-backend:latest .'
            }
        }
        stage('Docker Push') {
            steps {
                withCredentials([string(credentialsId: 'docker-hub-pwd', variable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u yashasreepola -p $DOCKER_PASSWORD'
                    sh 'docker push yashasreepola/hms-backend:latest'
                }
            }
        }
    }
}