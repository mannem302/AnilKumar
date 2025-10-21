pipeline {
    agent any
   tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "maven-3.9.2"
    } 
   
    stages {
        stage('GitCloneStage') {
            steps {
                git branch: 'main', url: 'https://github.com/mannem302/AnilKumar.git'
            }
        }
        stage('CodeBuildStage') {
            steps {
                sh 'mvn clean package'
            }
        }
        
    }
}
