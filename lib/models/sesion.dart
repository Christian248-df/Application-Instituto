class Sesion {
  final int? id;
  final int idClase;
  final String fecha;
  final String hora;
  final String lugar;

  Sesion({
    this.id,
    required this.idClase,
    required this.fecha,
    required this.hora,
    required this.lugar,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_clase': idClase,
      'fecha': fecha,
      'hora': hora,
      'lugar': lugar,
    };
  }

  factory Sesion.fromMap(Map<String, dynamic> map) {
    return Sesion(
      id: map['id'],
      idClase: map['id_clase'],
      fecha: map['fecha'],
      hora: map['hora'],
      lugar: map['lugar'],
    );
  }
}