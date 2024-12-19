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
                         def testResult = sh script: 'npm test', returnStatus: true

                         if (testResult != 0) {
                         sh 'echo "TEST_RESULT=failure" > .env'
                         error "Se encontraron errores en los tests. Por favor, corrígelos antes de continuar."
                         } else {
                         sh 'echo "TEST_RESULT=success" > .env'
                         }
                         echo "Todos los tests pasaron correctamente."
                    }
               }
          }

          stage('Update_Readme') {
               steps {
                    script {
                         withCredentials([usernamePassword(credentialsId: 'da329e7b-97e6-4165-ad68-01bc32cfb380', usernameVariable: 'GIT_USERNAME', passwordVariable: 'GIT_PASSWORD')]) {
                              echo "Sincronizando con el repositorio remoto antes de realizar cambios..."

                              // Limpieza del workspace y sincronización con la rama remota
                              sh """
                                   echo "Restableciendo cambios locales no comprometidos..."
                                   git reset --hard HEAD || echo "No hay cambios locales para restablecer."
                                   echo "Haciendo fetch de los últimos cambios..."
                                   git fetch origin ci_jenkins
                                   echo "Haciendo pull con rebase para evitar conflictos..."
                                   git pull --rebase origin ci_jenkins || (echo "Error durante el pull/rebase. Por favor, revisa los conflictos." && exit 1)
                              """

                              // Actualizar el README.md
                              sh """
                                   echo "Ejecutando el script updateReadme.js..."
                                   set -e
                                   bash -c 'source .env && node jenkinsScripts/updateReadme.js' || (echo "Error ejecutando el script de Node.js" && exit 1)
                              """

                              // Confirmar los cambios realizados en el README.md
                              sh """
                                   echo "Realizando commit solo para el README.md..."
                                   git config user.name "Jenkins Pipeline"
                                   git config user.email "jenkins@pipeline.local"
                                   git add README.md
                                   git commit -m "Update README.md with latest test results" || echo "Nada que confirmar, el archivo README.md no fue modificado."
                              """

                              // Realizar el push al repositorio remoto
                              sh """
                                   echo "Intentando realizar el push al repositorio remoto..."
                                   git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/AlvaroGarCam/react_project_jenkins ci_jenkins || (
                                   echo "El push falló. Reintentando..."
                                   git pull --rebase origin ci_jenkins
                                   git push https://${GIT_USERNAME}:${GIT_PASSWORD}@github.com/AlvaroGarCam/react_project_jenkins ci_jenkins
                                   ) || (echo "Error: No se pudo realizar el push a la rama ci_jenkins tras múltiples intentos." && exit 1)
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
