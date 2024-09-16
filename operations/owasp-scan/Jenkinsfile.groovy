def COLOR_MAP = ['SUCCESS': 'good', 'FAILURE': 'danger', 'UNSTABLE': 'danger', 'ABORTED': 'danger']

pipeline {

  agent any
  options {
    ansiColor('xterm')
    disableConcurrentBuilds()
  }

  parameters {
    text(
      name: 'List_TARGET',
      defaultValue: """demo.kietvo.vn
""",
      description: "List of url for OWASP ZAP Scan"
    )
    booleanParam(
      name: 'ZAP_FULL_SCAN',
      defaultValue: false,
      description: 'Default is Baseline scan'
    )
    booleanParam(
      name: 'CLEAN_ALL_REPORTS',
      defaultValue: false,
      description: 'Cleaning all history html reports'
    )
  }

  stages {
    stage('Check clean reports'){
      steps {
        script {
          if ( params.CLEAN_ALL_REPORTS) {
            sh 'rm -rf operation/owasp-scan/reports/*.html'
          }
        }
      }
    }

    stage('Running OWASP ZAP SCANNING') {
      environment {
        ZAP_SCAN_OPTIONS = 'zap-baseline.py'
      }
      steps {
        dir('operation/owasp-scan') {
          script {
            if ( params.ZAP_FULL_SCAN ) {
              env.ZAP_SCAN_OPTIONS = "zap-full-scan.py"
            }
            try {
              sh 'chmod 777 $(pwd) && chmod 777 reports'
              sh './owasp-scan.sh'
            } catch(err){
              echo "There are some warning tests"
            }
          }
        }
      }
    }
  } // End stages

 post {
   always {
    publishHTML (target : [allowMissing: false,
      alwaysLinkToLastBuild: true,
      keepAll: true,
      reportDir: 'operation/owasp-scan/reports',
      reportFiles: '*.html',
      reportName: 'OWASP ZAP SCAN Reports',
      reportTitles: ''])
   }
 }
} // End pipeline
