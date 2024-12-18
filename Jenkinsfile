pipeline {
     agent any

     parameters {
          string(name: 'EXECUTOR', defaultValue: '', description: 'Nombre de la persona que ejecuta la pipeline')
          string(name: 'MOTIVO', defaultValue: '', description: 'Motivo por el cual se ejecuta la pipeline')
          string(name: 'CHAT_ID', defaultValue: '', description: 'Chat ID de Telegram para las notificaciones')
     }

     stages {
          stage('Petició de dades') {
               steps {
                    script {
                         if (params.EXECUTOR.trim() == '') {
                         error "El parámetro 'EXECUTOR' es obligatorio y no puede estar vacío."
                         }
                         if (params.MOTIVO.trim() == '') {
                         error "El parámetro 'MOTIVO' es obligatorio y no puede estar vacío."
                         }
                         if (params.CHAT_ID.trim() == '') {
                         error "El parámetro 'CHAT_ID' es obligatorio y no puede estar vacío."
                         }

                         echo "Executor: ${params.EXECUTOR}"
                         echo "Motivo: ${params.MOTIVO}"
                         echo "Chat ID: ${params.CHAT_ID}"
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
     }
}
