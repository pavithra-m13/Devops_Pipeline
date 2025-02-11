pipeline {
    agent any
    
    environment {
        TF_VERSION = "1.5.0"
        TERRAFORM_BIN = "/usr/local/bin/terraform"
    }
    
    stages {
        stage('Checkout Code') {
            steps {
                // Checkout code from GitHub
                git 'https://github.com/pavithra-m13/Devops_Pipeline.git'
                // Run listing of workspace contents using bash (in WSL)
                sh 'bash -c "echo Listing workspace contents after checkout; ls -la"'
            }
        }
        
        stage('Setup Infrastructure') {
            steps {
                // Initialize and apply Terraform in the appropriate directory
                sh '''
                    echo "Resolved WORKSPACE path: $(pwd)"
                    echo "Checking Terraform directory: $(pwd)/terraform"
                    
                    if [ ! -d "terraform" ]; then
                        echo "Terraform directory not found: $(pwd)/terraform"
                        exit 1
                    fi
                    
                    echo "Initializing Terraform..."
                    cd terraform
                    $TERRAFORM_BIN init
                    $TERRAFORM_BIN apply -auto-approve
                '''
            }
        }
        
        stage('Build Application') {
            steps {
                // Check for the website directory
                sh '''
                    echo "Checking Website directory: $(pwd)/website"
                    if [ ! -d "website" ]; then
                        echo "Website directory not found: $(pwd)/website"
                        exit 1
                    fi
                '''
            }
        }
        
        stage('Deploy Application') {
            steps {
                // Deploy website files to Apache server
                sh '''
                    echo "Deploying to Apache server..."
                    sudo cp -r website/* /var/www/html/
                    sudo systemctl restart apache2
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
