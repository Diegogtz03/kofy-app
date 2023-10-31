Instrucciones para la instalación de la app “KOFY”
Para tener una visualización del proyecto Kofy conformado por los siguientes puntos se deberán seguir las siguientes instrucciones:
API:
Se debe tener la base de datos en el dispositivo en donde se va a correr la API
La API debe estar en funcionamiento
En el archivo env se debe de cambiar la información de los datos específicos de la base de datos con la propia en donde se tiene la base de datos local.

En tu compilador:
Se debe descargar node.js
El usuario en la terminal debe insertar npm install
Después ejecutar en la terminal node app.js 

Base de datos:
Se descarga el archivo con la base de datos
Se abre la aplicación en donde se va a tener la base de datos
Se corre el archivo para poder generar la base de datos

App:
Se debe descargar la carpeta con todos los archivos de la app
En xcode, se selecciona la carpeta de la app y se abren los archivos
Al tener abierto el proyecto para probarlo selecciona build and run y se ejecutará en el simulador.

Repositorios:
Github Front-end: https://github.com/Diegogtz03/kofy-app 
Github Back-end: https://github.com/RoJosGaRis/Kofy-Back 
Jira: https://a01284731.atlassian.net/jira/software/projects/KS/boards/3/backlog 



Listo:
- Diseño estatico de login

Por hacer:

> LOGIN
- Registro con AppleID
- Registro manual

> MAIN PAGE
- Tarjetas de recordatorios
- Tarjetas automaticas de Kofy assistant

> PERFIL
- Rescatar info de la app Salud
- Ingresar info de forma manual
- Modificar la info

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
- Reconocimiento de texto (preguntas, medicamentos, funcion)
- Pausar reconocimiento para ingresar texto
- Texto a voz
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

> APRENDER
- Funcionamiento de equipo para medicamentos genericos
- Analisis de equipos por camara (genera nombre, descripcion y funcionamiento)
