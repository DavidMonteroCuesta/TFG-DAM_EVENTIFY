<style>
    p {text-align:justify}
</style>

# Funcionalidades de los Calendarios en iOS y Android  

Los calendarios de **iOS (Apple Calendar)** y **Android (Google Calendar)** ofrecen una variedad de funcionalidades diseñadas para la gestión de eventos, recordatorios y planificación.  

---

## Funcionalidades del Calendario en iOS (Apple Calendar)  

### Gestión de eventos y recordatorios  
- Creación, edición y eliminación de eventos.  
- Posibilidad de establecer eventos repetitivos (diarios, semanales, mensuales, anuales o personalizados).  
- Agregar una ubicación al evento con integración de **Apple Maps**.  
- Añadir notas y descripciones dentro del evento.  
- Adjuntar archivos y enlaces a eventos.  

### Notificaciones y alertas  
- Recordatorios antes del evento con opciones personalizadas (minutos, horas o días antes).  
- Alertas basadas en ubicación (por ejemplo, recibir un aviso al llegar a un lugar).  
- Integración con Siri para establecer recordatorios con comandos de voz.  

### Sincronización y compatibilidad  
- Sincronización con **iCloud**, lo que permite acceder a eventos desde todos los dispositivos Apple.  
- Compatibilidad con calendarios de terceros: **Google Calendar, Microsoft Outlook, Exchange, Yahoo Calendar, CalDAV**.  
- Integración con aplicaciones de terceros para importar eventos.  

### Vista y organización  
- Diferentes modos de vista: **día, semana, mes y año**.  
- Posibilidad de crear **varios calendarios** y asignarles colores diferentes para diferenciarlos.  
- Opción de compartir calendarios con otros usuarios de iCloud.  

### Otras características  
- Modo oscuro compatible con iOS.  
- Posibilidad de agregar eventos a través de **Siri**.  
- Integración con Apple Watch para ver eventos en la muñeca.  
- Posibilidad de responder a invitaciones de eventos desde la app.  

---

## Funcionalidades del Calendario en Android (Google Calendar)  

### Gestión de eventos y tareas  
- Creación y edición de eventos con opciones de personalización.  
- Eventos recurrentes con patrones flexibles de repetición.  
- Posibilidad de adjuntar archivos desde **Google Drive**.  
- Agregar descripciones y enlaces dentro del evento.  
- Creación de **tareas** (integrado con Google Tasks).  

### Notificaciones y alertas  
- Recordatorios programables con distintas opciones de tiempo.  
- Notificaciones basadas en ubicación.  
- Posibilidad de recibir notificaciones por **correo electrónico**.  

### Sincronización y compatibilidad  
- Sincronización con **Google Drive, Gmail y Google Tasks**.  
- Compatibilidad con calendarios de **Microsoft Outlook, Exchange, iCloud, CalDAV**.  
- Integración con asistentes de voz como **Google Assistant** para programar eventos por voz.  

### Vista y organización  
- Diferentes modos de vista: **día, semana, mes y agenda**.  
- Uso de **colores personalizables** para organizar eventos por categoría.  
- Posibilidad de superponer varios calendarios.  
- Sincronización con eventos de Gmail (reservas de vuelos, reuniones, envíos, etc.).  

### Otras características  
- **Modos de sugerencias automáticas**, que completan eventos basados en patrones previos.  
- Posibilidad de **crear reuniones con enlaces directos de Google Meet**.  
- Creación de encuestas de disponibilidad con **Google Workspace**.  
- Accesibilidad desde la web en cualquier dispositivo.  
- Integración con **Wear OS** para ver eventos desde un smartwatch.  

---

# Comparación: Apple Calendar vs. Google Calendar vs. Eventify

| Funcionalidad            | Apple Calendar (iOS)  | Google Calendar (Android) | Eventify (Aplicación propia) |
|-------------------------|----------------------|-------------------------|-------------------------------|
| **Interactividad y facilidad de uso** | ✅ Interfaz limpia y sencilla | ✅ Intuitivo y bien integrado con Google | ✅ Totalmente personalizable según las necesidades del usuario |
| **Personalización de colores** | ❌ Solo modo claro/oscuro | ⚠️ Temas limitados (modo claro/oscuro) | ✅ Opción para elegir cualquier color de la interfaz |
| **Gestión de eventos** | ✅ Añadir, modificar y eliminar | ✅ Añadir, modificar y eliminar | ✅ Con funciones avanzadas y filtros personalizados |
| **Búsqueda avanzada** | ❌ Búsqueda básica | ⚠️ Búsqueda limitada a títulos y descripciones | ✅ Filtrado por palabras clave, prioridad, tipo, ubicación, etc. |
| **Persistencia de datos** | ☁️ iCloud (requiere internet) | ☁️ Google Drive (requiere internet) | ☁️ Almacenamiento en la nube, sin necesidad de base de datos local |
| **Notificaciones** | ✅ Alertas estándar | ✅ Alertas configurables | ✅ Configuración personalizada para eventos críticos |
| **Modo offline** | ❌ No disponible sin internet | ❌ No disponible sin internet | ✅ Funciona sin conexión (aunque sin persistencia local, las funciones offline son limitadas) |
| **Compatibilidad** | ❌ Solo en dispositivos Apple | ❌ Solo en dispositivos con Google | ✅ Soporte para Android, iOS, escritorio y más plataformas gracias a Flutter |
| **Escalabilidad** | ❌ Limitado a funciones predeterminadas | ⚠️ Google puede actualizar pero con restricciones | ✅ Capacidad de agregar nuevas funciones en el futuro |
| **Seguridad** | ✅ Datos encriptados en iCloud | ✅ Protección con Google Account | ✅ Seguridad garantizada mediante autenticación y almacenamiento en la nube |
| **Rendimiento** | ✅ Optimizado para Apple | ✅ Integrado con Google, pero puede tener lag en algunos dispositivos | ✅ Fluido y optimizado para dispositivos Android, iOS y escritorio (gracias a Flutter) |
| **Integración con otros servicios** | ✅ Apple Maps, Siri, Apple Watch | ✅ Google Maps, Google Meet, Gmail | ❌ No requiere integración con servicios externos, pero puede agregarse en el futuro |

---

## Análisis Comparativo

### Ventajas de la aplicación frente a Apple Calendar y Google Calendar  
1. **Mayor personalización**: Apple Calendar y Google Calendar no permiten cambios en los colores de la interfaz, mientras que la aplicación de agenda ofrece esta opción de personalización.  
2. **Búsqueda avanzada**: La aplicación permite filtrar eventos por múltiples criterios como palabras clave, prioridad, tipo, ubicación, etc., a diferencia de Apple y Google Calendar, que tienen opciones más limitadas.  
3. **Escalabilidad**: La aplicación tiene la capacidad de agregar nuevas funciones en el futuro, permitiendo una mayor personalización y expansión de sus características.  

---

## Conclusión

La aplicación de agenda, desarrollada con **Flutter**, ofrece una solución flexible y altamente personalizable, con ventajas como la **personalización de colores** y la **búsqueda avanzada**. Sin embargo, debido a la decisión de no utilizar una base de datos local, la persistencia de datos estará a cargo del almacenamiento en la nube, lo que puede ser una limitación si el usuario no dispone de conexión a internet. A pesar de ello, la aplicación sigue siendo una opción viable y atractiva para aquellos que busquen una experiencia de usuario adaptada a sus necesidades, con la posibilidad de agregar nuevas funcionalidades en el futuro.