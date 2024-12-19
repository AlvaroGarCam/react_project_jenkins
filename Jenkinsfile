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
                         def testResult = sh(script: 'npm test', returnStatus: true) // Ejecuta los tests y captura el estado

                         if (testResult != 0) {
                         // Si fallan los tests, devolver 'failure'
                         writeFile file: 'test_result.txt', text: 'failure' // Guardar resultado en archivo
                         error "Se encontraron errores en los tests. Por favor, corrígelos antes de continuar."
                         } else {
                         // Si los tests pasan, devolver 'success'
                         writeFile file: 'test_result.txt', text: 'success' // Guardar resultado en archivo
                         }
                         echo "Todos los tests pasaron correctamente."
                    }
               }
          }

          stage('Update_Readme') {
               steps {
                    script {
                         // Leer el resultado directamente desde el archivo `test_result.txt`
                         def testResult = readFile('test_result.txt').trim()

                         echo "Actualizando el README.md con el resultado de los tests (${testResult})..."

                         sh """
                         echo "Ejecutando el script updateReadme.js con TEST_RESULT=${testResult}..."
                         node ./jenkinsScripts/updateReadme.js ${testResult}
                         """
                    }
               }
          }

          stage('Push_Changes') {
               steps {
                    script {
                         withCredentials([sshUserPrivateKey(credentialsId: 'jenkins-stage-key', keyFileVariable: 'SSH_KEY')]) {
                              echo "Realizando el push al repositorio remoto..."
                              
                              def pushResult = sh(
                                   script: """
                                   chmod 600 $SSH_KEY
                                   eval \$(ssh-agent -s)
                                   ssh-add $SSH_KEY
                                   sh ./jenkinsScripts/pushChanges.sh '${params.EXECUTOR}' '${params.MOTIVO}'
                                   """,
                                   returnStatus: true
                              )
                              
                              if (pushResult != 0) {
                                   error "El push falló. Revisa el log para más detalles."
                              }
                         }
                    }
               }
          }

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

