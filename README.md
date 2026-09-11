#  Congreso Educativo — Control de Asistencia

Aplicación móvil desarrollada en Flutter para la gestión de participantes, sesiones y control de asistencia de un congreso educativo.

El sistema permite administrar la información de los participantes, registrar las sesiones del congreso, consultar las asistencias y generar reportes de asistencia.

---

##  Descripción del proyecto

El proyecto consiste en el desarrollo de una aplicación móvil para facilitar el control de asistencia durante un congreso educativo.

La aplicación está orientada principalmente al personal administrador del evento y contempla las siguientes funcionalidades:

* Registro de participantes.
* Consulta y búsqueda de participantes.
* Edición y eliminación de participantes.
* Registro de sesiones del congreso.
* Consulta, edición y eliminación de sesiones.
* Registro de asistencia.
* Consulta de registros de asistencia.
* Generación de reportes.
* Validación de información ingresada.
* Interfaz gráfica adaptable y de fácil utilización.

---

##  Objetivo

Desarrollar una aplicación móvil que permita llevar un control organizado de los participantes y su asistencia a las diferentes sesiones de un congreso educativo, reduciendo el uso de registros manuales y facilitando la consulta de información.

---

##  Tecnologías utilizadas

El proyecto fue desarrollado utilizando:

* **Flutter**
* **Dart**
* **Material Design**
* **SQLite** para almacenamiento persistente
* **Android Studio / IntelliJ IDEA / Visual Studio Code** como entorno de desarrollo
* **Git y GitHub** para control de versiones

> Las versiones exactas de Flutter, Dart y las dependencias utilizadas se encuentran especificadas en los archivos `pubspec.yaml` y `pubspec.lock`.

---

##  Estructura del proyecto

```text
congreso_asistencia/
│
├── android/                 # Configuración de Android
├── ios/                     # Configuración de iOS
│
├── assets/
│   └── images/              # Recursos gráficos
│
├── lib/
│   ├── app/
│   │   └── theme/           # Tema visual de la aplicación
│   │
│   ├── core/
│   │   ├── constants/       # Constantes generales
│   │   └── widgets/         # Componentes reutilizables
│   │
│   └── features/
│       ├── onboarding/      # Pantalla inicial
│       ├── auth/            # Autenticación
│       └── admin/           # Módulo administrativo
│
├── test/                    # Pruebas
├── pubspec.yaml             # Dependencias del proyecto
├── pubspec.lock             # Versiones instaladas
├── .gitignore
└── README.md
```

---

##  Módulos principales

### Administrador

El administrador cuenta con un panel principal desde donde puede acceder a las diferentes funciones del sistema.

### Participantes

Permite:

* Registrar participantes.
* Consultar participantes.
* Buscar participantes.
* Editar información.
* Eliminar participantes.

Los datos registrados incluyen:

* Nombre completo.
* Correo electrónico.
* Institución.
* Identificador del participante.

### Sesiones

Permite administrar las sesiones del congreso.

Cada sesión contiene:

* Nombre de la sesión.
* Fecha.
* Hora.
* Lugar o sala.

### Asistencia

El sistema permite registrar y consultar la asistencia de los participantes a las diferentes sesiones.

Los registros contienen:

* Participante.
* Sesión.
* Fecha.
* Hora.
* Estado de asistencia.

### Reportes

El sistema permite consultar la información de asistencia mediante un reporte que contiene:

| Campo        | Descripción               |
| ------------ | ------------------------- |
| Participante | Nombre completo           |
| Sesión       | Sesión a la que pertenece |
| Fecha        | Fecha del registro        |
| Hora         | Hora de entrada           |
| Estado       | Estado de asistencia      |

---

##  Interfaz de usuario

La aplicación utiliza una interfaz limpia y profesional basada principalmente en una combinación de colores azul y blanco.

El diseño contempla:

* Navegación sencilla.
* Botones claramente identificables.
* Formularios con validaciones.
* Mensajes de confirmación.
* Mensajes de error.
* Tarjetas informativas.
* Panel administrativo.
* Navegación entre módulos.

---

##  Validaciones y seguridad

La aplicación implementa validaciones para evitar el registro de información incorrecta.

Entre las validaciones consideradas se encuentran:

* Campos obligatorios.
* Validación de correo electrónico.
* Validación de nombres.
* Validación del identificador del participante.
* Validación de contraseñas.
* Confirmación de acciones de eliminación.

Las credenciales y datos sensibles no deben almacenarse directamente dentro del código fuente.

---

#  Instalación

## Requisitos previos

Antes de ejecutar el proyecto es necesario contar con:

* Flutter instalado.
* Dart incluido con Flutter.
* Android Studio o un IDE compatible.
* Android SDK.
* Un dispositivo Android físico o un emulador.
* Git.

Para verificar la instalación de Flutter:

```bash
flutter --version
```

También se puede comprobar el entorno mediante:

```bash
flutter doctor
```

---

##  Clonar el repositorio

Clonar el repositorio utilizando:

```bash
git clone <URL_DEL_REPOSITORIO>
```

Entrar al directorio:

```bash
cd congreso_asistencia
```

---

##  Instalar dependencias

Ejecutar:

```bash
flutter pub get
```

---

##  Ejecutar la aplicación

Con un dispositivo o emulador conectado:

```bash
flutter devices
```

Posteriormente:

```bash
flutter run
```

---

##  Generar APK

Para generar una versión instalable para Android:

```bash
flutter build apk --release
```

El APK generado se encontrará en:

```text
build/app/outputs/flutter-apk/release/
```

---

##  Pruebas

Para ejecutar las pruebas del proyecto:

```bash
flutter test
```

---

##  Control de versiones

El proyecto utiliza Git para el control de versiones.

Ejemplo de flujo utilizado:

```bash
git add .
git commit -m "feat: agregar modulo de participantes"
git push origin main
```

---

##  Estado del proyecto

**En desarrollo.**

Actualmente se encuentran implementados los módulos principales de la interfaz administrativa y la navegación entre las diferentes secciones.

Las funcionalidades que dependen de almacenamiento persistente, registro real de asistencia y exportación de reportes se integrarán progresivamente.

---

##  Autor

**Christian Domingo Flores**

Proyecto académico — Aplicación móvil para el control de asistencia de un congreso educativo.
