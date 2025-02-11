pipeline {
    agent any
    
    environment {
        TF_VERSION = "1.5.0"
        TERRAFORM_BIN = "/usr/bin/terraform"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/your-repo/your-project.git'
                bat 'dir'
            }
        }
        
        stage('Setup Infrastructure') {
            steps {
                bat '''
                    echo Checking Terraform directory: %WORKSPACE%\terraform
                    if not exist "%WORKSPACE%\terraform" (
                        echo Terraform directory not found: %WORKSPACE%\terraform
                        exit /b 1
                    )
                    
                    echo Running Terraform via WSL...
                    wsl terraform -chdir=terraform init
                    wsl terraform -chdir=terraform apply -auto-approve
                '''
            }
        }
        
        stage('Build Application') {
            steps {
                bat '''
                    echo Checking Website directory: %WORKSPACE%\website
                    if not exist "%WORKSPACE%\website" (
                        echo Website directory not found: %WORKSPACE%\website
                        exit /b 1
                    )
                '''
            }
        }
        
        stage('Deploy Application') {
            steps {
                bat '''
                    echo Deploying to Apache server in WSL...
                    wsl sudo cp -r website/* /var/www/html/
                    wsl sudo systemctl restart apache2
                '''
            }
        }
    }
    
    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed! Check logs for errors.'
        }
    }
}
