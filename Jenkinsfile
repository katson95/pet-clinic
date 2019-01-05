def label = "mypod-${UUID.randomUUID().toString()}"
podTemplate(label: label, 
     containers: [
        containerTemplate(name: 'maven', image: 'maven:3.3.9-jdk-8-alpine', ttyEnabled: true, command: 'cat'),
        containerTemplate(name: 'sigma-agent', image: 'invent360/sigma-agent', ttyEnabled: true, command: 'cat')
     ], 
     volumes: [
        persistentVolumeClaim(mountPath: '/root/.m2/repository', claimName: 'jenkins', readOnly: false),
        hostPathVolume(hostPath: '/var/run/docker.sock', mountPath: '/var/run/docker.sock')
  ]) {
    node(label) {
         
        checkout scm
         
        dir('pet-clinic-k8') {
            git url: 'https://github.com/katson95/pet-clinic-k8.git'
        }
         
        def IMAGE_NAME = 'invent360/petclinic'
        def IMAGE_VERSION = '1.1'
        
       stage('Get a Maven project') {
            container('maven') {
                stage('Build a Maven project') {
                    sh 'mvn -B clean install'
                }
            }
        }
         
        stage('Build and Test Image') {
            container('sigma-agent') {
                stage('Package into Docker Image') {
                    sh 'docker build -t petclinic:1.2 .'
                    sh 'docker tag petclinic:1.2 docker.ops.invent-360.com/invent360/petclinic:1.2'
                }
            }
        }

        stage('Publish Image') {
            container('sigma-agent'){  
                stage('Publish Image to Docker Registry') {
                  withCredentials([usernamePassword(credentialsId: 'i360-nexus-id', passwordVariable: 'dockerPassword', usernameVariable: 'dockerUsername')]) {
                   sh "docker login -u ${env.dockerUsername} -p ${env.dockerPassword} docker.ops.invent-360.com"
                   sh "docker push docker.ops.invent-360.com/invent360/petclinic:1.2"
                }
              }
            }
        }
    }
}
