## Primeros pasos

Después de clonar el repositorio, debes preparar tu entorno y generar los archivos de localización. Puedes hacerlo ejecutando el siguiente script desde la raíz del proyecto:

```bash
./tools/flutter_refresh.sh
```

Alternativamente, puedes ejecutar estos comandos manualmente:

```bash
flutter clean
flutter pub get
flutter gen-l10n
flutter pub get
```