class Participante {
  final int? id;
  final String nombreCompleto;
  final String correo;
  final String institucion;
  final String identificador; // QR o matrícula

  Participante({
    this.id,
    required this.nombreCompleto,
    required this.correo,
    required this.institucion,
    required this.identificador,
  });

  // Convierte un Objeto a un Map para insertarlo en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre_completo': nombreCompleto,
      'correo': correo,
      'institucion': institucion,
      'identificador': identificador,
    };
  }

  // Convierte un Map de SQLite a un Objeto Dart para el frontend
  factory Participante.fromMap(Map<String, dynamic> map) {
    return Participante(
      id: map['id'],
      nombreCompleto: map['nombre_completo'],
      correo: map['correo'],
      institucion: map['institucion'],
      identificador: map['identificador'],
    );
  }
}