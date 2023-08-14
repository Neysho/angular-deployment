pipeline {
    agent {
    kubernetes {
      yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
  - name: kubectl
    image: gcr.io/cloud-builders/kubectl
    imagePullPolicy: IfNotPresent
    command: ["cat"]
    tty: true
    resources:
      requests:
        cpu: "0.3"
        memory: "500Mi"
        ephemeral-storage: "1Gi"
      limits:
        cpu: "1"
        memory: "1000Mi"
  - name: docker
    image: docker:latest
    imagePullPolicy: IfNotPresent
    command:
    - cat
    tty: true
    requests:
        cpu: "0.3"
        memory: "500Mi"
      limits:
        cpu: "1"
        memory: "1000Mi"
        ephemeral-storage: "1Gi"
    volumeMounts:
    - mountPath: /var/run/docker.sock
      name: docker-sock
  volumes:
  - name: docker-sock
    hostPath:
      path: /var/run/docker.sock     
      '''
      }
    }
    
    environment{
        DOCKERHUB_CREDENTIALS=credentials('docker-hub-neysho')
    }
       stages{
             stage('checkout'){
                        steps{
                        //  deleteDir()
                         checkout scmGit(branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'github-neysho', url: 'https://github.com/Neysho/Spring-boot-deployment.git']])
                       }
                  }
           
             stage('NPM install'){
                tools { nodejs "nodejs-14.21.3" }
                steps{
                    sh 'npm install'
                }
            }
            stage('build'){
                tools { nodejs "nodejs-14.21.3" }
                steps{
                    sh 'npm run build --prod'
                }
            }
            stage('docker build'){
                steps{
                    container('docker') {
                        sh ''' ls
                               docker build -t neysho/emp-frontend:1 .
                               echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin
                               docker push neysho/emp-frontend:1
                        '''
               }
              }
            }

            
             stage('Deploying frontend') {
                 steps {
                     container('kubectl') {
                      withKubeConfig([credentialsId: 'kube-config', serverUrl: 'https://192.168.1.130:6443']) {
                      sh 'kubectl delete pods -n emp -l app=angular-deployment'
                   }
                   }
                 }
             }

            

    }
     post {
        // Clean after build
        always {
            cleanWs()
            }
          }
}
