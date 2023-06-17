pipeline {
    agent any
    environment {
        REPO = 'https://github.com/njrk/kbot.git'
        BRANCH = 'main'
    }
    parameters {

        choice(name: 'OS', choices: ['linux', 'darwin', 'windows', 'all'], description: 'Pick OS')
        choice(name: 'ARCH', choices: ['amd64', 'arm64'], description: 'Pick ARCH')

    }
   stages {

        stage('Example') {
            steps {
                echo "Build for platform ${params.OS}"
                echo "Build for arch: ${params.ARCH}"

            }
        }
       
        stage("clone") {
           steps {
               echo 'CLONE REPOSITORY'
               git branch: "${BRANCH}", url: "${REPO}"
           }
        }
        
        stage("test") {
           steps {
               echo 'TEST EXECUTION STARTED'
               sh 'make test'
           }
        }
        
        stage("build") {
           steps {
                echo 'BUILD EXECUTION STARTED'
                echo "Build for selected platform ${params.OS}"
                sh 'make build TARGETOS=$OS TARGETARCH=$ARCH'
           }
        }
        
        stage("image") {
           steps {
               script{
                    echo 'IMAGE BUILD EXECUTION STARTED'
                    sh 'make image'
               }
           }
        }
        
        stage("push") {
           steps {
               script{
                    docker.withRegistry( '', 'dockerhub') {
                    sh 'make push'
                    }
               }
           }
        }
    }   
}