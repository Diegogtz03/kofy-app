# KOFY
Kofy is an AI iOS app for inclusion designed with deaf people in mind to bridge the communication gap with the medical industry.

## Features
- Transcribe speech to text and vocalize text to speech.
- Summarize speech sessions using OpenAI's API with doctor's approval of the summary.
- Scan prescriptions and give summaries of the medicine and possible reminders using Generative AI.
- Using ML, identifies medical instruments and provides information cards with it's usage in sign language.
- Reminds users of their medicine intake.

## Possible Improvements
- Allow users to store full converstations instead of summaries.
- Allow for summaries to be generated later if network isn't available.
- Give a tour for first time users.
- Allow users to verify extracted text from prescriptions before summarizing the data.


-----
## Gallery
### Splash Screen
https://github.com/Diegogtz03/kofy-app/assets/65473367/edff1615-62dc-45f2-b952-21d328c3f442

### Registration
https://github.com/Diegogtz03/kofy-app/assets/65473367/4431e081-a13e-426e-b8ba-585852a2cc48

### New Session
https://github.com/Diegogtz03/kofy-app/assets/65473367/451511ac-9477-4bc3-a035-b4da39e7ab2d

### Speech Session
https://github.com/Diegogtz03/kofy-app/assets/65473367/78196c95-5078-43c5-ac49-94855e660fe9

### History Tab
https://github.com/Diegogtz03/kofy-app/assets/65473367/a9958461-9ca7-434e-a673-8515b3cdaf3e

### Learning Tab
https://github.com/Diegogtz03/kofy-app/assets/65473367/f422abea-0d8d-4c1e-948a-a7a488f2efae


---------
---------

**Instrucciones para la instalación de la app “KOFY”**

Para tener una visualización del proyecto Kofy conformado por los siguientes puntos se deberán seguir las siguientes instrucciones:
API:
Se debe tener la base de datos en el dispositivo en donde se va a correr la API
La API debe estar en funcionamiento
En el archivo env se debe de cambiar la información de los datos específicos de la base de datos con la propia en donde se tiene la base de datos local.

*En el compilador*:
Se debe descargar node.js
El usuario en la terminal debe insertar npm install
Después ejecutar en la terminal node app.js 

*Base de datos*:
Se descarga el archivo con la base de datos
Se abre la aplicación en donde se va a tener la base de datos
Se corre el archivo para poder generar la base de datos

*App*:
Se debe descargar la carpeta con todos los archivos de la app
En xcode, se selecciona la carpeta de la app y se abren los archivos
Al tener abierto el proyecto para probarlo selecciona build and run y se ejecutará en el simulador.

*Repositorios*:
Github Front-end: https://github.com/Diegogtz03/kofy-app 
Github Back-end: https://github.com/RoJosGaRis/Kofy-Back 
Jira: https://a01284731.atlassian.net/jira/software/projects/KS/boards/3/backlog 



Listo:
- Diseño estatico de login

> LOGIN
- Registro manual

> PERFIL
- Rescatar info de la app Salud
- Ingresar info de forma manual

> BOTON PLUS
- Abrir la ventana de nueva cita
- Extraer la fecha automaticamente
- Entrada de texto para descripcion
- Menu de doctores
- Agregar nuevo doctor
- Boton de sesion de escucha
- Boton de receta (tomar foto o subir foto)
- Boton de submit

> AGREGAR DOCTOR
- Inputs (nombre, especialidad, telefono y correo)


> SESION DE ESCUCHA
- Entrada de audio (permiso)
- Audio a texto
- Pausar reconocimiento para ingresar texto
- Texto a voz

> APRENDER
- Funcionamiento de equipo para medicamentos genericos
- Analisis de equipos por camara (genera nombre, descripcion y funcionamiento)


Por hacer:

> LOGIN
- Registro con AppleID

> MAIN PAGE
- Tarjetas de recordatorios
- Tarjetas automaticas de Kofy assistant

> PERFIL
- Modificar la info

> SESION DE ESCUCHA
- Reconocimiento de texto (preguntas, medicamentos, funcion)
- Modificar texto de la sesion de escucha

> RECETA
- Permisos de camara
- Permisos de fotos
- Reconocimiento de texto
- Analisis del texto (medicamentos, cantidad, funciones, intervalos)
- Modificar manual

> SUBMIT DE LA SESION
- Comparar texto de sesion de escucha y receta (generar recordatorios, recomendaciones)
- Modificar posibles errores de forma manual
- Agregar recordatorios
