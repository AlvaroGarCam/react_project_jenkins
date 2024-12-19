# Jenkins Pipeline Project for React Deployment

## Introducción
Este proyecto utiliza Jenkins para automatizar un pipeline de integración y despliegue continuo (CI/CD) de una aplicación de React. A lo largo del pipeline, se realizan una serie de tareas como la instalación de dependencias, ejecución de pruebas, actualización de archivos, despliegue en Vercel y notificación a Telegram. Este `README.md` documenta los pasos realizados, conceptos fundamentales de Jenkins y las configuraciones necesarias para implementar la pipeline.

## Conceptos Teóricos
### Jenkins
Jenkins es una herramienta de automatización de código abierto utilizada para implementar pipelines de integración y entrega continua (CI/CD). Proporciona un entorno flexible para automatizar tareas como compilación, prueba, despliegue y entrega de software.

#### Características principales de Jenkins:
- **Open Source:** Gratuito y personalizable.
- **Plugins extensibles:** Más de 1,500 plugins para diferentes herramientas.
- **Integración con VCS:** Compatible con GitHub, GitLab, Bitbucket y otros.
- **Facilidad de uso:** Interfaz gráfica para crear pipelines mediante la UI o Jenkinsfile.

### Jenkinsfile
El Jenkinsfile es un script en formato de texto que define las etapas y pasos de una pipeline. Permite replicar configuraciones y versionar las definiciones de CI/CD junto con el código fuente del proyecto.

#### Beneficios del Jenkinsfile:
- Mantiene la pipeline bajo control de versiones.
- Es fácil de replicar en diferentes entornos.
- Ofrece claridad y documentación explícita del flujo de trabajo.

### Integración con Telegram
Mediante un bot de Telegram, Jenkins puede enviar notificaciones automáticas con el estado del pipeline. Esto permite a los desarrolladores estar informados sobre el progreso y posibles errores en tiempo real.

## Configuración del Proyecto

### Requisitos Previos
1. **Instalar Jenkins**: Descargue e instale Jenkins desde [jenkins.io](https://www.jenkins.io/).
2. **Configurar Node.js en Jenkins**:
   - Instalar el plugin de NodeJS.
   - Configurar una instalación global de Node.js en `Manage Jenkins > Global Tool Configuration`.
3. **Cuenta de Vercel**: Crear una cuenta en [vercel.com](https://vercel.com/) y generar un token de acceso.
4. **Bot de Telegram**: Crear un bot en Telegram y obtener su token de acceso siguiendo la [documentación oficial de Telegram](https://core.telegram.org/bots).
5. **Clave SSH**: Configurar una clave SSH para interactuar con GitHub.

### Configuración de la Pipeline
#### Pasos en la UI de Jenkins:
1. Acceda a `New Item` en la pantalla principal de Jenkins.
2. Asigne un nombre al proyecto y seleccione `Pipeline` como tipo de proyecto.
3. Configure las credenciales necesarias:
   - **Credenciales de GitHub (SSH)**: Para clonar el repositorio.
   - **Token de Telegram**: Guardar como `Secret Text`.
   - **Token de Vercel**: Guardar como `Secret Text`.
4. En la pestaña de configuración del pipeline:
   - Seleccione `Pipeline script from SCM`.
   - Configure la URL del repositorio y asegúrese de usar el protocolo SSH (`git@github.com:usuario/repositorio.git`).
   - Defina la rama del repositorio (por ejemplo, `ci_jenkins`).

### Jenkinsfile
El siguiente `Jenkinsfile` define todas las etapas de la pipeline, incluyendo:
- **Install Dependencies**: Instala dependencias de Node.js y la CLI de Vercel.
- **Linter**: Ejecuta ESLint para verificar errores en el código.
- **Test**: Realiza pruebas unitarias con Jest.
- **Update_Readme**: Actualiza el archivo `README.md` con el estado de las pruebas.
- **Push_Changes**: Realiza un commit y push al repositorio remoto.
- **Build**: Genera la versión de producción de la aplicación React.
- **Deploy to Vercel**: Despliega la aplicación en Vercel.
- **Notificació**: Envía un mensaje de resumen al bot de Telegram.


### Scripts Complementarios
Se utilizan scripts para realizar tareas específicas, como interactuar con Telegram y Vercel. Estos scripts están ubicados en la carpeta `jenkinsScripts`.

#### `sendTelegramMessage.sh`
Este script envía un mensaje al bot de Telegram con los resultados de la pipeline.

#### `pushChanges.sh`
Realiza un commit y push de los cambios al repositorio remoto.

## Resultados Obtenidos
El pipeline realiza todas las etapas mencionadas de manera automática. Los resultados se notifican al bot de Telegram en el siguiente formato:
```
S'ha executat la pipeline de Jenkins amb els següents resultats:
- Linter_stage: Correcte
- Test_stage: Correcte
- Update_readme_stage: Correcte
- Deploy_to_Vercel_stage: Correcte
```

## Conclusión
Esta práctica demuestra cómo integrar Jenkins con herramientas modernas como Telegram y Vercel para automatizar el flujo de trabajo de desarrollo. Este pipeline garantiza la calidad del código y simplifica el despliegue en producción, proporcionando un entorno confiable y eficiente para proyectos React.


## RESULTADO DE LOS ÚLTIMOS TESTS

![Success](https://img.shields.io/badge/tested%20with-Cypress-04C38E.svg)