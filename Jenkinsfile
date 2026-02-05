pipeline {
  agent {
    kubernetes {
      yamlFile 'agents/agentpod.yaml'
    }
  }

  stages {
    stage('Terraform Plan') {
      steps {
        sh 'terraform init'
        sh 'terraform plan'
      }
    }
  }
}
