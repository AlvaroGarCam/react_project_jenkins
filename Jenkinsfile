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
                              // Exportar la variable TEST_RESULT como 'failure' si los tests fallan
                              sh 'echo "TEST_RESULT=failure" > .env'
                              error "Se encontraron errores en los tests. Por favor, corrígelos antes de continuar."
                         } else {
                              // Exportar la variable TEST_RESULT como 'success' si los tests pasan
                              sh 'echo "TEST_RESULT=success" > .env'
                         }
                         echo "Todos los tests pasaron correctamente."
                    }
               }
          }

          stage('Update_Readme') {
               steps {
                    script {
                         echo "Actualizando el archivo README.md con el resultado de los tests..."

                         // Comprobar versiones de Node.js y npm
                         sh """
                              echo "Comprobando entorno de Node.js y npm..."
                              node --version || (echo "Node.js no está instalado correctamente." && exit 1)
                              npm --version || (echo "npm no está instalado correctamente." && exit 1)
                         """

                         // Verificar existencia de la carpeta jenkinsScripts y sus archivos
                         sh """
                              echo "Verificando la carpeta jenkinsScripts..."
                              ls -l jenkinsScripts || (echo "La carpeta jenkinsScripts no existe o no es accesible." && exit 1)
                         """

                         // Mostrar contenido del archivo .env para verificar TEST_RESULT
                         sh """
                              echo "Verificando contenido del archivo .env..."
                              if [ -f .env ]; then
                                   cat .env
                              else
                                   echo "El archivo .env no existe o no se generó correctamente."
                              fi
                         """

                         // Comprobar permisos para escribir en el directorio
                         sh """
                              echo "Comprobando permisos de escritura en el directorio..."
                              touch test_file || (echo "No se puede crear un archivo en el directorio actual." && exit 1)
                              rm test_file
                         """

                         // Mostrar contenido del archivo README.md antes de actualizar
                         sh """
                              echo "Contenido actual del README.md:"
                              if [ -f README.md ]; then
                                   cat README.md
                              else
                                   echo "El archivo README.md no existe."
                              fi
                         """

                         // Ejecutar el script de actualización del README.md
                         sh """
                              echo "Ejecutando el script updateReadme.js..."
                              set -e
                              source .env
                              node jenkinsScripts/updateReadme.js || (echo "Error ejecutando el script de Node.js" && exit 1)
                         """
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
                         // if (params.EXECUTOR.trim() == '') {
                         // error "El parámetro 'EXECUTOR' es obligatorio y no puede estar vacío."
                         // }
                         // if (params.MOTIVO.trim() == '') {
                         // error "El parámetro 'MOTIVO' es obligatorio y no puede estar vacío."
                         // }
                         // if (params.CHAT_ID.trim() == '') {
                         // error "El parámetro 'CHAT_ID' es obligatorio y no puede estar vacío."
                         // }

                         echo "Executor: ${params.EXECUTOR}"
                         echo "Motivo: ${params.MOTIVO}"
                         echo "Chat ID: ${params.CHAT_ID}"
                    }
               }
          }
     }
}
