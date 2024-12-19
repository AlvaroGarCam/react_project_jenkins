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
                         def testResult = sh script: 'npm test', returnStatus: true

                         if (testResult != 0) {
                         env.TEST_RESULT = 'failure'
                         error "Se encontraron errores en los tests. Por favor, corrígelos antes de continuar."
                         } else {
                         env.TEST_RESULT = 'success'
                         }
                         echo "Todos los tests pasaron correctamente."
                    }
               }
          }

          stage('Update_Readme') {
               steps {
                    script {
                         echo "Actualizando el README.md con el resultado de los tests..."
                         // Ejecutar el script de actualización del README.md
                         sh """
                         echo "Ejecutando el script updateReadme.js con TEST_RESULT=${env.TEST_RESULT}..."
                         node ./jenkinsScripts/updateReadme.js ${env.TEST_RESULT}
                         """
                    }
               }
          }

          stage('Push_Changes') {
               steps {
                    script {
                         withCredentials([sshUserPrivateKey(credentialsId: 'da329e7b-97e6-4165-ad68-01bc32cfb380', keyFileVariable: 'SSH_KEY')]) {
                         echo "Configurando SSH para hacer el push..."
                         sh """
                              eval \$(ssh-agent -s)
                              ssh-add ${SSH_KEY}
                              bash ./jenkinsScripts/pushChanges.sh '${params.EXECUTOR}' '${params.MOTIVO}'
                         """
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
