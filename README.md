# Congreso Educativo — Control de Asistencia

Aplicación móvil multiplataforma desarrollada en Flutter para la gestión integral de participantes, sesiones y control de asistencia de un congreso educativo.

## Descripción del proyecto y Enfoque Técnico

El proyecto consiste en una herramienta digital que sustituye los pases de lista manuales en eventos académicos. Durante su planeación, tomamos la decisión arquitectónica de priorizar un entorno Offline-First. Sabiendo que la conectividad a internet en congresos masivos suele ser inestable, toda la persistencia de datos se maneja de manera local mediante un motor de base de datos embebido, garantizando alta disponibilidad y rapidez.

Se aplicó una estricta separación de responsabilidades (Separation of Concerns):
* Frontend (Capa de Presentación): Interfaces dinámicas, navegación por roles y un sistema de alertas globales.
* Backend (Capa de Datos): Modelado relacional, constraints lógicos y seguridad criptográfica.

## Funcionalidades Principales y Roles

El sistema implementa un control de acceso basado en roles desde la pantalla de inicio de sesión, redirigiendo al usuario a interfaces específicas según sus credenciales:

### Módulo de Administrador
* Autenticación Segura: Acceso mediante usuario y contraseña protegida.
* Gestión de Participantes: Registro, consulta, edición y eliminación (CRUD) del catálogo de asistentes.
* Gestión de Sesiones: Programación de ponencias, horarios y asignación de salas.
* Registro de Asistencia Global: Permite al administrador escanear o ingresar manualmente las matrículas de los participantes en cualquier sesión.
* Generación de Reportes: Exportación de métricas de asistencia detalladas (Participante, Sesión, Fecha, Hora y Estado).

### Módulo de Participante (Alumno)
* Acceso Ágil (Token-based): Acceso al sistema validando únicamente el correo electrónico institucional y el identificador (matrícula) a modo de token rápido, agilizando la entrada al evento.
* Exploración de Agenda: Visualización del cronograma de talleres y conferencias.
* Auto-Registro de Asistencia: El alumno preselecciona la sesión a la que asiste y confirma su entrada con un solo toque, evitando que pueda registrar asistencia a nombre de otros.

## Seguridad y Persistencia (SQLite)

La arquitectura de datos fue construida para ser robusta e independiente de la nube:
1. Criptografía: Implementación de la librería crypto para el hashing de contraseñas (SHA-256). Ninguna credencial de administrador se almacena en texto plano.
2. Integridad Referencial: Uso de llaves foráneas (FOREIGN KEY) con reglas ON DELETE CASCADE para mantener la base de datos limpia si se elimina una sesión o participante.
3. Prevención de Duplicados: Restricciones lógicas a nivel de base de datos (UNIQUE(id_participante, id_sesion)) que bloquean automáticamente intentos de registro de asistencia doble en la misma sesión, respaldadas por un sistema visual de advertencias (AppAlert).

## Tecnologías utilizadas

* Framework: Flutter / Dart
* Base de Datos: sqflite (Motor SQLite nativo)
* Seguridad: crypto (Algoritmos de cifrado)
* Diseño: Material Design 3 con componentes y animaciones personalizadas.
* Entorno: Visual Studio Code / Android Studio.
* Control de Versiones: Git y GitHub.

Las versiones exactas de las dependencias se encuentran en el archivo pubspec.yaml.

## Estructura del proyecto

```text
congreso_asistencia/
│
├── assets/
│   └── images/              # Recursos gráficos y banners temáticos
│
├── lib/
│   ├── core/
│   │   ├── database/        # Backend: database_helper.dart (Lógica SQLite y CRUD)
│   │   └── widgets/         # Componentes UI reutilizables (AppAlert, AppTextField)
│   │
│   ├── features/
│   │   ├── auth/            # Interfaz y lógica de inicio de sesión/registro
│   │   ├── home/            # Vistas principales divididas por roles (Admin/Participante)
│   │   └── models/          # Modelado de datos (POO: Participante, Sesión, Usuario)
│   │
│   └── main.dart            # Punto de entrada y configuración de la app

```

## Instalación y Ejecución

Requisitos previos:

* Flutter y Dart instalados (ejecutar flutter doctor para verificar).
* Emulador Android/iOS o dispositivo físico conectado.

Pasos:

1. Clonar el repositorio: git clone <URL_DEL_REPOSITORIO>
2. Instalar dependencias: flutter pub get
3. Compilar y ejecutar: flutter run

Nota: Durante el primer inicio, el sistema inyecta automáticamente datos semilla (Seeder) que incluyen cuentas de prueba (Admin y Alumno) y el catálogo inicial de sesiones para facilitar su evaluación.

## Estado del proyecto

Finalizado.
Se han completado e integrado exitosamente todos los módulos requeridos, abarcando la persistencia de datos local, las interfaces gráficas responsivas, las validaciones de formularios y el control de roles. La aplicación se encuentra en fase lista para empaquetado (Release).

## Autor

Roberto Lagunas Cazales
Proyecto académico — Aplicación móvil para el control de asistencia de un congreso educativo.

```

```
