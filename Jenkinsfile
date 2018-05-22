pipeline {
    agent any

    environment {
        MASTER_CONTAINER_NAME="qmstr-demo-master_${BUILD_NUMBER}"
    }

    stages {
        stage('Clean') {
            steps {
                cleanWs()
            }
        }
        stage('Clone sources') {
            steps {
                dir('qmstr-master') {
                    try {
                        git credentialsId: '6374572f-c47a-4939-beda-2ee601d65ff7', branch: '${BRANCH_NAME}', poll: false, url: 'https://github.com/QMSTR/qmstr'
                    } catch (exc) {
                        git credentialsId: '6374572f-c47a-4939-beda-2ee601d65ff7', poll: false, url: 'https://github.com/QMSTR/qmstr'
                    }
                }
                dir("qmstr-demo"){
                    git credentialsId: '6374572f-c47a-4939-beda-2ee601d65ff7', branch: '${BRANCH_NAME}', poll: false, url: 'https://github.com/Endocode/qmstr-demo'
                }
                dir("web"){
                    git credentialsId: '6374572f-c47a-4939-beda-2ee601d65ff7', poll: false, url: 'https://github.com/qmstr/web'
                }
            }
        }
        stage('Build master and client images') {
            steps {
                dir("qmstr-master"){
                    sh 'make container'
                }
            }
        }
        stage('Compile with QMSTR'){
            parallel{
                stage('client side'){
                    steps{
                        dir("qmstr-demo"){
                            sh 'make calc'
                        }
                    }
                }
                stage('server side'){
                    steps{
                        dir("qmstr-master"){
                            sh 'make out/qmstrctl'
                            sh 'out/qmstrctl wait && docker logs ${MASTER_CONTAINER_NAME} -f'
                        }
                    }
                }
            }
        }
        stage('Publish report') {
            steps {
                dir("web"){
                    withEnv(["PATH+SNAP=/snap/bin"]){
                        sh 'git submodule init && git submodule update'
                        sh 'cp ${WORKSPACE}/qmstr-demo/demos/curl/qmstr-reports.tar.bz2 ./'
                        sh '(cd ./static && tar xvjf ../qmstr-reports.tar.bz2 && mv ./reports ./packages)'
                        sh './scripts/generate-data-branch.sh ./tempfolder'
                        sh 'git config http.sslVersion tlsv1.2'
                        withCredentials([usernamePassword(credentialsId: '6374572f-c47a-4939-beda-2ee601d65ff7', passwordVariable: 'cipassword', usernameVariable: 'ciuser')]) {
                            //sh 'git push --force https://${ciuser}:${cipassword}@github.com/qmstr/web gh-pages'  
                        }
                    }
                }
            }
        }
    }
}
