import 'package:flutter/material.dart';

import '../../../../core/database/database_helper.dart';

class HomePage extends StatefulWidget {
  // === AQUÍ ESTÁ LA SOLUCIÓN A LOS ERRORES ROJOS ===
  // Ya abrimos la puerta para recibir los datos desde el Login
  final String rol;
  final int? idParticipante;
  final String? nombreParticipante;
  final String? identificador;

  const HomePage({
    super.key,
    this.rol = 'admin', // Valor por defecto
    this.idParticipante,
    this.nombreParticipante,
    this.identificador,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indiceActual = 0;
  late Future<List<Map<String, dynamic>>> _sesiones;

  @override
  void initState() {
    super.initState();
    _cargarSesiones();
  }

  void _cargarSesiones() {
    setState(() {
      _sesiones = DatabaseHelper.instance.obtenerAgendaCompleta();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _indiceActual = index;
    });
    if (index == 1) {
      _mostrarMensaje('Navegando a Registro de Asistencia...');
    }
  }

  void _mostrarMensaje(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto), behavior: SnackBarBehavior.floating),
    );
  }

  // --- MAPEO DE IMÁGENES LOCALES ---
  String _obtenerImagenClase(String nombreClase) {
    final nombre = nombreClase.toLowerCase();
    if (nombre.contains('electrónica')) return 'assets/images/electronica.jpeg';
    if (nombre.contains('dibujo')) return 'assets/images/dibujo.jpeg';
    if (nombre.contains('fotografía') || nombre.contains('video'))
      return 'assets/images/fotografia.jpeg';
    if (nombre.contains('pintura')) return 'assets/images/pintura.jpeg';
    return 'assets/images/dibujo.jpeg'; // Imagen por defecto
  }

  // --- VISTA DETALLADA (MODAL) ---
  void _mostrarDetalleSesion(Map<String, dynamic> sesion) {
    final imagenFondo = _obtenerImagenClase(sesion['clase']);
    final descripcion = sesion['descripcion'] ?? 'Sin descripción disponible.';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: Image.asset(
                  imagenFondo,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sesion['clase'],
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        descripcion,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(),
                      ),
                      _filaDetalle(
                        Icons.calendar_month_rounded,
                        'Fecha programada',
                        sesion['fecha'],
                      ),
                      const SizedBox(height: 16),
                      _filaDetalle(
                        Icons.schedule_rounded,
                        'Horario de inicio',
                        sesion['hora'],
                      ),
                      const SizedBox(height: 16),
                      _filaDetalle(
                        Icons.location_on_rounded,
                        'Ubicación / Sala',
                        sesion['lugar'],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cerrar Detalles',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _filaDetalle(IconData icono, String titulo, String valor) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icono, color: Colors.blue.shade700, size: 22),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.rol == 'admin'
                  ? 'Panel de Control'
                  : 'Hola, ${widget.nombreParticipante?.split(" ")[0] ?? "Alumno"}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            // Si es un participante, mostramos su matrícula debajo de su nombre
            if (widget.rol == 'participante')
              Text(
                'Matrícula: ${widget.identificador}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        actions: [
          // Avatar de perfil en la esquina superior derecha
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: widget.rol == 'admin'
                  ? Colors.black87
                  : Colors.blue.shade100,
              child: Text(
                widget.rol == 'admin'
                    ? 'AD'
                    : (widget.nombreParticipante
                              ?.substring(0, 1)
                              .toUpperCase() ??
                          'U'),
                style: TextStyle(
                  color: widget.rol == 'admin'
                      ? Colors.white
                      : Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _indiceActual == 0
          ? _construirListaSesiones()
          : const Center(child: Text('Pantalla en construcción')),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          // Cambié withOpacity por withValues(alpha: X) para quitar los avisos azules de Christian
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _indiceActual,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue.shade700,
          unselectedItemColor: Colors.grey.shade400,
          backgroundColor: Colors.white,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_rounded),
              label: 'Sesiones',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner_rounded),
              label: 'Asistencia',
            ),
          ],
        ),
      ),
    );
  }

  // --- TARJETAS PREMIUM DE LA LISTA PRINCIPAL ---
  Widget _construirListaSesiones() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _sesiones,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay sesiones programadas.'));
        }

        final datos = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          itemCount: datos.length,
          itemBuilder: (context, index) {
            final sesion = datos[index];
            final imagenFondo = _obtenerImagenClase(sesion['clase']);

            return GestureDetector(
              onTap: () => _mostrarDetalleSesion(sesion),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(imagenFondo),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sesion['clase'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${sesion['fecha']} • ${sesion['hora']}',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white70,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            sesion['lugar'],
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
