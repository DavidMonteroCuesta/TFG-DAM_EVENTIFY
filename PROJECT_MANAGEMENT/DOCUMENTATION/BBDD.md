<style>
    p {text-align:justify}
</style>

# Elección de base de datos para Eventify

## Objetivo

Para el desarrollo de **Eventify**, se necesita una base de datos que:

- Permita guardar **eventos personalizados** (fecha, título, descripción, etc.).
- Sea accesible **desde varios dispositivos**.
- Soporte **usuarios distintos** y gestión de sus eventos.
- Sincronice cambios **en tiempo real** o al menos de forma eficiente.
- Tenga una opción **gratuita** suficiente para el uso inicial de la app.

Por ello, se ha decidido utilizar una **base de datos en la nube**, ya que así los datos se almacenan online y **no se pierden aunque el usuario cambie de dispositivo** o reinstale la app.

---

## Comparativa de bases de datos en la nube gratuitas

| Base de Datos             | Tipo            | Plan gratuito                    | Pros                                                                 | Contras                                                            |
|---------------------------|------------------|--------------------------------------|----------------------------------------------------------------------|---------------------------------------------------------------------|
| **Firebase Firestore**    | NoSQL            | 50K lecturas / día<br>20K escrituras / día<br>1 GB de almacenamiento | - Tiempo real <br> - Filtros y orden por campos <br> - Excelente soporte en Flutter | - Puede escalar rápido si se sobrepasan los límites <br> - Estructura por documentos |
| **Firebase Realtime DB**  | NoSQL (JSON)     | 1 GB almacenamiento <br> 100K conexiones simultáneas | - Sincronización ultra rápida <br> - Muy fácil de usar | - Menos flexible para estructuras complejas <br> - Consultas limitadas |
| **Supabase**              | SQL (PostgreSQL) | 500 MB base de datos <br> 2 GB almacenamiento <br> 10K usuarios autenticados | - Consultas SQL reales <br> - Código abierto <br> - Autenticación integrada | - En desarrollo <br> - Menor comunidad que Firebase |

---

## Decisión: Firebase Firestore

Se ha decidido usar **Firebase Firestore** como base de datos para Eventify por las siguientes razones:

- Su **plan gratuito es suficiente** para empezar, con 50.000 lecturas y 20.000 escrituras al día.
- Permite **almacenar los eventos por usuario y ordenarlos por fecha** fácilmente.
- Soporta autenticación, por lo que cada usuario tendrá su propia agenda.
- Se sincroniza en **tiempo real** entre dispositivos.
- Está **muy bien integrada con Flutter** y tiene documentación abundante.

### Estructura propuesta en Firestore

```
/usuarios/{id_usuario}/eventos/{id_evento}
- título: "Reunión"
- fecha: "2025-04-10"
- hora: "17:00"
- descripción: "Con el equipo de desarrollo"
```