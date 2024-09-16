@NonCPS
def getChangeString() {
    MAX_MSG_LEN = 100
    def changeString = ""

    echo "Gathering SCM changes"
    def changeLogSets = currentBuild.changeSets
    for (int i = 0; i < changeLogSets.size(); i++) {
        def entries = changeLogSets[i].items
        for (int j = 0; j < entries.length; j++) {
            def entry = entries[j]
            truncated_msg = entry.msg.take(MAX_MSG_LEN)
            changeString += " - ${truncated_msg} [${entry.author}]\n"
        }
    }

    if (!changeString) {
        changeString = " - No new changes"
    }
    return changeString
}

def COLOR_MAP = ['SUCCESS': 'good', 'FAILURE': 'danger', 'UNSTABLE': 'danger', 'ABORTED': 'danger']

pipeline {
  agent any 
  options {
	  ansiColor('xterm')
    disableConcurrentBuilds()
  }

  environment {
    AWS_PROFILE   = "jenkins"
    APP_IMAGE_TAG = "backend-api-" + "${BUILD_NUMBER}"
  }

  parameters {
    string (name: "gitBranch", defaultValue: "main", description: "Branch to build")
  }

//   triggers {
//     GenericTrigger(
//       genericVariables: [
//         [key: 'gitBranch', value: '$.ref']
//       ],
//       causeString: 'Triggered on $gitBranch',
//       token: "kvasmt-bK5Lm345tA",
//       printContributedVariables: true,
//       printPostContent: true,
//       silentResponse: false,
//       regexpFilterText: '$gitBranch',
//       regexpFilterExpression: '^refs/heads/main'
//       )
//   }

  stages {
    stage('Build image and Push to ECR') {
      steps {
        dir('app/backend/') {
          sh '''

            aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin 913524938299.dkr.ecr.ap-southeast-1.amazonaws.com  

            DOCKER_BUILDKIT=1 docker build --build-arg BUILDKIT_INLINE_CACHE=1 \
            -t 913524938299.dkr.ecr.ap-southeast-1.amazonaws.com/kvasmt/development-backend:$APP_IMAGE_TAG \
            -t 913524938299.dkr.ecr.ap-southeast-1.amazonaws.com/kvasmt/development-backend:latest .
            
            docker push 913524938299.dkr.ecr.ap-southeast-1.amazonaws.com/kvasmt/development-backend:$APP_IMAGE_TAG
            docker push 913524938299.dkr.ecr.ap-southeast-1.amazonaws.com/kvasmt/development-backend:latest
            docker rmi 913524938299.dkr.ecr.ap-southeast-1.amazonaws.com/kvasmt/development-backend:$APP_IMAGE_TAG
            docker rmi 913524938299.dkr.ecr.ap-southeast-1.amazonaws.com/kvasmt/development-backend:latest

          '''
        }
      }
    }

    stage('Update Version and Deploy') {
      steps {
        script {
          // Get ArgoCD credentials from Vault
          def vaultAddress = 'https://vault.demo.kietvo.vn'
          def vaultCredentials = [
            [path: 'secret/argocd', secretValues: [
              [envVar: 'ARGOCD_USERNAME', vaultKey: 'username'],
              [envVar: 'ARGOCD_PASSWORD', vaultKey: 'password'],
              [envVar: 'ARGOCD_SERVER', vaultKey: 'server']
            ]]
          ]
          
          withVault([vaultUrl: vaultAddress, vaultCredentialId: 'vault-approle', secrets: vaultCredentials]) {
            // Update the tag version in values.yaml
            sh """
              sed -i 's/tag: .*/tag: ${APP_IMAGE_TAG}/' charts/private/backend/values.yaml
              git config user.email "jenkins-bot-demo@kietvo.vn"
              git config user.name "Jenkins-bot"
              git add charts/private/backend/values.yaml
              git commit -m "Update backend image tag to ${APP_IMAGE_TAG}"
              git push origin ${params.gitBranch}
            """

            // Deploy using ArgoCD
            sh """
              argocd login $ARGOCD_SERVER --username $ARGOCD_USERNAME --password $ARGOCD_PASSWORD --insecure
              argocd app sync backend
              argocd app wait backend
            """
          }
        }
      }
    }
  }

  post {
    always {
      cleanWs()
   }
  } 
} 
