def label = "mypod-${UUID.randomUUID().toString()}"
podTemplate(label: label, 
     containers: [
        containerTemplate(name: 'i360-agent', image: 'katson95/i360-agent:2.0',ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'maven', image: 'maven:3.3.9-jdk-8-alpine', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'a-360', image: 'katson95/a-360:latest', ttyEnabled: true, command: 'cat'),
     ], 
     volumes: [
        persistentVolumeClaim(mountPath: '/root/.m2/repository', claimName: 'jenkins', readOnly: false),
        hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock')
  ]) {
    node(label) {
         
        checkout scm
        git 'https://github.com/katson95/pet-clinic-k8.git'

        def IMAGE = 'katson95/pet-clinic'
        def VERSION = 'latest'        
        
       stage('Get a Maven project') {
            container('maven') {
                stage('Build a Maven project') {
                    sh 'mvn -B clean install'
                }
            }
        }
         
        stage('Build and Test Image') {
            container('a-360') {
                stage('Package into Docker Image') {
                    sh 'docker build -t pet-clinic:latest .'
                    sh 'docker tag pet-clinic:latest katson95/pet-clinic:latest'
                }
            }
        }

        stage('Publish Image') {
            container('a-360'){  
                stage('Publish Image to Docker Registry') {
                  withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials-id', passwordVariable: 'dockerPassword', usernameVariable: 'dockerUsername')]) {
                   sh "docker login -u ${env.dockerUsername} -p ${env.dockerPassword}"
                   sh "docker push ${IMAGE}:${VERSION}"
                }
              }
            }
        }

        stage('Deploy To Dev') {
            container('i360-agent'){  
                stage('Deploy To Dev') {
                    sh 'kubectl create ns DEV'
                    sh 'kubectl create -f ./pet-clinic-k8/ --namespace=DEV'
              }
            }
        }
    }
}
