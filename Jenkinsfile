podTemplate(containers: [
    containerTemplate(name: 'gradle', image: 'gradle:latest', command: 'sleep', args: '99d')
  ]) {
    node(POD_LABEL) {
        stage('Build') {
            git 'https://github.com/gitphill/gradle-spring-boot.git'
            container('gradle') {
                stage('Build a Gradle project') {
                    sh 'gradle build'
                }
            }
        }
    }
}
