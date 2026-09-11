class Clase {
  final int? id;
  final String nombre;
  final String descripcion;

  Clase({
    this.id,
    required this.nombre,
    required this.descripcion,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
    };
  }

  factory Clase.fromMap(Map<String, dynamic> map) {
    return Clase(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
    );
  }
}