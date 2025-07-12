// pipeline {
//   agent any

//   tools {
//     maven "MVN3.9"
//     jdk "JDK17"
//   }

//    environment { 
//         registry = "ahmedlekan/democicd" 
//         registryCredential = 'dockerhub'

//         scannerHome = tool 'Sonar7.1'   
//         version = "1.0"                
//         projectName = "javaspringboot"     
//    }

//   stages {

//     stage('Checkout') {
//       steps {
//         git branch: 'main', credentialsId: 'git-credentials', url: 'https://github.com/Ahmedlekan/springboot-pipeline.git'
//       }
//     }
  
//    stage('Stage I: Build WAR') {
//       steps {
//         echo "Building Jar Component ..."
//         sh "mvn clean package -DskipTests"
//       }
//       post{
//         success{
//           echo "Archiving Artifact"
//           archiveArtifacts artifacts: 'target/*.war'
//         }
//       }
//     }

//     stage('Stage II:Unit Test') {
//         steps {
//             sh 'mvn test'
//         }
//     }

//    stage('Stage III: Code Coverage ') {
//       steps {
// 	    echo "Running Code Coverage ..."
//         sh "mvn jacoco:report"
//       }
//     }

//    stage('Stage IV: SCA (Software Composition Analysis)') {
//       steps { 
//         echo "Running SCA with OWASP Dependency-Check..."
//         sh "mvn org.owasp:dependency-check-maven:check"
//       }
//     }

//     stage('Stage V: SAST') {
//             steps {
//                 withSonarQubeEnv('sonarserver') {
//                     sh """${scannerHome}/bin/sonar-scanner \
//                         -Dsonar.projectKey=${projectName} \
//                         -Dsonar.projectName=${projectName} \
//                         -Dsonar.projectVersion=${version} \
//                         -Dsonar.sources=src/ \
//                         -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
//                         -Dsonar.junit.reportsPath=target/surefire-reports/ \
//                         -Dsonar.jacoco.reportsPath=target/site/jacoco/jacoco.xml \
//                         -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml"""
//                 }
//             }
//         }

//    stage('Stage VI: QualityGates') {
//       steps { 
//         echo "Running Quality Gates to verify the code quality"
//         script {
//           timeout(time: 1, unit: 'MINUTES') {
//             def qg = waitForQualityGate()
//             if (qg.status != 'OK') {
//               error "Pipeline aborted due to quality gate failure: ${qg.status}"
//             }
//            }
//         }
//       }
//     }

//     stage('Build Docker Image') {
//       steps {
//         echo "Building Docker Image..."
//         script {
//           dockerImage = docker.build(registry, '-f Docker-files/app/Dockerfile .')
//         }
//       }
//     }

//     stage('Push Docker Image') {
//       steps {
//         script {
//           docker.withRegistry('', registryCredential) {
//             dockerImage.push()
//           }
//         }
//       }
//     }
        
//    stage('Stage IX: Scan Image ') {
//       steps { 
//         echo "Scanning Image for Vulnerabilities"
//         sh "trivy image --scanners vuln --offline-scan ${registry}:latest > trivyresults.txt"
//         }
//     }
          
//    stage('Stage X: Smoke Test ') {
//       steps { 
//         echo "Smoke Test the Image"
//         sh "docker run -d --name smokerun -p 8081:8080 ${registry}"
//         sh "sleep 90"
//         sh "chmod +x check.sh"
//         sh "./check.sh"
//         sh "docker rm --force smokerun"
//         }
//     }
//   }

//   post {
//     always {
//       echo "Performing Cleanup..."
//       sh "docker rm -f smokerun || true"
//       sh "docker image prune -f"
//     }
//   }
// }

pipeline {
  agent any

  tools {
    maven "MVN3.9"
    jdk "JDK17"
  }

   environment { 
        springbootRegistry = "ecr:us-east-1:awscredentials";
        registry = "314146307160.dkr.ecr.us-east-1.amazonaws.com/springbootregistry";
        registryCredential = "https://314146307160.dkr.ecr.us-east-1.amazonaws.com";

        scannerHome = tool 'Sonar7.1'   
        version = "1.0"                
        projectName = "javaspringboot"     
   }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main', credentialsId: 'git-credentials', url: 'https://github.com/Ahmedlekan/springboot-pipeline.git'
      }
    }
  
   stage('Stage I: Build WAR') {
      steps {
        echo "Building Jar Component ..."
        sh "mvn clean package -DskipTests"
      }
      post{
        success{
          echo "Archiving Artifact"
          archiveArtifacts artifacts: 'target/*.war'
        }
      }
    }

    stage('Stage II:Unit Test') {
        steps {
            sh 'mvn test'
        }
    }

   stage('Stage III: Code Coverage ') {
      steps {
	    echo "Running Code Coverage ..."
        sh "mvn jacoco:report"
      }
    }

   stage('Stage IV: SCA (Software Composition Analysis)') {
      steps { 
        echo "Running SCA with OWASP Dependency-Check..."
        sh "mvn org.owasp:dependency-check-maven:check"
      }
    }

    stage('Stage V: SAST') {
            steps {
                withSonarQubeEnv('sonarserver') {
                    sh """${scannerHome}/bin/sonar-scanner \
                        -Dsonar.projectKey=${projectName} \
                        -Dsonar.projectName=${projectName} \
                        -Dsonar.projectVersion=${version} \
                        -Dsonar.sources=src/ \
                        -Dsonar.java.binaries=target/test-classes/com/visualpathit/account/controllerTest/ \
                        -Dsonar.junit.reportsPath=target/surefire-reports/ \
                        -Dsonar.jacoco.reportsPath=target/site/jacoco/jacoco.xml \
                        -Dsonar.java.checkstyle.reportPaths=target/checkstyle-result.xml"""
                }
            }
        }

   stage('Stage VI: QualityGates') {
      steps { 
        echo "Running Quality Gates to verify the code quality"
        script {
          timeout(time: 1, unit: 'MINUTES') {
            def qg = waitForQualityGate()
            if (qg.status != 'OK') {
              error "Pipeline aborted due to quality gate failure: ${qg.status}"
            }
           }
        }
      }
    }

    stage('Stage VII: Build App Image') {
      steps {
        echo "Building ECR App Image..."
        script {
          dockerImage = docker.build("${registry}:${env.BUILD_NUMBER}", "-f Docker-files/app/Dockerfile .")
        }
      }
    }

    stage("Stage VIII: Upload App Image"){
        steps{
            script{
                docker.withRegistry(registryCredential, springbootRegistry){
                    dockerImage.push("$BUILD_NUMBER")
                    dockerImage.push("latest")
                }
            }
        }
    }
  
  }

  post {
    always {
      echo "Performing Cleanup..."
      sh "docker image prune -f"
    }
  }
  
}
