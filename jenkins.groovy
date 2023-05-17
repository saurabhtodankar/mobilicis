pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                // Checkout source code from version control (e.g., Git)
                git 'https://github.com/my-repo/my-app.git'
                
                // Build your application (e.g., compile, package)
                sh 'mvn clean package'
            }
        }
        
        stage('Test') {
            steps {
                // Run tests for your application
                sh 'mvn test'
            }
        }
        
        stage('Deploy') {
            steps {
                // Deploy your application
            sudo docker build -f Dockerfile -t app .
            export ecrpass=$(aws ecr get-login-password --region ap-south-1)
            sudo docker login -u AWS 123456.dkr.ecr.ap-south-1.amazonaws.com/docker-repo -p $ecrpass
            export dockerid=$(sudo docker images --format='{{.ID}}' | head -1)
            sudo docker tag $dockerid 123456.dkr.ecr.ap-south-1.amazonaws.com/docker-repo:latest
            sudo docker push 123456.dkr.ecr.ap-south-1.amazonaws.com/docker-repo:latest
        }
    }
}
