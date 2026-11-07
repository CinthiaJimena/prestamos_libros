# Préstamos de Libros

Aplicación Flutter para registrar préstamos, consultar su estado y marcar la
devolución. Usa Firebase Authentication anónima y Cloud Firestore.

## Requisitos

- Flutter SDK estable y Dart incluidos en el SDK.
- Para Android: Android Studio, Android SDK y las licencias aceptadas con
  `flutter doctor --android-licenses`.
- Para Firebase: una cuenta de Google, Firebase CLI y FlutterFire CLI.

Comprueba la instalación con `flutter doctor`.

## Preparar Firebase

1. Crea un proyecto en [Firebase Console](https://console.firebase.google.com/).
2. En la consola, crea la base de datos de Cloud Firestore y activa el método
   **Anónimo** en Authentication > Sign-in method.
3. Inicia sesión en la terminal:

   ```powershell
   firebase login
   ```

4. El archivo `google-services.json` configura Android con el identificador de
   aplicación `prestamos.libros`. Para regenerar la configuración Android:

   ```powershell
   flutterfire configure --project=bd-proyecto-5ec91 --platforms=android
   ```

   La configuración Android actual está en `lib/firebase_options.dart` y
   `android/app/google-services.json`; ambos archivos están excluidos de Git.
5. Descarga las dependencias:

   ```powershell
   flutter pub get
   ```

Para habilitar iOS o web, registra esas aplicaciones en Firebase y ejecuta
`flutterfire configure --project=bd-proyecto-5ec91
--platforms=android,ios,web`. La configuración actual solo incluye Android.

## Ejecutar y probar

```powershell
flutter run -d chrome
flutter test
flutter analyze
```

Para ejecutar en un dispositivo Android conectado, usa `flutter devices` para
identificarlo y luego `flutter run -d ID_DEL_DISPOSITIVO`.

## Reglas y publicación

Las reglas de Firestore están en `firestore.rules`. Publícalas usando el ID de
tu proyecto:

```powershell
firebase deploy --only firestore:rules --project TU_PROJECT_ID
```

Genera un APK de Android:

```powershell
flutter build apk --release
```

El APK se genera en `build/app/outputs/flutter-apk/app-release.apk`.

Para publicar la versión web:

```powershell
flutter build web
firebase deploy --only hosting --project TU_PROJECT_ID
```

La configuración de Hosting y las reglas de Firestore se definen en
`firebase.json`.

## Seguridad

La configuración de Firebase y las claves de firma no deben guardarse en Git.
Las reglas de Firestore exigen autenticación y validan los campos requeridos.
