pipeline {
    agent any

    environment {
        SONAR_CREDENTIALS = credentials('adminsonar')
        NEXUS_CREDENTIALS = credentials('nexus_Cred')
        DOCKER_IMAGE_NAME = 'my-docker-image'
        DOCKER_IMAGE_TAG = 'latest'
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
                sh "./gradlew sonarqube -Dsonar.login=${SONAR_CREDENTIALS} -Dsonar.host.url=${SONARQUBE_URL}"
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
                    def kubeConfigSecret = 'k8s'  // The name of the Kubernetes secret storing kubeconfig
                    def kubeConfigFile = "${WORKSPACE}/kubeconfig.yaml"  // Local path to save kubeconfig
                    def kubeCtlCommand = "kubectl --kubeconfig=${kubeConfigFile}"

                    // Set the kubeconfig file
                    withKubeConfig(credentialsId: '${kubeConfigSecret}', kubeconfigFile: '${kubeConfigFile}') {

                        sh "${kubeCtlCommand} apply -f deploy.yaml"
                    }
                }
            }
    }
}
}
