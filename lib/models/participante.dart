class Participante {
  final int? id;
  final String nombreCompleto;
  final String correo;
  final String institucion;
  final String identificador;
  final String passwordHash;

  Participante({
    this.id,
    required this.nombreCompleto,
    required this.correo,
    required this.institucion,
    required this.identificador,
    required this.passwordHash,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre_completo': nombreCompleto,
      'correo': correo,
      'institucion': institucion,
      'identificador': identificador,
      'password_hash': passwordHash, // Se guarda en SQLite
    };
  }

  factory Participante.fromMap(Map<String, dynamic> map) {
    return Participante(
      id: map['id'],
      nombreCompleto: map['nombre_completo'],
      correo: map['correo'],
      institucion: map['institucion'],
      identificador: map['identificador'],
      passwordHash: map['password_hash'],
    );
  }
}
