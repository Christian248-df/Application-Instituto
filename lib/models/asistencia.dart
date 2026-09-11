class Asistencia {
  final int? id;
  final int idParticipante;
  final int idSesion;
  final String fecha;
  final String horaEntrada;
  final String estado;

  Asistencia({
    this.id,
    required this.idParticipante,
    required this.idSesion,
    required this.fecha,
    required this.horaEntrada,
    required this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'id_participante': idParticipante,
      'id_sesion': idSesion,
      'fecha': fecha,
      'hora_entrada': horaEntrada,
      'estado': estado,
    };
  }

  factory Asistencia.fromMap(Map<String, dynamic> map) {
    return Asistencia(
      id: map['id'],
      idParticipante: map['id_participante'],
      idSesion: map['id_sesion'],
      fecha: map['fecha'],
      horaEntrada: map['hora_entrada'],
      estado: map['estado'],
    );
  }
}