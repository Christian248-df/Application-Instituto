import 'package:flutter/material.dart';

import '../../../../core/database/database_helper.dart';
import '../../../../core/widgets/app_alert.dart';

class HomePage extends StatefulWidget {
  final String rol;
  final int? idParticipante;
  final String? nombreParticipante;
  final String? identificador;

  const HomePage({
    super.key,
    this.rol = 'admin',
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
      _mostrarAlerta(
        'Navegación',
        'Estás en el módulo de Registro de Asistencia.',
        AppAlertType.info,
      );
    }
  }

  void _mostrarAlerta(String titulo, String mensaje, AppAlertType tipo) {
    AppAlert.show(context, title: titulo, message: mensaje, type: tipo);
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
      // --- CONEXIÓN DE LA VISTA DE ASISTENCIA ---
      body: _indiceActual == 0
          ? _construirListaSesiones()
          : _VistaAsistencia(
              rol: widget.rol,
              identificadorLogueado: widget.identificador,
            ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
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

// ======================================================================
// VISTA DE REGISTRO DE ASISTENCIA
// ======================================================================
class _VistaAsistencia extends StatefulWidget {
  final String rol;
  final String? identificadorLogueado;

  const _VistaAsistencia({required this.rol, this.identificadorLogueado});

  @override
  State<_VistaAsistencia> createState() => _VistaAsistenciaState();
}

class _VistaAsistenciaState extends State<_VistaAsistencia> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();

  List<Map<String, dynamic>> _sesionesDisponibles = [];
  int? _idSesionSeleccionada;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    if (widget.rol == 'participante' && widget.identificadorLogueado != null) {
      _idController.text = widget.identificadorLogueado!;
    }
    _cargarSesiones();
  }

  Future<void> _cargarSesiones() async {
    final data = await DatabaseHelper.instance.obtenerAgendaCompleta();
    setState(() {
      _sesionesDisponibles = data;
    });
  }

  // --- FUNCIÓN DE ALERTA PERSONALIZADA ---
  void _mostrarAlerta(String titulo, String mensaje, AppAlertType tipo) {
    AppAlert.show(context, title: titulo, message: mensaje, type: tipo);
  }

  Future<void> _registrarAsistencia() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idSesionSeleccionada == null) {
      _mostrarAlerta(
        'Atención',
        'Por favor, selecciona una sesión de la lista.',
        AppAlertType.warning,
      );
      return;
    }

    setState(() => _cargando = true);

    try {
      await DatabaseHelper.instance.registrarAsistenciaQR(
        _idController.text.trim(),
        _idSesionSeleccionada!,
      );

      if (!mounted) return;
      _mostrarAlerta(
        '¡Asistencia Confirmada!',
        'Se ha registrado tu asistencia correctamente.',
        AppAlertType.success,
      );

      if (widget.rol == 'admin') {
        _idController.clear();
      }
    } catch (e) {
      if (!mounted) return;
      String error = e.toString().toLowerCase();

      if (error.contains('unique constraint failed')) {
        _mostrarAlerta(
          'Registro Duplicado',
          'Esta matrícula ya tiene registrada su asistencia en esta sesión.',
          AppAlertType.warning,
        );
      } else if (error.contains('no registrado')) {
        _mostrarAlerta(
          'Error',
          'La matrícula no fue encontrada en la base de datos.',
          AppAlertType.error,
        );
      } else {
        _mostrarAlerta('Error', 'Ocurrió un problema: $e', AppAlertType.error);
      }
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Registro de Asistencia',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.rol == 'admin'
                  ? 'Selecciona la sesión y escanea/escribe la matrícula del participante.'
                  : 'Selecciona la sesión a la que vas a ingresar.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),
            const SizedBox(height: 32),

            const Text(
              'Sesión',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.event_seat_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              hint: const Text('Seleccionar sesión...'),
              value: _idSesionSeleccionada,
              items: _sesionesDisponibles.map((sesion) {
                return DropdownMenuItem<int>(
                  value: sesion['id_sesion'] as int,
                  child: Text('${sesion['clase']} (${sesion['hora']})'),
                );
              }).toList(),
              onChanged: (val) => setState(() => _idSesionSeleccionada = val),
            ),
            const SizedBox(height: 24),

            const Text(
              'Identificador / Matrícula',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _idController,
              readOnly: widget.rol == 'participante',
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.badge_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: widget.rol == 'participante'
                    ? Colors.grey.shade200
                    : Colors.white,
                hintText: 'Ej. 2023X001',
              ),
              validator: (val) => val == null || val.isEmpty
                  ? 'Ingresa el identificador'
                  : null,
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: _cargando ? null : _registrarAsistencia,
                icon: _cargando
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.check_circle_outline_rounded),
                label: Text(
                  _cargando ? 'Procesando...' : 'Confirmar Asistencia',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
