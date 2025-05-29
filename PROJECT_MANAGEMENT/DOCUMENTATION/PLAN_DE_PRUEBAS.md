# Plan de pruebas de Eventify

El plan de pruebas de Eventify tiene como objetivo asegurar que todas las funcionalidades principales y secundarias se comportan correctamente, tanto desde el punto de vista técnico como de la experiencia de usuario. Para ello, se han definido diferentes tipos de pruebas que abarcan desde la verificación de los requisitos funcionales hasta la evaluación de aspectos no funcionales como el rendimiento, la seguridad y la accesibilidad.

En primer lugar, se realizarán pruebas funcionales para comprobar que los procesos clave, como el registro y autenticación de usuarios, la gestión de eventos, la mensajería en tiempo real y la personalización de la aplicación, funcionan según lo esperado. Estas pruebas incluirán la creación, edición y eliminación de eventos, la gestión de asistentes, la configuración de recordatorios y notificaciones, así como la interacción con el agente artificial para la gestión inteligente de eventos. También se verificará la correcta integración con servicios externos como Firebase y la sincronización de datos entre dispositivos.

Además, se llevarán a cabo pruebas de integración para garantizar que los distintos módulos de la aplicación colaboran de forma adecuada, especialmente en lo relativo a la comunicación con la base de datos, el almacenamiento de archivos y la gestión de notificaciones. Se comprobará que los datos fluyen correctamente entre las diferentes capas y que no existen pérdidas ni inconsistencias.

Las pruebas de usabilidad y accesibilidad serán fundamentales para asegurar que la aplicación es fácil de usar para cualquier persona, independientemente de su edad o experiencia tecnológica. Se evaluará la claridad de la interfaz, la facilidad de navegación, la comprensión de los mensajes y la adaptación a diferentes dispositivos y tamaños de pantalla. También se comprobará la compatibilidad con lectores de pantalla y otras ayudas técnicas.

Por último, se realizarán pruebas no funcionales para medir el rendimiento de la aplicación, el tiempo de respuesta ante las acciones del usuario, el consumo de recursos y la robustez ante posibles fallos o desconexiones. Se pondrá especial atención en la seguridad de los datos personales y en la protección de la privacidad del usuario.

El éxito del plan de pruebas se medirá en función de que todas las funcionalidades principales estén libres de errores críticos, la experiencia de usuario sea satisfactoria y la aplicación mantenga un rendimiento y una seguridad adecuados en todos los dispositivos y plataformas soportadas.

---

## Ejemplos de casos de prueba

- **Creación de evento:** El usuario accede al formulario de nuevo evento, introduce los datos requeridos y guarda. Se comprueba que el evento aparece correctamente en el calendario y en la base de datos.

- **Edición de evento:** El usuario selecciona un evento existente, modifica algún campo (por ejemplo, la fecha o el título) y guarda los cambios. Se verifica que la información se actualiza en todas las vistas y en la base de datos.

- **Eliminación de evento:** El usuario elimina un evento y se comprueba que desaparece del calendario y de la base de datos, y que los asistentes reciben la notificación correspondiente.

- **Personalización de tema:** El usuario accede a la configuración, cambia el color principal de la app y verifica que el cambio se aplica instantáneamente en toda la interfaz.

- **Recepción de notificaciones:** Se configura un recordatorio para un evento y se comprueba que la notificación llega antes de la fecha y hora del evento, según la antelación establecida.

- **Accesibilidad:** Se navega por la app utilizando un lector de pantalla y se comprueba que todos los elementos son accesibles y comprensibles.

- **Interacción con el agente artificial:** El usuario solicita mediante lenguaje natural la creación de un evento. Se verifica que el agente interpreta correctamente la orden y realiza la acción solicitada.

- **Pruebas multiplataforma:** Se instala y utiliza la app en Android, iOS y escritorio, comprobando que la experiencia es consistente y que no hay errores visuales ni funcionales.


