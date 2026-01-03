pipeline {
    agent {
        docker { 
        image 'jenkins-terraform-agent' 
        args '-v /c/Users/vinod/AppData/Roaming/gcloud/application_default_credentials.json:/root/.config/gcloud/application_default_credentials.json'
 
        }
    }
    parameters {
    string(
        name: 'TERRAFORM_ACTION',
        defaultValue: 'plan',
        description: 'Enter terraform action: plan or apply'
    )
    }
    environment {
        GOOGLE_IMPERSONATE_SERVICE_ACCOUNT = "terraform-ci@gmtech-bld-001.iam.gserviceaccount.com"
        GOOGLE_PROJECT = "gmtech-bld-001"
        GITHUB_TOKEN = credentials('classic-git-pat')
        REPO = "your-org/your-repo"
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

                    cd src && terraform init \
                      -backend-config="bucket=$GOOGLE_PROJECT-tfstate" \
                      -backend-config="prefix=jenkins"
                '''
            }
        }

    stage('Terraform Plan') { 
        steps
            { 
                sh ''' cd src && terraform plan \
                      -var="impersonate_sa=$GOOGLE_IMPERSONATE_SERVICE_ACCOUNT" \
                      -out=tfplan 
                  ''' 
              } 
            }

    stage('Terraform Apply') {
        when {
            allOf {
                expression { env.CHANGE_ID }
                expression { params.TERRAFORM_ACTION == 'apply' }
            }
        }

        steps {
        script 
        { 
            def pr = env.CHANGE_ID 
            def repo = "vinoddevlab/terraform-gcp" 
            def token = credentials('classic-git-pat') 

            def approvals = sh( script: """ curl -s -H "Authorization: token ${token}" https://api.github.com/repos/${repo}/pulls/${pr}/reviews """, returnStdout: true ).trim() 
            def prInfo = readJSON(text: approvals)
                .findAll { it.state == "APPROVED" }
            
            if (approvals.size() == 0) { 
                error("PR ${pr} has NOT been approved by reviewers") 
                } else 
                { 
                    echo "PR ${pr} is approved by reviewers" 
                }
        }
             
        script {
            def status = sh(script: '''
                cd src && terraform apply \
                -var="impersonate_sa=$GOOGLE_IMPERSONATE_SERVICE_ACCOUNT" \
                -auto-approve tfplan
            ''', returnStatus: true)

            echo "Terraform apply exit code: ${status}"
            }
        }

        }
    }
}
