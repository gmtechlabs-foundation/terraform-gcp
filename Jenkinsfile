pipeline {
  agent {
    kubernetes {
      yamlFile 'agents/agentpod.yaml'
    }
  }

  stages {
    stage('Terraform Plan') {
      steps {
        container('terraform'){
            sh 'terraform init'
            sh 'terraform plan'

        }
        
      }
    }
  }
}
