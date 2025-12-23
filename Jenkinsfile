pipeline {
    agent {
        docker { 
        image 'jenkins-terraform-agent' 
        args '-v /c/Users/vinod/AppData/Roaming/gcloud/application_default_credentials.json:/root/.config/gcloud/application_default_credentials.json'
 
        }
    }
    environment {
        GOOGLE_IMPERSONATE_SERVICE_ACCOUNT = "terraform-ci@gmtech-bld-001.iam.gserviceaccount.com"
        GOOGLE_PROJECT = "gmtech-bld-001"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Format & Validate') {
            steps {
                sh '''
                    terraform fmt -check
                    terraform validate
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                    echo "Using ADC:"
                    gcloud auth application-default print-access-token > /dev/null

                    terraform init \
                      -backend-config="bucket=$GOOGLE_PROJECT-tfstate" \
                      -backend-config="prefix=jenkins"
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                    cd src && terraform plan \
                    -var="impersonate_sa=$GOOGLE_IMPERSONATE_SERVICE_ACCOUNT"
                      -out=tfplan
                '''
            }
        }

        stage('Terraform Apply') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                    terraform apply \
                    -var="impersonate_sa=$GOOGLE_IMPERSONATE_SERVICE_ACCOUNT" \
                    -auto-approve tfplan
                '''
            }
        }
    }
}
