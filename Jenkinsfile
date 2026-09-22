pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = 'prawin03sm'
        IMAGE_NAME = "${env.DOCKER_HUB_USER}/devops-webapp"
        JAVA_HOME = '/usr/lib/jvm/java-21-openjdk-amd64'
        PATH = "${env.JAVA_HOME}/bin:${env.PATH}"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Akashisagi/devops-java-webapp.git'
            }
        }

        stage('Maven Build') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    // Log into Docker Hub using credentials stored in Jenkins
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                        sh 'echo $PASS | docker login -u $USER --password-stdin'
                    }
                    // Build and push image to Docker Hub
                    sh "docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} -t ${IMAGE_NAME}:latest ."
                    sh "docker push ${IMAGE_NAME}:${BUILD_NUMBER}"
                    sh "docker push ${IMAGE_NAME}:latest"
                }
            }
        }
        stage('Deploy via Ansible') {
            steps {
                sh 'ansible-playbook -i ansible/inventory ansible/deploy.yml'
            }
        }
    }

    post {
        success {
            echo 'Deployment pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check build logs.'
        }
    }
}
