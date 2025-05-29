```mermaid
graph TD
    subgraph Dispositivos del Usuario
        A[Dispositivo Móvil]
        B[Navegador Web]
        C[Aplicación de Escritorio]
    end

    subgraph Cliente
        D[Aplicación Flutter]
    end

    subgraph Servicios Backend
        E[Firebase Authentication]
        F[Firestore Database]
        G[Servicio de IA/LLM Gemini]
    end

    A --> D
    B --> D
    C --> D

    D -- HTTPS/API Calls --> E
    D -- HTTPS/API Calls --> F
    D -- HTTPS/API Calls --> G

    E -- User Data --> F
```


```
packageDiagram
    direction LR

    package l10n {
        class app_es_arb
        class app_en_arb
    }

    package common {
        // Vacío por ahora
    }

    package chat {
        // Vacío por ahora
    }

    package calendar {
        // Vacío por ahora
    }

    package auth {
        // Vacío por ahora
    }

    class Main {
        +runApp()
    }

    class FirebaseOptions {
        // Opciones de configuración de Firebase
    }

    %% Relaciones entre paquetes y clases

    Main --> l10n
    Main --> common
    Main --> calendar
    Main --> auth

    Main --> FirebaseOptions
```