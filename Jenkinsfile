pipeline {
    agent {
    kubernetes {
      yaml """
kind: Pod
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - sleep
    args:
    - 999999
    volumeMounts:
    - name: jenkins-docker-cfg
      mountPath: /kaniko/.docker
  volumes:
  - name: jenkins-docker-cfg
    projected:
      sources:
      - secret:
          name: docker-credentials
          items:
            - key: .dockerconfigjson
              path: config.json
"""
    }
  }
    // tools {
    //     nodejs "node-14.21.3"
    // }
    environment{
        DOCKERHUB_CREDENTIALS=credentials('e2139a57-daf7-4860-af60-38a5496dc084')
    }

    stages{
            stage('Checkout'){
                steps{
                    // deleteDir()
                    checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Neysho/angular-color.git']])
                    // sh 'ls'
                    // sh "sed -i 's|image: neysho/web-app.*|image: neysho/web-app:$BUILD_NUMBER|g' manifests/deployment.yml"
                    // sh 'cat manifests/deployment.yml'
                }
            }
            stage('Build with Kaniko') {
      steps {
            container(name: 'kaniko', shell: '/busybox/sh') {
                sh '''#!/busybox/sh

                    /kaniko/executor --destination=neysho/web-app:latest \
                    --context=git://github.com/Neysho/angular-color.git \
                    -f `pwd`/Dockerfile \
                    --verbosity info
                    
                '''
            }
        }
      }
            // stage('NPM install'){
            //     steps{
            //         sh 'npm install'
            //     }
            // }
            // stage('build'){
            //     steps{
            //         sh 'npm run build --prod'
            //     }
            // }

    }
}