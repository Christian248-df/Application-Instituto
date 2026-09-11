class Usuario {
  final int? id;
  final String username;
  final String passwordHash;
  final String rol;

  Usuario({
    this.id,
    required this.username,
    required this.passwordHash,
    required this.rol,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password_hash': passwordHash,
      'rol': rol,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      username: map['username'],
      passwordHash: map['password_hash'],
      rol: map['rol'],
    );
  }
}