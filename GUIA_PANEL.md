# Abrir el panel del Hospital Infantil Arcoíris

## 1. Reinicia el servidor

En la terminal donde está funcionando el servidor anterior, pulsa `Ctrl+C`.
Abre una terminal en la carpeta `Hospital_Arcoiris_Leucodata` y ejecuta:

```powershell
python sitio/servidor.py
```

Usa `servidor.py`: es el punto de entrada que incluye inicio de sesión y permisos.
`app.py` y `captura.py` por separado no incluyen esas protecciones.
Si Python indica que falta `openpyxl`, instala las dependencias con el mismo Python:

```powershell
python -m pip install -r sitio/requirements.txt
```

## 2. Inicia sesión

Abre http://127.0.0.1:8765/hospital/ e introduce tu usuario y contraseña actuales.
La cuenta debe tener estado `Activo`. No se han cambiado contraseñas ni registros.
Después de entrar, el panel mostrará:

**Bienvenido Angel Eduardo Marquez Martinez**

El nombre se obtiene de tu registro existente en `Empleados`, relacionado mediante
`empleado_id` con `Cuentas_Personal`. En tu Excel está en mayúsculas; la vista lo
presenta con mayúscula inicial. No está escrito como nombre fijo: otra cuenta verá
el nombre de su propio empleado, paciente o tutor.

## 3. Revisa las secciones

- **Inicio:** cifras reales del libro, accesos rápidos, puesto y área del usuario.
- **Usuarios:** cuentas del personal, pacientes y tutores; búsqueda y filtro por
  estado; botón Habilitar para cuentas pendientes; lista completa de empleados,
  incluso los que todavía no tienen cuenta, con sus áreas y funciones.
- **Pacientes:** todos los pacientes registrados, expediente y áreas vinculadas
  a citas e ingresos sin egreso. Las citas canceladas no se cuentan.
- **Áreas:** áreas existentes y número de empleados asignados.
- **Reportes:** resumen numérico y distribución del personal por área.
- **Configuración:** perfil, apariencia y ayuda.

Las listas generales, reportes, captura y habilitación requieren rol
`Administrador`. Los empleados ven su puesto y funciones. Los pacientes y tutores
ven únicamente los datos del paciente vinculado a su cuenta.

## 4. Agrega registros reales

1. En Inicio, pulsa **Agregar área** para abrir la captura en la tabla de áreas.
2. Para registrar una persona y generar sus credenciales, usa **Registrarme** en
   la pantalla de acceso. Selecciona personal o paciente/tutor.
3. Para empleados, registra el nombre, apellidos, área y puesto correctos. Las
   funciones se buscan por puesto en `sitio/panel_puestos.py`.
4. Entra como administrador, abre Usuarios y pulsa **Habilitar** en la cuenta nueva.
5. La persona ya puede iniciar sesión. El panel consulta el Excel al cargarlo.

Cierra el archivo Excel antes de guardar registros o habilitar cuentas, para
evitar que Windows bloquee su escritura. Las áreas de atención de pacientes se
obtienen de las tablas Citas e Ingresos/Camas; no se asignan áreas ficticias.

## Qué se corrigió

- `do_POST(self, hoja)` pasó a `do_POST(self)`, la firma requerida por HTTPServer.
- Se eliminó la clase vacía `nombre_bienvenida` y se consulta la identidad al
  cargar el panel. Una variable local del inicio de sesión no existe en la
  siguiente petición del navegador.
- Se reemplazó el HTML mal anidado: Configuración ya no está dentro del botón
  Cerrar sesión.
- La vista está separada en `sitio/panel.py`, `sitio/panel.css` y `sitio/panel.js`.
- Se mantienen las sesiones con vencimiento, contraseñas existentes y permisos.

## Alcance y comprobaciones

El diseño usa el degradado rosa/naranja, fondo rosa, navegación, tarjetas y tablas
de las referencias, con adaptación a pantallas pequeñas. No se verificó en el
navegador automatizado porque la herramienta de vista previa no respondió.

Seis pruebas automatizadas verifican el nombre y las secciones, escape de HTML,
datos propios de paciente/tutor, habilitación e inicio/cierre de sesión y permisos.
Usan un libro sintético y no escriben el Excel real.

Las funciones específicas de los puestos (recetas, resultados, nóminas, etc.)
son un catálogo marcado **Próximamente**. Aún falta implementar sus formularios,
operaciones y permisos específicos. Los reportes actuales son administrativos;
no incluyen reportes clínicos ni financieros.

El servidor continúa siendo local, en `127.0.0.1`; no se ha publicado en Internet.

## Códigos QR y registro de llegadas

- Abre **Códigos QR** en la cinta del panel. Administración ve los códigos de todas las cuentas; cada usuario ve el suyo y puede descargarlo.
- El QR del paciente contiene nombre, ID de cuenta, folio y fecha de nacimiento. En cuentas de tutor muestra los datos del paciente vinculado.
- El QR del empleado contiene un código de identificación para registrar su llegada. No contiene su contraseña ni concede acceso al sitio.
- En la computadora de recepción, inicia sesión como administrador, abre Códigos QR y coloca el cursor en «Código del empleado». Escanea con el lector conectado y pulsa Registrar llegada si el lector no envía Enter.
- También puedes pulsar «Escanear con cámara» y autorizar la cámara. Al detectar el QR de un empleado se registra la llegada.
- Se guarda la primera llegada del día con hora de Ciudad de México y la cuenta que realizó el registro. Los escaneos repetidos no cambian esa hora.
- En Excel, **QR_Usuarios** contiene las imágenes y **Asistencia** contiene el historial. Cierra Excel antes de registrar llegadas o crear cuentas.
- El celular puede leer los datos de pacientes y el código de empleados. Para registrar directamente desde su navegador hace falta que el sitio sea accesible desde el celular mediante HTTPS; la dirección actual 127.0.0.1 solo funciona en la computadora del servidor. Mientras tanto, se puede pegar el código leído por el celular en la computadora de registro.
- Si instalas el proyecto en otra computadora, instala las dependencias con `python -m pip install -r sitio/requirements.txt`.

## Fotos y asignaciones individuales

- Cada usuario puede entrar en Configuración > Foto de perfil, seleccionar JPG, PNG o WebP de hasta 5 MB y guardar. Se conserva por cuenta en sitio/datos_privados/fotos; debe incluirse esa carpeta en los respaldos. La foto se muestra en el encabezado y solo su titular puede modificarla.
- Administración puede abrir Asignaciones en la cinta para asignar tareas, pacientes por referencia, muestras, turnos u órdenes de trabajo. Cada empleado ve sus propias asignaciones y puede actualizar el estado; administración también puede cancelarlas.
- Las asignaciones se guardan en la hoja Asignaciones del Excel al crear la primera. Son seguimiento de responsabilidades; no sustituyen el expediente clínico ni habilitan funciones clínicas pendientes.
- Para delegar llegadas: en Asignaciones otorga el permiso a una cuenta de recepción y crea una asignación de tipo Empleado para asistencia indicando el ID público de 10 dígitos del empleado. Se necesitan ambos pasos. Retirar el permiso o cancelar la asignación impide nuevas llegadas para ese alcance. Los permisos se guardan en Permisos_Recepcion.
- Los IDs y matrículas ya se guardan como texto en Ids_Usuarios y Matriculas. No se renumeraron cuentas existentes ni se sustituyeron sus QR.

## Funciones operativas por puesto (23 de noviembre de 2026)

Las tarjetas de Inicio y la cinta Mis funciones abren formularios y consultas. Los permisos se comprueban también al guardar; cambiar una dirección del navegador no concede acceso.

### Atención y agenda
- Administración asigna pacientes por folio o identificador interno en Asignaciones. Los profesionales también pueden consultar pacientes vinculados a sus propias citas, atenciones e ingresos.
- El médico abre Expediente clínico > Atenciones y registra la consulta. Desde sus funciones puede registrar diagnósticos, alergias, recetas y solicitudes de estudios. Las recetas requieren rol Medico y puesto médico habilitado.
- Enfermería registra signos vitales, cuidados, aplicación documentada de medicamentos e ingresos. Las notas de cuidados son seguimiento documental; no sustituyen una receta.
- Agenda de citas permite registrar, reprogramar y cancelar con control de coincidencias de paciente, profesional y consultorio. La cancelación conserva el registro. Confirmar llegada guarda la marca de recepción por separado.
- Los ingresos no permiten ocupar dos veces una cama activa ni duplicar el ingreso activo del paciente.

### Laboratorio, documentos y farmacia
- Las muestras y pruebas se vinculan a estudios. Administración puede asignar al personal un paciente o una muestra por su código.
- El técnico captura resultados preliminares. El personal de laboratorio autorizado valida con su propia cuenta; la firma y la fecha las coloca el servidor.
- Publicación de resultados permite publicar al paciente un resultado validado. Los resultados preliminares no aparecen en esa pantalla del paciente. Una anulación retira el resultado de la consulta publicada.
- Digitalización y Subida de imágenes permiten adjuntar PDF (8 MB) o imágenes JPG, PNG y WebP (5 MB). Los archivos son privados. Una jefatura puede publicar un documento al paciente vinculado; no se publican al subirlos.
- Farmacia guarda movimientos por medicamento y lote, controla el saldo y rechaza salidas sin existencias. Almacén registra materiales por separado, con su propio saldo de entradas y salidas.

### Operación del hospital
- Mantenimiento, limpieza, seguridad, transporte, compras, recursos humanos, docencia, investigación, trabajo social y terapias tienen registros de seguimiento con campos propios, responsable y estado.
- Las aprobaciones corresponden a jefaturas; los registros finalizados se conservan y las correcciones se documentan en registros nuevos. Una nota bajo supervisión no puede aprobarla su propio autor.
- Estas pantallas registran el trabajo realizado por las personas: no calculan impuestos de nómina, no toman decisiones clínicas ni conectan equipos de laboratorio o cámaras externas.
- Notificaciones muestra las asignaciones y seguimientos dentro del sitio. No envía correo, SMS ni notificaciones fuera del navegador.
- Registro de salidas guarda la salida propia una vez por día, después de una llegada existente; conserva los QR y las llegadas anteriores.

### Excel y recuperación
- Los registros clínicos usan las tablas existentes. Operaciones_Web guarda los seguimientos operativos; Historial_Web conserva autor, fecha y cambios. Las hojas nuevas se crean al usarse por primera vez.
- Las modificaciones comprueban una versión del registro para evitar sobrescribir cambios de otra persona.
- Respaldos crea ZIP locales del Excel, fotos y documentos. Por defecto hay una copia antes del primer guardado de cada día mientras el servidor está en uso. Administración puede descargar copias, crear otra manualmente o desactivar esa copia diaria.
- Para recuperar una copia, detén el servidor, conserva una copia del estado actual y extrae el Excel en sitio y datos_privados en sitio/datos_privados. La restauración no se realiza automáticamente desde la web.
- Cierra el archivo Excel antes de guardar desde la web. Los IDs, matrículas y QR existentes conservan sus vínculos.
- El sitio sigue limitado a esta computadora. Las opciones de acceso móvil y CCTV muestran esa condición: no se habilitó una dirección pública ni se simularon cámaras.

### Verificación
Las pruebas automatizadas usan datos ficticios y comprueban formularios para todos los puestos, permisos, conflictos de agenda, existencias, validación/publicación, documentos privados, respaldos e integridad del Excel. La vista de desarrollo prueba_visual.py usa datos en memoria y el puerto 8766; el servidor de uso normal sigue en 8765.

## Correcciones de inventario, perfiles e iniciador

- Los almacenistas y la jefatura de almacén consultan el mismo inventario global de materiales, calculado con todos sus movimientos. Otros puestos no acceden a esos registros.
- El responsable de un ingreso puede actualizar su estado y registrar el egreso aunque la atención clínica esté cerrada. Debe indicar fecha de egreso; los cambios al paciente, cama o fecha original requieren administración.
- Recepción puede seleccionar los tutores existentes al registrar citas.
- Administración > Mis funciones > Corregir datos de usuarios permite corregir nombres y apellidos; en empleados, también puesto y área. Se valida la relación entre puesto y área. Las correcciones quedan en el historial y detectan cambios simultáneos.
- Los QR ya emitidos mantienen su contenido original. Corregir un nombre actualiza el perfil del sitio y del Excel, pero no reescribe los datos impresos en un QR existente.
- INICIAR_HOSPITAL.cmd reutiliza la instancia actual y, si detecta cambios de versión, la reinicia mediante un control privado guardado localmente. REINICIAR_HOSPITAL.cmd permite reiniciar expresamente, incluso si el servidor no tiene una ventana visible. El reinicio cierra las sesiones; vuelve a iniciar sesión después.
- Desde PowerShell, ejecuta .\INICIAR_HOSPITAL.cmd o .\REINICIAR_HOSPITAL.cmd estando en la carpeta del proyecto. Mantén abierta la ventana que inicia el nuevo servidor.
- Una desconexión del navegador se registra de forma breve, sin intentar enviar una segunda respuesta ni repetir el guardado. Si cerraste la página mientras guardaba, consulta el registro antes de volver a enviarlo.
## Citas de médicos y pacientes

- Agenda de citas permite al médico elegir pacientes activos registrados, aunque aún no tengan una asignación clínica previa. Cada médico gestiona su propia agenda.
- Mis citas permite al paciente solicitar una cita para su propia cuenta, seleccionando un médico activo, fecha, hora y motivo. La duración inicial es de 30 minutos y el estado es Pendiente.
- El médico confirma la solicitud desde Agenda de citas > Editar > Estado: Confirmada > Guardar. El paciente consulta el estado actualizado en Mis citas.
- No se permiten citas que coincidan con otra del paciente, profesional o consultorio, ni solicitudes para otro paciente. Las solicitudes del portal deben tener fecha futura.
