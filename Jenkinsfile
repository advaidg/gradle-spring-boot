def scanMyCode() {
    // Ensure that the SonarQube installation is configured in Jenkins
    if (!env.SONARQUBE_URL) {
        error("SONARQUBE_URL is not set in the environment variables")
    }

    // Ensure that the SonarQube token is available
    def sonarToken = null
    withCredentials([string(credentialsId: 'adminsonar', variable: 'SONAR_TOKEN')]) {
        sonarToken = env.SONAR_TOKEN
    }
    if (!sonarToken) {
        error("SonarQube token is not available in Jenkins credentials")
    }

    // Run the SonarQube analysis
    sh """
        ./gradlew sonarqube \\
            -Dsonar.host.url=${env.SONARQUBE_URL} \\
            -Dsonar.login=${sonarToken}
    """
}
pipeline {
    agent any

    environment {
        SONAR_CREDENTIALS = credentials('adminsonar')
        NEXUS_CREDENTIALS = credentials('nexus_Cred')
        DOCKER_IMAGE_NAME = 'my-docker-image'
        DOCKER_IMAGE_TAG = '2.0.0'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your Git repository
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Use the Gradle Wrapper to build your Spring Boot application
                sh './gradlew clean build'
            }
        }

        stage('SonarQube Scan') {
            steps {
                // Run SonarQube analysis using the SonarScanner for Gradle
               scanMyCode()
                // sh "./gradlew sonarqube -Dsonar.login=${SONAR_CREDENTIALS} -Dsonar.host.url=${SONARQUBE_URL}"
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    // Build and tag the Docker image
                    sh "docker build -t ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ."
                        sh """
                        
                        docker login -u $NEXUS_CREDENTIALS_USR -p $NEXUS_CREDENTIALS_PSW $NEXUS_REGISTRY_URL
                        docker tag ${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG} ${NEXUS_REGISTRY_URL}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}
                        docker push ${NEXUS_REGISTRY_URL}/${DOCKER_IMAGE_NAME}:${DOCKER_IMAGE_TAG}                       
                        """

                }
            }
        }

        stage('Publish to Nexus') {
            steps {
                // Configure Nexus credentials and publish artifacts to Nexus (if needed)
                sh """
                ./gradlew publish \
                    -PnexusUsername=\"${NEXUS_CREDENTIALS_USR}" \
                    -PnexusPassword=\"${NEXUS_CREDENTIALS_PSW}" \
                    -PnexusUrl=nexusPublicRepoUrl
                """
            }
        }

        
        stage('Deploy to AKS') {
            steps {
                script {
                          sh 'kubectl apply -f deploy.yaml'
                    
                }
            }
    }
}
}
