pipeline {
    agent any
    environment {
        TF_VERSION = "1.10.5"
        TERRAFORM_BIN = "C://Program Files//Terraform//terraform_1.10.5_windows_amd64//terraform.exe"

    }
   
    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/pavithra-m13/Devops_Pipeline.git/'
            }
        }
        stage('Setup Infrastructure') {
            steps {
                powershell '''
                    $workspacePath = Get-Location
                    Write-Host "Resolved WORKSPACE path: $workspacePath"
                    $terraformPath = Join-Path -Path $workspacePath -ChildPath "terraform"
                    Write-Host "Checking Terraform directory: $terraformPath"
                    if (-Not (Test-Path -Path $terraformPath -PathType Container)) {
                        Write-Host "Terraform directory not found: $terraformPath"
                        exit 1
                    }
                    Write-Host "Listing Terraform directory contents:"
                    Get-ChildItem -Path $terraformPath -Recurse
                   
                    Set-Location -Path $terraformPath
                    Start-Process -FilePath "$env:TERRAFORM_BIN" -ArgumentList "init" -NoNewWindow -Wait
                    Start-Process -FilePath "$env:TERRAFORM_BIN" -ArgumentList "apply -auto-approve" -NoNewWindow -Wait
                '''
            }
        }

        stage('Prepare Application Files') {
            steps {
                powershell '''
                    $workspacePath = Get-Location
                    $websitePath = Join-Path -Path $workspacePath -ChildPath "website"
                    Write-Host "Checking Website directory: $websitePath"
                    if (-Not (Test-Path -Path $websitePath -PathType Container)) {
                        Write-Host "Website directory not found: $websitePath"
                        exit 1
                    }
                    Write-Host "Website files are ready for deployment."
                '''
            }
        }
       
        stage('Deploy Application') {
            steps {
                powershell '''
                    $workspacePath = Get-Location
                    $websitePath = Join-Path -Path $workspacePath -ChildPath "website"
                    Write-Host "Deploying from: $websitePath"
                    Copy-Item -Path "$websitePath/*" -Destination "C:/inetpub/wwwroot/" -Recurse -Force
                    Restart-Service W3SVC
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
