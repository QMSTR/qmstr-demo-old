pipeline {

    agent none

    stages {

        // as soon as the master branch of qmstr is built by the CI and creates artifacts,
        // these binaries should be imported to the following jobs
        stage('Compile with QMSTR'){
            parallel{

                stage('compile curl'){

                    environment {
                        PATH = "$PATH:$WORKSPACE/out/"
                    }

                    agent { label 'docker' }

                    steps {
                        copyArtifacts(projectName: 'QMSTR/qmstr/master')
                        sh "make curl"
                    }
                }

                stage('compile openssl'){

                    agent { label 'docker' }

                    environment {
                        PATH = "$PATH:$WORKSPACE/out/"
                    }

                    steps {
                        copyArtifacts(projectName: 'QMSTR/qmstr/master')
                        sh "make openssl"
                    }
                }

                stage('compile flask'){

                    agent { label 'docker' }

                    environment {
                        PATH = "$PATH:$WORKSPACE/out/"
                    }

                    steps {
                        copyArtifacts(projectName: 'QMSTR/qmstr/master')
                        sh "make flask"
                    }
                }

                stage('compile guava'){

                    agent { label 'docker' }

                    environment {
                        PATH = "$PATH:$WORKSPACE/out/"
                    }

                    steps {
                        copyArtifacts(projectName: 'QMSTR/qmstr/master')
                        sh "make guava"
                    }
                }
            }
        }
        // stage('Publish report') {
        //     steps {
        //         dir("web"){
        //             withEnv(["PATH+SNAP=/snap/bin"]){
        //                 sh 'git submodule init && git submodule update'
        //                 sh 'cp ${WORKSPACE}/qmstr-demo/demos/curl/qmstr-reports.tar.bz2 ./'
        //                 sh '(cd ./static && tar xvjf ../qmstr-reports.tar.bz2 && mv ./reports ./packages)'
        //                 sh './scripts/generate-data-branch.sh ./tempfolder'
        //                 sh 'git config http.sslVersion tlsv1.2'
        //                 withCredentials([usernamePassword(credentialsId: '6374572f-c47a-4939-beda-2ee601d65ff7', passwordVariable: 'cipassword', usernameVariable: 'ciuser')]) {
        //                     //sh 'git push --force https://${ciuser}:${cipassword}@github.com/qmstr/web gh-pages'  
        //                 }
        //             }
        //         }
        //     }
        // }
    }
}
