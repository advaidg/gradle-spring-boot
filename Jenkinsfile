pipeline {
    agent any
  environment {
        SONAR_CREDENTIALS = credentials('adminsonar')
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
                sh "./gradle sonarqube -Dsonar.login=${SONAR_CREDENTIALS}"
'
            }
        }

        stage('Publish to Nexus') {
            steps {
                script {
                    // Configure Nexus credentials

                    // Publish artifacts to Nexus
                    sh """
                    ./gradlew publish \
                        -PnexusUsername=\$nexusUsername \
                        -PnexusPassword=\$nexusPassword \
                        -PnexusUrl=nexusPublicRepoUrl
                    """
                }
            }
        }
    }
}
