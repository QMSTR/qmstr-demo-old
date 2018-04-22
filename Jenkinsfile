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
                    git credentialsId: '6374572f-c47a-4939-beda-2ee601d65ff7' poll: false, url: 'https://github.com/Endocode/qmstr'
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
                    sh 'docker build -f ./ci/Dockerfile -t runtime --target runtime .'
                    sh 'docker build -f ./ci/Dockerfile -t qmstr/master --target master .'
                }
                dir("qmstr-demo"){
                    sh 'docker build -t qmstr/demojabref --target demojabref .'
                }
            }
        }
        stage('Compile with QMSTR'){
            parallel{
                stage('client side'){
                    steps{
                        dir("qmstr-demo"){
                            sh 'docker run --name demojabref --privileged -v $(pwd)/demos:/demos -v /var/run/docker.sock:/var/run/docker.sock -e PWD_DEMOS=$(pwd)/demos/jabref -e MASTER_CONTAINER_NAME=${MASTER_CONTAINER_NAME} --net qmstrnet --rm qmstr/demojabref' 
                        }
                    }
                }
                stage('server side'){
                    steps{
                        sh 'docker ps && sleep 10 && docker logs ${MASTER_CONTAINER_NAME} -f'
                    }
                }
            }
        }
        stage('Publish report') {
            steps {
                dir("web"){
                    withEnv(["PATH+SNAP=/snap/bin"]){
                        sh 'cat ./.gitmodules | sed "s/git@github.com:devcows\\/hugo-universal-theme.git/https:\\/\\/github.com\\/devcows\\/hugo-universal-theme.git/g;w .gitmodules"'
                        sh 'cat ./.gitmodules | sed "s/git@github.com:endocode\\/databranches.git/https:\\/\\/github.com\\/endocode\\/databranches.git/g;w .gitmodules"'
                        sh 'git submodule init && git submodule update'
                        sh 'cp ${WORKSPACE}/qmstr-demo/demos/jabref/qmstr-reports.tar.bz2 ./'
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
        stage('Cleanup') {
            steps {
                sh 'docker network rm ${QMSTR_NETWORK}'
            }
        }
    }
}