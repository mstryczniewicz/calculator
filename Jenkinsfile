pipeline {
     agent any
     triggers {
          pollSCM('* * * * *')
     }
     environment {
          STAGING_SERVER = "192.168.57.6"
     }
     stages {
          stage("Compile") {
               steps {
                    sh "./gradlew compileJava"
               }
          }
          stage("Unit test") {
               steps {
                    sh "./gradlew test"
               }
          }
          stage("Code coverage") {
               steps {
	          sh "./gradlew jacocoTestReport"
	          publishHTML (target: [
	               reportDir: 'build/reports/jacoco/test/html',
	               reportFiles: 'index.html',
	               reportName: "JaCoCo Report"
	          ])
	          sh "./gradlew jacocoTestCoverageVerification"
               }
          }
          stage("Static code analysis") {
               steps {
                  sh "./gradlew checkstyleMain"
                  publishHTML (target: [
                      reportDir: 'build/reports/checkstyle/',
                      reportFiles: 'main.html',
                      reportName: "Checkstyle Report"
                  ])
               }
          }
	  stage("Package") {
	       steps {
	            sh "./gradlew build"
	       }
          }
	  stage("Docker build") {
	       steps {
	            sh "docker build -t mstryczniewicz/calculator ."
	       }
	  }
	  stage("Docker push") {
	       steps {
		    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
		        sh "docker login --username $USERNAME --password $PASSWORD"
		    }
		    sh "docker push mstryczniewicz/calculator"
	       }
	  }
	  stage("Deploy to staging") {
	       steps {
		    sh 'docker -H "$STAGING_SERVER" run -d --rm -p 8765:8080 --name calculator mstryczniewicz/calculator'
	       }
	  }
	  stage("Acceptance test") {
	       steps {
		    sleep 60
		    sh 'chmod +x acceptance_test.sh && ./acceptance_test.sh "$STAGING_SERVER"'
	       }
	  }
     }
     post {
	  always {
		sh 'docker -H "$STAGING_SERVER" stop calculator'
	  }
     }
}
