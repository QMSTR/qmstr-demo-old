// This Jenkinsfile will only start other pipelines, via the jobdsl.
// The new jobs will be created if there are Jenkinsfiles into the demos dir.

node {
    stage('Checking demos'){
        jobDsl(targets: 'jobs.groovy',
            removedJobAction: 'DELETE',
            removedViewAction: 'DELETE',
            lookupStrategy: 'SEED_JOB',
            additionalParameters: [message: 'Hello from pipeline', credentials: 'SECRET'])
    }
}