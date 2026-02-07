pipeline {
  agent {
    kubernetes {
      yamlFile 'agents/agentpod.yaml'
    }
  }

  stages {
    stage('Terraform Plan') {
      steps {
        container('terraform') {
            dir('src'){
                sh 'terraform init'
                sh 'terraform plan'
            }
        }
      }
    }
  }
}
