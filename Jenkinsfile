node() {
    try {
        // Variables
        // *************************

        println 'Read In:'

        def applicationName = "carto"
        def environmentName = "carto-prod-v1"
        def applicationVersionLabel = "${applicationName}-${VERSION_NUMBER}-${currentBuild.number}"
        println "applicationVersionLabel: ${applicationVersionLabel}"
        println "environmentName: ${environmentName}"

        // Stages
        // *************************

        stage ('Clean Workspace') {
            deleteDir()

            println 'Checking out tn-carto'

            git url: "git@github.com:${GIT_REPO_TN_CARTO}/tn-carto.git", branch: "${GIT_COMMIT_TN_CARTO}"
        }


        stage('Prepare Beanstalk Archives') {

            withEnv([
                "APPLICATION_VERSION_LABEL=${applicationVersionLabel}"]) {
                sh 'deploy/beanstalk_prepare.sh'
            }
        }

        stage('Promote Application Versions') {

            withEnv([
                "APPLICATION_NAME=${applicationName}",
                "APPLICATION_VERSION_LABEL=${applicationVersionLabel}"]) {
                sh 'deploy/beanstalk_promote.sh'
            }
        }

        stage('Deploy to Production') {

            lock(resource: '${environmentName}') {

                withEnv([
                    "APPLICATION_VERSION_LABEL=${applicationVersionLabel}",
                    "ENVIRONMENT_NAME=${environmentName}"]) {
                    sh 'deploy/beanstalk_deploy.sh'
                }
            }
        }


    } catch(err) {
        currentBuild.result = 'FAILURE'
        emailDefault('rex-tech@thinknear.com')

        throw err
    }
}
