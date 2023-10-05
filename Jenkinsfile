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
                    def nexusCredentials = [
                        usernamePassword(
                            credentialsId: 'a37fcb16-3f6e-49cd-a5f1-1e5184f50eab', // ID of your Nexus credentials in Jenkins
                            variable: 'NEXUS_CREDENTIALS'
                        )
                    ]

                    // Publish artifacts to Nexus
                    sh """
                    ./gradlew publish \
                        -PnexusUsername=\$NEXUS_CREDENTIALS_USR \
                        -PnexusPassword=\$NEXUS_CREDENTIALS_PSW \
                        -PnexusUrl=nexusPublicRepoUrl
                    """
                }
            }
        }
    }

    post {
        success {
            // Optionally, you can perform additional actions on success
        }
        failure {
            // Optionally, you can perform additional actions on failure
        }
    }
}
