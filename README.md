# Préstamos de Libros

App móvil en Flutter + Cloud Firestore para controlar préstamos de libros.

## Requisitos
- Flutter SDK, Android Studio / VS Code
- Cuenta de Firebase, Firebase CLI y FlutterFire CLI

## Configuración
1. `flutter pub get`
2. `firebase login`
3. `flutterfire configure` (genera `lib/firebase_options.dart`, ignorado por git)
4. Firebase Console: activar Firestore y Authentication > Anónimo
5. Publicar reglas: `firebase deploy --only firestore:rules`

## Compilación
- APK: `flutter build apk --release` → `build/app/outputs/flutter-apk/app-release.apk`
- Web: `flutter build web` → `firebase deploy --only hosting`

## Distribución
- Instalar el APK en el teléfono (permitir orígenes desconocidos).
- URL pública: Firebase Hosting.

## Seguridad
Credenciales (`google-services.json`, `firebase_options.dart`, keystore) excluidas del repo; reglas de Firestore requieren autenticación y validan campos.
