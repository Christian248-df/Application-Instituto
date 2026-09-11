import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';

// Importamos los modelos
import '../../models/usuario.dart';
import '../../models/participante.dart';
import '../../models/asistencia.dart';
import '../../models/sesion.dart';
import '../../models/clase.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('congreso_avanzado.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _onConfigure,
    );
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE usuarios (
        id $idType,
        username $textType UNIQUE,
        password_hash $textType,
        rol $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE participantes (
        id $idType,
        nombre_completo $textType,
        correo $textType,
        institucion $textType,
        identificador $textType UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE clases (
        id $idType,
        nombre $textType,
        descripcion TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE sesiones (
        id $idType,
        id_clase INTEGER NOT NULL,
        fecha $textType,
        hora $textType,
        lugar $textType,
        FOREIGN KEY (id_clase) REFERENCES clases (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE asistencias (
        id $idType,
        id_participante INTEGER NOT NULL,
        id_sesion INTEGER NOT NULL,
        fecha $textType,
        hora_entrada $textType,
        estado $textType,
        FOREIGN KEY (id_participante) REFERENCES participantes (id) ON DELETE CASCADE,
        FOREIGN KEY (id_sesion) REFERENCES sesiones (id) ON DELETE CASCADE,
        UNIQUE(id_participante, id_sesion)
      )
    ''');

    await db.insert('usuarios', {
      'username': 'admin',
      'password_hash':
          '8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',
      'rol': 'administrador',
    });
  }

  // ==========================================
  // SEGURIDAD Y CONTROL DE ACCESO
  // ==========================================

  String _generarHash(String password) {
    var bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  Future<Usuario?> login(String username, String passwordPlana) async {
    final db = await instance.database;
    final hash = _generarHash(passwordPlana);

    final res = await db.query(
      'usuarios',
      where: 'username = ? AND password_hash = ?',
      whereArgs: [username, hash],
    );

    if (res.isNotEmpty) {
      return Usuario.fromMap(res.first);
    }
    return null;
  }

  // ==========================================
  // MÓDULO DE PARTICIPANTES
  // ==========================================

  Future<int> registrarParticipante(Participante participante) async {
    final db = await instance.database;
    return await db.insert(
      'participantes',
      participante.toMap(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<List<Participante>> obtenerParticipantes() async {
    final db = await instance.database;
    final result = await db.query('participantes');
    return result.map((json) => Participante.fromMap(json)).toList();
  }

  // [PUT] Actualizar Participante
  Future<int> actualizarParticipante(Participante participante) async {
    final db = await instance.database;
    return await db.update(
      'participantes',
      participante.toMap(),
      where: 'id = ?',
      whereArgs: [participante.id],
    );
  }

  // [DELETE] Borrar Participante
  Future<int> eliminarParticipante(int id) async {
    final db = await instance.database;
    return await db.delete('participantes', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // MÓDULO DE SESIONES
  // ==========================================

  Future<List<Map<String, dynamic>>> obtenerSesionesConClase() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT s.id, c.nombre, s.fecha, s.hora, s.lugar 
      FROM sesiones s
      JOIN clases c ON s.id_clase = c.id
    ''');
  }

  Future<List<Map<String, dynamic>>> obtenerAgendaCompleta() async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT s.id as id_sesion, c.nombre as clase, s.fecha, s.hora, s.lugar
      FROM sesiones s
      JOIN clases c ON s.id_clase = c.id
      ORDER BY s.fecha ASC, s.hora ASC
    ''');
  }

  // [GET] Obtener Una Sesión
  Future<Sesion?> obtenerSesion(int id) async {
    final db = await instance.database;
    final res = await db.query('sesiones', where: 'id = ?', whereArgs: [id]);
    if (res.isNotEmpty) {
      return Sesion.fromMap(res.first);
    }
    return null;
  }

  // ==========================================
  // MÓDULO DE ASISTENCIA Y REPORTES
  // ==========================================

  Future<int> registrarAsistenciaQR(String identificador, int idSesion) async {
    final db = await instance.database;

    final participanteRes = await db.query(
      'participantes',
      where: 'identificador = ?',
      whereArgs: [identificador],
    );
    if (participanteRes.isEmpty) throw Exception('Participante no registrado');

    final idParticipante = participanteRes.first['id'] as int;
    final now = DateTime.now();

    final asistencia = Asistencia(
      idParticipante: idParticipante,
      idSesion: idSesion,
      fecha:
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      horaEntrada:
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
      estado: 'Presente',
    );

    return await db.insert('asistencias', asistencia.toMap());
  }

  Future<List<Map<String, dynamic>>> consultarAsistencia(int idSesion) async {
    final db = await instance.database;
    return await db.rawQuery(
      '''
      SELECT p.nombre_completo as Participante, c.nombre as Sesion, a.fecha as Fecha, a.hora_entrada as Hora, a.estado as Estado
      FROM asistencias a
      JOIN participantes p ON a.id_participante = p.id
      JOIN sesiones s ON a.id_sesion = s.id
      JOIN clases c ON s.id_clase = c.id
      WHERE a.id_sesion = ?
    ''',
      [idSesion],
    );
  }

  // ==========================================
  // "ENDPOINTS" DE CLASES (Catálogo General)
  // ==========================================

  // [POST] Crear
  Future<int> crearClase(Clase clase) async {
    final db = await instance.database;
    return await db.insert('clases', clase.toMap());
  }

  // [GET] Obtener Todas
  Future<List<Clase>> obtenerClases() async {
    final db = await instance.database;
    final result = await db.query('clases');
    return result.map((json) => Clase.fromMap(json)).toList();
  }

  // [GET] Obtener Una
  Future<Clase?> obtenerClase(int id) async {
    final db = await instance.database;
    final res = await db.query('clases', where: 'id = ?', whereArgs: [id]);
    if (res.isNotEmpty) {
      return Clase.fromMap(res.first);
    }
    return null;
  }

  // [PUT] Actualizar
  Future<int> actualizarClase(Clase clase) async {
    final db = await instance.database;
    return await db.update(
      'clases',
      clase.toMap(),
      where: 'id = ?',
      whereArgs: [clase.id],
    );
  }

  // [DELETE] Borrar
  Future<int> eliminarClase(int id) async {
    final db = await instance.database;
    return await db.delete('clases', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // "ENDPOINTS" DE SESIONES (Instancias)
  // ==========================================

  // [POST] Crear
  Future<int> crearSesion(Sesion sesion) async {
    final db = await instance.database;
    return await db.insert('sesiones', sesion.toMap());
  }

  // [PUT] Actualizar
  Future<int> actualizarSesion(Sesion sesion) async {
    final db = await instance.database;
    return await db.update(
      'sesiones',
      sesion.toMap(),
      where: 'id = ?',
      whereArgs: [sesion.id],
    );
  }

  // [DELETE] Borrar
  Future<int> eliminarSesion(int id) async {
    final db = await instance.database;
    return await db.delete('sesiones', where: 'id = ?', whereArgs: [id]);
  }

  // ==========================================
  // EXPORTACIÓN DE REPORTE (Requerimiento F)
  // ==========================================

  Future<String> generarReporteCSV(int idSesion) async {
    // 1. Obtener los datos usando la consulta que ya hicimos
    final asistencias = await consultarAsistencia(idSesion);

    if (asistencias.isEmpty) return "Sin datos";

    // 2. Construir el contenido del CSV con los campos requeridos
    String csvContent = "Participante,Sesion,Fecha,Hora,Estado\n";

    for (var fila in asistencias) {
      // Las comillas evitan que las comas en los nombres rompan el formato CSV
      csvContent +=
          '"${fila['Participante']}","${fila['Sesion']}","${fila['Fecha']}","${fila['Hora']}","${fila['Estado']}"\n';
    }

    // 3. Obtener el directorio de documentos del dispositivo móvil
    final directory = await getApplicationDocumentsDirectory();
    final path = join(
      directory.path,
      'reporte_asistencia_sesion_$idSesion.csv',
    );

    // 4. Escribir y guardar el archivo físicamente
    final file = File(path);
    await file.writeAsString(csvContent);

    // Devuelve la ruta absoluta para que el frontend (Christian) pueda mostrar
    // un mensaje de éxito como: "Guardado en: $ruta"
    return path;
  }

  // ==========================================
  // SEMILLA DE DATOS (Seeder)
  // ==========================================

  Future<void> inyectarDatosSemilla() async {
    final db = await instance.database;

    // 1. Verificar si ya existen clases para no duplicar datos
    final countRes = await db.rawQuery('SELECT COUNT(*) as conteo FROM clases');
    final int count = Sqflite.firstIntValue(countRes) ?? 0;

    if (count > 0) {
      // Ya hay datos en la base de datos, abortamos la inyección
      return;
    }

    // 2. Insertar Clases (Talleres Técnicos y Recreativos)
    int idElectronica = await db.insert('clases', {
      'nombre': 'Taller de Electrónica',
      'descripcion': 'Fundamentos de circuitos, soldadura de componentes y programación de placas de desarrollo.',
    });

    int idDibujo = await db.insert('clases', {
      'nombre': 'Dibujo Técnico',
      'descripcion': 'Creación de planos, esquemas estructurados y topologías.',
    });

    int idFotografia = await db.insert('clases', {
      'nombre': 'Taller de Fotografía y Video',
      'descripcion': 'Técnicas de captura, iluminación y procesamiento de video por comandos.',
    });

    int idPintura = await db.insert('clases', {
      'nombre': 'Pintura al Óleo',
      'descripcion':
          'Técnicas clásicas de pintura, teoría del color y texturas.',
    });

    // 3. Insertar Sesiones (La rúbrica exige mostrar al menos 3 sesiones)
    await db.insert('sesiones', {
      'id_clase': idElectronica,
      'fecha': '2026-09-15',
      'hora': '10:00',
      'lugar': 'Laboratorio de Hardware',
    });

    await db.insert('sesiones', {
      'id_clase': idFotografia,
      'fecha': '2026-09-15',
      'hora': '12:00',
      'lugar': 'Estudio Audiovisual',
    });

    await db.insert('sesiones', {
      'id_clase': idDibujo,
      'fecha': '2026-09-16',
      'hora': '11:00',
      'lugar': 'Sala de Diseño',
    });

    await db.insert('sesiones', {
      'id_clase': idPintura,
      'fecha': '2026-09-17',
      'hora': '16:00',
      'lugar': 'Taller de Artes Visuales',
    });
  }
}
