pipeline {    
    agent any  

    tools {
        terraform 'terraform-14'
    }

    environment{
        DOCKER_TAG         = getDockerTag()
        IMAGE_URL_WITH_TAG = "gowthama97/my-nginx:${DOCKER_TAG}"
        CLUSTER_REGION     = "us-east-1"
        CLUSTER_NAME       = "my-eks-cluster"
    }  

    stages {
        stage('Git checkout') {
            steps {
                git credentialsId: 'MyGitHubCred', url: 'https://github.com/gowthamathangam14041997/epam-incubation'
            }
        }
        stage('Terraform Infra') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "MyAwsCred",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh 'terraform -chdir="./terraform/dev/" init'
                    sh 'terraform -chdir="./terraform/dev/" apply --auto-approve'
                    sh 'sh ./terraform/dev/subnets_for_ingress.sh'
                }
            }
        }
        stage('docker build') {
            steps {
                sh 'docker build -t my-nginx:${DOCKER_TAG} ./docker/'
                sh 'docker tag my-nginx:${DOCKER_TAG} ${IMAGE_URL_WITH_TAG}'
                sh 'sh ./docker/change_image_tag.sh ${DOCKER_TAG}'
            }
        }
        stage('docker push') {
            steps {
                withCredentials([string(credentialsId: 'MyDockerHubCred', variable: 'pass')]) {
                    sh 'docker login -u gowthama97 -p ${pass}'
                    sh 'docker push ${IMAGE_URL_WITH_TAG}'
                }
            }
        }
        stage('kubernetes deployment') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: "MyAwsCred",
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    sh 'aws eks update-kubeconfig --name ${CLUSTER_NAME} --region ${CLUSTER_REGION}'
                    
                    withCredentials([string(credentialsId: 'MyDockerHubCred', variable: 'pass')]) {
                        sh 'docker login -u gowthama97 -p ${pass}'
                        sh 'kubectl create secret docker-registry regcred --docker-username=gowthama97 --docker-password=${pass} --docker-email=gowthamarajan97@gmail.com -n default'
                    }
                    sh 'kubectl apply -f ./kubernetes/deployment/'
                }
            }
        }
    }
}

def getDockerTag() {
    git credentialsId: 'MyGitHubCred', url: 'https://github.com/gowthamathangam14041997/epam-incubation'
    tag  = sh script: 'git rev-parse --short HEAD', returnStdout: true
    return tag
}
