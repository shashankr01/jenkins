pipeline {
	agent { label 'master' }
	stages {
		stage('Run Junit'){
			steps{
				sh "mvn clean test"
			}
		}
		
		//stage('Sonar Analysis'){
		//	sh "org.sonarsource.scanner.maven:sonar-maven-plugin:3.3.0.603:sonar -Dsonar.host.url=http://52.187.188.41:9000/ -Dsonar.login=admin -Dsonar.password=admin"
		
		//}
		stage('SonarQube analysis') {
			steps{
				// requires SonarQube Scanner 2.8+
				//def scannerHome = tool 'SonarQube Scanner 2.8';
				withSonarQubeEnv('sonar') {
					sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.3.0.603:sonar'
				}
			}
		}
		
		stage('Build App'){
			steps{
				sh "mvn clean install"
			}
		}
		
		stage('Upload War'){
			steps{
			
				nexusArtifactUploader artifacts: [[artifactId: 'jpetstore', classifier: 'SNAPSHOT', file: 'target/jpetstore.war', type: 'war']], credentialsId: 'nexusID', groupId: 'org', nexusUrl: '192.168.77.11:8443/repository/jpetStoreRepo', nexusVersion: 'nexus3', protocol: 'https', repository: 'jpetStoreRepo', version: "${env.BUILD_NUMBER}"
			}
		}
	}
	post {
+		unstable{
+			emailext (
+                subject: "Unit test failed: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
+                body: """Unit test failed: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'
+                    Check console output at '${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]""",
+                recipientProviders: [[$class: 'FailingTestSuspectsRecipientProvider']],to: 'raj.totaldevops@gmail.com'
+            )
+		}
+		
+        failure {
+            script {
+                currentBuild.result = 'FAILURE'
+            }
+            emailext (
+                subject: "Build failed: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'",
+                body: """Build failed: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]'
+                Check console output at '${env.BUILD_URL}'>${env.JOB_NAME} [${env.BUILD_NUMBER}]""",
+                recipientProviders: [[$class: 'DevelopersRecipientProvider']],to: 'raj.totaldevops@gmail.com'
+            )
+        }
+	}

}
