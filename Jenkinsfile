pipeline {
    agent any
  environment {
        SONAR_CREDENTIALS = credentials('adminsonar')
       NEXUS_CREDENTIALS = credentials('nexus_Cred')
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
                sh "./gradlew sonarqube -Dsonar.login=${SONAR_CREDENTIALS} -Dsonar.host.url=${SONARQUBE_URL} "
            }
        }

        stage('Publish to Nexus') {
            steps {
                script {
                    // Configure Nexus credentials

                    // Publish artifacts to Nexus
                    sh """
                    ./gradlew publish \
                        -PnexusUsername=\"${NEXUS_CREDENTIALS_USR}" \
                        -PnexusPassword=\"${NEXUS_CREDENTIALS_PSW}" \
                        -PnexusUrl=nexusPublicRepoUrl
                    """
                }
            }
        }
    }
}
