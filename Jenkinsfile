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
                         // Validar si los parámetros están vacíos
                         if (params.EXECUTOR.trim() == '') {
                         error "El parámetro 'EXECUTOR' es obligatorio y no puede estar vacío."
                         }
                         if (params.MOTIVO.trim() == '') {
                         error "El parámetro 'MOTIVO' es obligatorio y no puede estar vacío."
                         }
                         if (params.CHAT_ID.trim() == '') {
                         error "El parámetro 'CHAT_ID' es obligatorio y no puede estar vacío."
                         }

                         // Si los parámetros son válidos, imprimirlos
                         echo "Executor: ${params.EXECUTOR}"
                         echo "Motivo: ${params.MOTIVO}"
                         echo "Chat ID: ${params.CHAT_ID}"
                    }
               }
          }
     }
}
