def sendEmail()
{
    mailRecipients = "moode.roopabai@dxc.com"
    emailext body: '''Hello Team, We got the result for the pipeline "${JOB_NAME}", please find the logs in the attachment''',
    mimeType: 'text/html',
    attachLog: true,
    subject: "${currentBuild.fullDisplayName} - Build ${currentBuild.result}",
    to: "${mailRecipients}",
    replyTo: "${mailRecipients}",
    recipientProviders: [[$class: 'CulpritsRecipientProvider']]
}

pipeline {
 environment {    
    
    OCP_ENV_SELECTED=""
    app_selected=""
    env_selected=""
    deploy_selected=""
    service_selected=""
    // export all pipeline build variables 
    //def APPLICATION_NAME="sample-image"
    //def K8s_DEPLOYMENT_FILE="sample-deployment.yaml"
    //def K8s_DEPLOYMENT_SERVICE_FILE="sample-service.yaml"
    BASE_IMAGE_NAME="${DOCKER_REPO_PATH}"+"${APPLICATION_NAME}"
    DOCKER_IMAGE="${BASE_IMAGE_NAME}"+":"+"${GIT_COMMIT}"
    LATEST_TAG="${BASE_IMAGE_NAME}"+":latest"
    //This variable should change for different environments
    ENV_VAR="dev"    
    url="http://localhost:%CONTAINER_PORT%/spring-jboss-0.0.1-SNAPSHOT/hello"
    SAMPLE_APP_NAME="spring-jboss"
    SAMPLE_IMG_NAME="sample-eap"
    
   }
  agent any
 /* {
    node {
            label 'Dev-Slave'
        }
    } */
parameters {
         booleanParam(name: "Local", defaultValue: true, description: 'WINDOWS Operating system')
         booleanParam(name: "MSVx", defaultValue: false)
         booleanParam(name: "AWS", defaultValue: false)
         
         //choice(name: 'Platform', choices: ['Local', 'MSVx', 'AWS'],  description: 'Platform where application will be deployed')
        
    }

stages {
    stage('Parse Env CSV For Openshift Container Platform') {
            steps {
                script {
                    readFile("${ocp_env_app_inv}").split('\n').each { line, count -> 
                    app_selected = params.APPLICATION_NAME
                    env_selected = params.CONTAINER_PLATFORM_ENV
                    deploy_selected = params.CONTAINER_PLATFORM_DEPLOY
                    service_selected = params.CONTAINER_PLATFORM_SERVICE
                   
                    }
                }
            }
        }
    stage('Checkout') {
      steps {
        //checkout([$class: 'GitSCM', branches: [[name: '*/xsh_Final']], extensions: [], userRemoteConfigs: [[credentialsId: '6cc19445-3688-4efa-b8c8-989ad4e7bf27', url: 'git@github.dxc.com:LMA-FERN-App-Remediation/XA0165-XSH.git']]])
        //checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: '6cc19445-3688-4efa-b8c8-989ad4e7bf27', url: 'https://github.dxc.com/LMA-FERN-App-Remediation/sample.git']]])
        script {
            //if (${app_selected}==params.App){
            checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/rathanarajr/spring-jboss.git']]])
            //} else {
                // checkout([$class: 'GitSCM', branches: [[name: '*/xsh_Final']], extensions: [], userRemoteConfigs: [[credentialsId: '6cc19445-3688-4efa-b8c8-989ad4e7bf27', url: 'git@github.dxc.com:LMA-FERN-App-Remediation/XA0165-XSH.git']]])
            //}             
        }            
        
      }
    }

    stage('Build App') {
        
      steps 
	  {
        script {
                    if (params.Local) {
                         configFileProvider([configFile(fileId: 'Maven-settings', variable: 'Maven_settings')]) {
                         bat 'mvn clean package'
                    }
                    } else {
                        if (params.platform=="MSVx") {
                            configFileProvider([configFile(fileId: 'Maven-settings', variable: 'Maven_settings')]) {
                                sh 'mvn clean package'
                            }
                        }    
                }
	     
          } 
      }
     } 
 /*stage('SonarQube Analysis') {
  steps {
        configFileProvider([configFile(fileId: 'Maven-settings', variable: 'Maven_settings')]) {
    sh 'mvn clean install sonar:sonar -Dsonar.projectName=XSH -Dsonar.host.url=http://localhost:9000/ -Dsonar.login=f7e2f1db7d19189a8d545089daf5bd7ea0d38d0e -Dsonar.login=admin -Dsonar.password=sonarqube -f xsh-multi-module/pom.xml'

}
}
}*/
/*stage('Sonar Report Generation') {
      steps{
               sh label: '', script:'''#!/bin/bash
                           CURRENTEPOCTIME=`date +"%Y-%m-%d"`
                           rm -rf xsh-sonar_reports*
                           mkdir -p xsh-sonar_reports_${BUILD_ID}
                           java -jar /data1/jenkins/sonar-cnes-report-4.0.0.jar -p XSH -t f7e2f1db7d19189a8d545089daf5bd7ea0d38d0e -m -f -o xsh-sonar_reports_${BUILD_ID}/ --disable-conf
                           tar -czvf xsh-sonar_reports_${BUILD_ID}_${CURRENTEPOCTIME}.tgz xsh-sonar_reports_${BUILD_ID}'''
            }
		} */
stage('Build Docker Image') {
     steps 
	  {
        script {
                        if (params.Local) {     
                            bat 'xcopy /s/y "C:/Users/rr38/.jenkins/workspace/spring-jboss/target" "C:/Users/rr38/.jenkins/workspace/spring-jboss"'
                            //bat 'docker build --tag spring-jboss .'
                            //bat 'docker build --tag sample-eap .'
                             //bat 'docker run -d -p 9999:9999 -p 9990:9990 spring-jboss'
                            //bat 'docker run -d -p 8880:8880 -p 8883:8883 sample-eap'
                            //docker login ${DOCKER_REGISTRY_URL_HUB} -u ${DOCKER_USER_LOCAL} -p ${DOCKER_LOCAL_PASSWORD}'
                            // WORKING: bat 'docker run -p 8880:8080 sample-eap'
                           // bat 'docker push ${env.DOCKER_IMAGE}'
                            //bat 'sudo docker push ${env.LATEST_TAG}'
                            //bat 'docker image remove ${envDOCKER_IMAGE}'
                            //bat 'docker image remove ${LATEST_TAG}'
                            
                            //bat "%cd%\\MySimpleProject\\bin\\Execute.bat ${env.BRANCH_NAME}"}
                            bat "C:/Users/rr38/.jenkins/workspace/spring-jboss/runDocker.bat ${env.SAMPLE_APP_NAME} ${env.SAMPLE_IMG_NAME}"
                            
                            bat 'start chrome "http://localhost:8880/spring-jboss-0.0.1-SNAPSHOT/hello"'
                        } else {
                            sh '''
                                sudo docker login ${DOCKER_REGISTRY_URL} -u ${DOCKER_USER} -p ${DOCKER_PASSWORD}
                                sudo docker build -t ${DOCKER_IMAGE} .
                                sudo docker build -t ${LATEST_TAG} .
                            '''        
                            sh "./gradlew preRelease"
                        }
	           }
        }
    }


stage('Push Image to Artifactory') { 
      steps {
            script {
                    if (params.Local) {
                           
                            //bat 'docker login ${env.DOCKER_REGISTRY_URL} -u ${env.DOCKER_USER} -p ${env.DOCKER_PASSWORD}'
                            //bat 'docker push ${env.DOCKER_IMAGE}'
                            //bat 'docker push ${env.LATEST_TAG}'
                            //bat "%cd%\\MySimpleProject\\bin\\Execute.bat ${env.BRANCH_NAME}"
                            //bat "%cd%\\spring-jboss\\runDocker.bat ${env.BRANCH_NAME} ${env.BRANCH_NAME} ${env.BRANCH_NAME} ${env.BRANCH_NAME} ${env.BRANCH_NAME}" 
                            
                         //   start chrome ${url}                            
                    } else {
                        sh ''' 
                            sudo docker push ${DOCKER_IMAGE}
                            sudo docker push ${LATEST_TAG}
                            sudo docker image remove ${DOCKER_IMAGE}
                            sudo docker image remove ${LATEST_TAG}                            
		                '''
                    }
                }       
}
}

stage('Connect to Openshift ') {
      steps 
	  {
        script {
                    if (params.Local) {
                        echo "oc login windows"
                    } else {        
                        sh '''
                            echo "Connecting Openshift"
                           
                        '''
                    }
                }
    }
	}

stage('Deployment on OCP ') {
            steps 
            {
                script {
                    if (params.Local) {
                        echo "oc deploy windows"
                    } else {         
                        sh '''               
                            //sudo sh dockerbuild.sh
                            cd k8s
                            //sudo sh kubedeploy.sh
                           
                            oc apply -f ${K8s_DEPLOYMENT_FILE}
                            oc apply -f ${K8s_DEPLOYMENT_SERVICE_FILE}
                            #cat ${K8s_DEPLOYMENT_FILE}
                        '''
                    }
            }
        }
	}	


/* stage('Deploy') { 
      steps {
	  sh '''
       curl -u "svc-lma-remediation:Wg^65#mjn((" https://artifactory.dxc.com:443/artifactory/lma-maven/XSH/xsh-ear-0.0.1-SNAPSHOT.ear -o xsh-ear-0.0.1-SNAPSHOT.ear

       sshpass -p 'jboss-as' scp /data1/jenkins/workspace/xsh-deploy/xsh-ear-0.0.1-SNAPSHOT.ear jboss-as@10.15.172.44:/data/jboss-eap-7.3/standalone/deployments
       '''
      }	  
}*/
}	
}
