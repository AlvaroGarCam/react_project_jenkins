pipeline {
     agent any

     tools {
          nodejs "Node" // Asegúrate de que "Node" coincida con el nombre configurado en Jenkins
     }

     parameters {
          string(name: 'EXECUTOR', defaultValue: '', description: 'Nombre de la persona que ejecuta la pipeline')
          string(name: 'MOTIVO', defaultValue: '', description: 'Motivo por el cual se ejecuta la pipeline')
          string(name: 'CHAT_ID', defaultValue: '', description: 'Chat ID de Telegram para las notificaciones')
     }

     environment {
          TEST_RESULT = '' // Variable para almacenar el resultado de los tests
     }

     stages {
          stage('Install Dependencies') {
               steps {
                    script {
                         echo "Instalando dependencias..."
                         sh 'npm install'
                    }
               }
          }

          stage('Linter') {
               steps {
                    script {
                         echo "Ejecutando ESLint para revisar el código..."
                         def lintResult = sh script: 'npx eslint .', returnStatus: true

                         if (lintResult != 0) {
                         error "Se encontraron errores en el linter. Por favor, corrígelos antes de continuar."
                         }
                         echo "Linter ejecutado correctamente, no se encontraron errores."
                    }
               }
          }

          stage('Test') {
               steps {
                    script {
                         echo "Ejecutando tests con Jest..."
                         def testResult = sh(script: 'npm test', returnStatus: true)

                         if (testResult != 0) {
                         currentBuild.result = 'FAILURE'
                         sh "echo 'failure' > test_result.txt"
                         error "Se encontraron errores en los tests. Por favor, corrígelos antes de continuar."
                         } else {
                         sh "echo 'success' > test_result.txt"
                         }
                         echo "Todos los tests pasaron correctamente."
                    }
               }
          }

          stage('Update_Readme') {
               steps {
                    script {
                         env.TEST_RESULT = sh(script: "cat test_result.txt", returnStdout: true).trim()
                         echo "Actualizando el README.md con el resultado de los tests (${env.TEST_RESULT})..."
                         sh """
                         echo "Ejecutando el script updateReadme.js con TEST_RESULT=${env.TEST_RESULT}..."
                         node ./jenkinsScripts/updateReadme.js ${env.TEST_RESULT}
                         """
                    }
               }
          }
          
          // stage('Push_Changes') {
          //      steps {
          //           script {
          //                withCredentials([usernamePassword(credentialsId: 'da329e7b-97e6-4165-ad68-01bc32cfb380', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
          //                     echo "Realizando el push con HTTPS..."
          //                     sh """
          //                          git config --global user.name "${params.EXECUTOR}"
          //                          git config --global user.email "jenkins@pipeline.local"
          //                          git add README.md
          //                          git commit -m "Update README.md by ${params.EXECUTOR} - ${params.MOTIVO}" || echo "Nada que commitear."
          //                          git pull --rebase origin ci_jenkins
          //                          git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/AlvaroGarCam/react_project_jenkins HEAD:ci_jenkins
          //                     """
          //                }
          //           }
          //      }
          // }

          stage('Build') {
               steps {
                    script {
                         echo "Realizando el build del proyecto..."
                         def buildResult = sh script: 'npm run build', returnStatus: true

                         if (buildResult != 0) {
                         error "El proceso de build falló. Por favor, revisa los errores antes de continuar."
                         }
                         echo "Build realizado correctamente. El proyecto está listo para desplegarse."
                    }
               }
          }

          stage('Petició de dades') {
               steps {
                    script {
                         echo "Executor: ${params.EXECUTOR}"
                         echo "Motivo: ${params.MOTIVO}"
                         echo "Chat ID: ${params.CHAT_ID}"
                    }
               }
          }
     }
}
