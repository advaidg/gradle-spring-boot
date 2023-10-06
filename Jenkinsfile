pipeline {
    agent any

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
