# Proyecto Kaleo Frontend — Manual de instalación y ejecución (web + móvil)

> **Objetivo:** Dejar listo el entorno de desarrollo para crear y ejecutar un **frontend en Flutter** que funcione en **Web, Android e iOS**, y proporcionar un **README** que el equipo pueda seguir sin experiencia previa.

---

## 1) Requisitos previos

### Sistemas Operativos

* **Windows 10/11** (64‑bit) con PowerShell 5.1+
* **macOS 12+** (recomendado para compilar iOS)


### Herramientas que instalaremos

* **Git** (control de versiones)
* **Flutter SDK** (framework)
* **Android Studio** (SDK + emuladores Android)
* **Xcode** (solo macOS, para iOS + simuladores)
* **Chrome** (para pruebas Web)
* **VS Code** (editor recomendado) + extensiones

> **Nota:** Para compilar aplicaciones iOS **es obligatorio** usar un Mac con Xcode. Para Android y Web puedes usar Windows/macOS/Linux.

---

## 2) Instalación paso a paso

### 2.1. Instalar Git

* **Windows:**

  1. Descarga e instala desde [https://git-scm.com/download/win](https://git-scm.com/download/win)
  2. Acepta opciones por defecto. Verifica con `git --version` en PowerShell.
* **macOS:** `brew install git` (si no tienes Homebrew: [https://brew.sh](https://brew.sh))


### 2.2. Instalar Flutter SDK

* Descarga Flutter estable: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
* Descomprime en una ruta corta (ej.: `C:\src\flutter` en Windows o `~/development/flutter` en macOS/Linux).
* Agrega **Flutter** al **PATH** del sistema:

  * **Windows (PowerShell, como admin):**

    ```powershell
    [Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\\src\\flutter\\bin", "Machine")
    ```
  * **macOS/Linux (bash/zsh):** agrega a `~/.zshrc` o `~/.bashrc`:

    ```bash
    export PATH="$PATH:$HOME/development/flutter/bin"
    ```
  * Reinicia la terminal y verifica: `flutter --version`

### 2.3. Android Studio + Android SDK

1. Instala **Android Studio**: [https://developer.android.com/studio](https://developer.android.com/studio)
2. Abre Android Studio → **More Actions > SDK Manager**:

   * **SDK Platforms:** marca la última versión estable de Android.
   * **SDK Tools:** marca *Android SDK Platform-Tools*, *Android SDK Build-Tools*, *Android Emulator*.
3. Acepta licencias desde terminal:

   ```bash
   flutter doctor --android-licenses
   ```
4. (Opcional) Crea un emulador: **Device Manager > Create Device** (ej. Pixel 6 → descarga imagen recomendada).

### 2.4. Xcode (solo macOS para iOS)

1. Instala **Xcode** desde la App Store.
2. Abre Xcode al menos una vez para finalizar componentes.
3. Instala **CocoaPods** (gestor de dependencias iOS):

   ```bash
   sudo gem install cocoapods
   ```

### 2.5. Chrome (para Web)

* Instala **Google Chrome** o **Chromium**. Flutter lo usará como dispositivo Web.

### 2.6. VS Code + extensiones

* Instala **VS Code**: [https://code.visualstudio.com](https://code.visualstudio.com)
* Extensiones recomendadas:

  * *Dart* (oficial)
  * *Flutter* (oficial)
  * *Error Lens* (opcional, resalta errores)

---


O seguir el manual de instalacion sencillo con visual studio code:
https://docs.flutter.dev/get-started/quick

## 3) Verificar instalación

Ejecuta:

```bash
flutter doctor -v
```

Asegúrate de ver todas las secciones con ✓. Si hay advertencias, lee y sigue las recomendaciones (instalar SDKs, aceptar licencias, etc.).

---

## 4) Crear el repositorio y el proyecto

### 4.1. Crear un nuevo repositorio (GitHub)

1. Entra a GitHub y crea un repo vacío (ej.: **flutter-frontend**).
2. Copia la URL `https://github.com/mi-org/flutter-frontend.git`.

### 4.2. Crear el proyecto Flutter (web + móvil)

En tu carpeta de trabajo:

```bash
# Clona o inicializa el repo vacío
git clone https://github.com/mi-org/flutter-frontend.git
cd flutter-frontend

# Crea un nuevo proyecto Flutter *dentro* del repo actual
flutter create . --org com.miempresa --project-name app_frontend --platforms=android,ios,web
```

Esto generará la estructura básica para Android, iOS y Web.

> Si prefieres crear primero el proyecto y luego conectar Git:
>
> ```bash
> flutter create app_frontend --org com.miempresa --platforms=android,ios,web
> cd app_frontend
> git init
> git remote add origin https://github.com/mi-org/flutter-frontend.git
> ```

### 4.3. Añadir archivos iniciales útiles

* **.gitignore** (Flutter ya lo genera.)
* **README.md** (este documento)
* **analysis_options.yaml** (convenciones de lint, opcional)

Confirma el primer commit y sube:

```bash
git add .
git commit -m "chore: bootstrap Flutter project (web + android + ios)"
git branch -M main
git push -u origin main
```

---

## 5) Estructura del proyecto (resumen)

```
flutter-frontend/
├─ android/        # Proyecto nativo Android (Gradle)
├─ ios/            # Proyecto nativo iOS (Xcode/CocoaPods)
├─ lib/            # Código Dart/Flutter (aquí desarrollamos)
│  └─ main.dart    # Punto de entrada
├─ web/            # Assets/config para Web
├─ test/           # Pruebas unitarias
├─ pubspec.yaml    # Dependencias y configuración del proyecto
└─ README.md       # Este manual
```

---

## 6) Manual de **instalación** de dependencias del proyecto

Cada vez que se clone el repo por primera vez:

```bash
flutter pub get
```

Esto descarga las dependencias declaradas en `pubspec.yaml`.

---

## 7) Manual de **ejecución básica**

### 7.1. Ejecutar en Web (Chrome)

```bash
flutter run -d chrome
```

* Abre [http://localhost:XXXXX](http://localhost:XXXXX) automáticamente.

### 7.2. Ejecutar en Android

1. Abre un emulador desde Android Studio **o** conecta un dispositivo físico con *Depuración USB* activada.
2. Verifica que Flutter lo detecte:

   ```bash
   flutter devices
   ```
3. Ejecuta:

   ```bash
   flutter run -d <id_del_dispositivo>
   ```

### 7.3. Ejecutar en iOS (solo macOS)

1. Inicia un **Simulator** (ej. iPhone 15) desde Xcode o `open -a Simulator`.
2. Verifica:

   ```bash
   flutter devices
   ```
3. Ejecuta:

   ```bash
   flutter run -d <id_del_simulador>
   ```

> Para publicar en App Store necesitarás una cuenta de desarrollador Apple y configurar *signing* en Xcode.

---

## 8) Pantalla de ejemplo (sencilla)

Reemplaza el contenido de `lib/main.dart` por el siguiente **hola mundo** extendido:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hola, Flutter (web + móvil)')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bienvenido 👋'),
            const SizedBox(height: 8),
            Text('Has pulsado: $counter', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => setState(() => counter++),
              child: const Text('Incrementar'),
            ),
          ],
        ),
      ),
    );
  }
}
```

Guarda el archivo y Flutter recargará la app (hot reload) mostrando un botón que incrementa el contador.

---

## 9) Comandos útiles

* **Listar dispositivos disponibles:** `flutter devices`
* **Hot reload:** al guardar (⌘S / Ctrl+S) con `flutter run` activo
* **Hot restart:** `r` en la terminal donde corre la app
* **Detener la app:** `q` en la terminal
* **Actualizar dependencias:** `flutter pub add <paquete>` o editar `pubspec.yaml` y `flutter pub get`

---

## 10) Build (generar artefactos)

* **Web (carpeta `build/web`)**

  ```bash
  flutter build web --release
  ```
* **Android APK (debug):**

  ```bash
  flutter build apk --debug
  ```
* **Android AppBundle (para Play Store):**

  ```bash
  flutter build appbundle --release
  ```
* **iOS (archivo para Xcode/Archive):**

  ```bash
  flutter build ios --release
  ```

  Luego abre `ios/Runner.xcworkspace` en Xcode para *Archive* y distribución.

---

## 11) Flujo de ramas (sugerido)

* **main**: rama estable (lo que está listo para release/demo)
* **develop**: rama de integración
* **feature/***: trabajo por funcionalidad

Convención de commits (sugerida): `feat:`, `fix:`, `chore:`, `docs:`, `refactor:`, `test:`

---

## 12) Resolución de problemas comunes

* **`flutter` no se reconoce:** revisa que `flutter/bin` esté en el `PATH` y abre una nueva terminal.
* **Licencias Android:** `flutter doctor --android-licenses` y acepta todas.
* **Emulador lento/no arranca:** habilita virtualización en BIOS, cierra otros hipervisores (Windows Hyper‑V vs Intel HAXM/WHPX), aumenta RAM/VM.
* **Errores iOS con CocoaPods:** dentro de `ios/` ejecuta `pod repo update && pod install`.
* **No detecta dispositivo:** `flutter devices`; en Android, activa *Depuración USB*; en iOS, abre el Simulator.
* **Fallo al compilar iOS por firma:** configura *Signing & Capabilities* en Xcode con un Team válido.

---

## 13) Próximos pasos (opcional)

* Añadir **linter** y reglas en `analysis_options.yaml`.
* Configurar **flavors** (dev/staging/prod) y variables.
* Integrar **CI/CD** (GitHub Actions) para *build* en Web/Android.
* Definir **navegación**, **temas** y arquitectura (ej. MVVM, Riverpod, Bloc).

---

## 14) Checklist rápida para nuevos integrantes

1. Instalar Git, Flutter, Android Studio, (Xcode si tienes Mac) y VS Code.
2. `git clone <repo>` y `cd` al proyecto.
3. `flutter pub get`
4. `flutter doctor -v` y resolver pendientes.
5. `flutter run -d chrome` (o un emulador) para ver la app de ejemplo.

> Con esto ya pueden ejecutar y modificar la app en **Web + Android + iOS** (si están en macOS).
