
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_alert.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color textColor = Color(0xFF111827);
  static const Color secondaryTextColor = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

  final List<CongressSession> _sessions = [
    CongressSession(
      name: 'Inauguración del Congreso',
      date: '10/09/2026',
      time: '09:00',
      place: 'Auditorio principal',
    ),
    CongressSession(
      name: 'Seguridad Informática',
      date: '10/09/2026',
      time: '10:30',
      place: 'Sala A',
    ),
    CongressSession(
      name: 'Desarrollo de Aplicaciones Móviles',
      date: '10/09/2026',
      time: '12:00',
      place: 'Laboratorio de cómputo',
    ),
  ];

  String _search = '';

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  List<CongressSession> get _filteredSessions {
    if (_search.isEmpty) {
      return _sessions;
    }

    return _sessions.where((session) {
      return session.name.toLowerCase().contains(_search) ||
          session.place.toLowerCase().contains(_search) ||
          session.date.toLowerCase().contains(_search);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildRegistrationCard(),
              const SizedBox(height: 24),
              _buildSessionsHeader(),
              const SizedBox(height: 12),
              _buildSearch(),
              const SizedBox(height: 14),
              _buildSessionsList(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: textColor,
        ),
      ),
      title: const Text(
        'Sesiones',
        style: TextStyle(
          color: textColor,
          fontSize: 19,
          fontWeight: FontWeight.w700,
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(
          height: 1,
          color: borderColor,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.event_note_rounded,
            color: primaryColor,
            size: 27,
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gestionar sesiones',
                style: TextStyle(
                  color: textColor,
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Administra las actividades del congreso.',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegistrationCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Registrar sesión',
            style: TextStyle(
              color: textColor,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Agrega una nueva sesión al programa del congreso.',
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 18),

          _buildField(
            controller: _nameController,
            label: 'Nombre de la sesión',
            hint: 'Ej. Taller de Ciberseguridad',
            icon: Icons.title_rounded,
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: _buildField(
                  controller: _dateController,
                  label: 'Fecha',
                  hint: 'DD/MM/AAAA',
                  icon: Icons.calendar_today_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildField(
                  controller: _timeController,
                  label: 'Hora',
                  hint: 'HH:MM',
                  icon: Icons.access_time_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          _buildField(
            controller: _placeController,
            label: 'Lugar / Sala',
            hint: 'Ej. Auditorio principal',
            icon: Icons.location_on_outlined,
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearForm,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    side: const BorderSide(
                      color: borderColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Limpiar',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _registerSession,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Registrar sesión'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          style: const TextStyle(
            color: textColor,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
            prefixIcon: Icon(
              icon,
              color: secondaryTextColor,
              size: 20,
            ),
            filled: true,
            fillColor: backgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: primaryColor,
                width: 1.3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionsHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sesiones registradas',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Consulta y administra las sesiones.',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${_sessions.length} sesiones',
            style: const TextStyle(
              color: primaryColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return TextField(
      onChanged: (value) {
        setState(() {
          _search = value.trim().toLowerCase();
        });
      },
      style: const TextStyle(
        color: textColor,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: 'Buscar sesión, lugar o fecha...',
        hintStyle: const TextStyle(
          color: secondaryTextColor,
          fontSize: 13,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: secondaryTextColor,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSessionsList() {
    final sessions = _filteredSessions;

    if (sessions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: borderColor),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.event_busy_outlined,
              color: Colors.grey,
              size: 45,
            ),
            SizedBox(height: 12),
            Text(
              'No se encontraron sesiones',
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Intenta modificar tu búsqueda.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: sessions.map(_buildSessionCard).toList(),
    );
  }

  Widget _buildSessionCard(CongressSession session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.event_rounded,
              color: primaryColor,
              size: 25,
            ),
          ),
          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.name,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),

                Wrap(
                  spacing: 12,
                  runSpacing: 7,
                  children: [
                    _buildInfo(
                      Icons.calendar_today_outlined,
                      session.date,
                    ),
                    _buildInfo(
                      Icons.access_time_rounded,
                      session.time,
                    ),
                    _buildInfo(
                      Icons.location_on_outlined,
                      session.place,
                    ),
                  ],
                ),
              ],
            ),
          ),

          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert_rounded,
              color: secondaryTextColor,
            ),
            onSelected: (value) {
              if (value == 'edit') {
                _editSession(session);
              }

              if (value == 'delete') {
                _deleteSession(session);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text('Editar'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text('Eliminar'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfo(
    IconData icon,
    String text,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: secondaryTextColor,
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            color: secondaryTextColor,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  void _registerSession() {
    final name = _nameController.text.trim();
    final date = _dateController.text.trim();
    final time = _timeController.text.trim();
    final place = _placeController.text.trim();

    if (name.isEmpty ||
        date.isEmpty ||
        time.isEmpty ||
        place.isEmpty) {
      AppAlert.show(
        context,
        title: 'Datos incompletos',
        message: 'Completa todos los campos para registrar la sesión.',
        type: AppAlertType.warning,
      );
      return;
    }

    setState(() {
      _sessions.add(
        CongressSession(
          name: name,
          date: date,
          time: time,
          place: place,
        ),
      );
    });

    _clearForm();

    AppAlert.show(
      context,
      title: 'Sesión registrada',
      message: 'La sesión se agregó correctamente.',
      type: AppAlertType.success,
    );
  }

  void _clearForm() {
    _nameController.clear();
    _dateController.clear();
    _timeController.clear();
    _placeController.clear();
  }

  void _editSession(CongressSession session) {
    final nameController = TextEditingController(text: session.name);
    final dateController = TextEditingController(text: session.date);
    final timeController = TextEditingController(text: session.time);
    final placeController = TextEditingController(text: session.place);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 22,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Editar sesión',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),

                _buildBottomSheetField(
                  controller: nameController,
                  label: 'Nombre',
                ),
                const SizedBox(height: 12),

                _buildBottomSheetField(
                  controller: dateController,
                  label: 'Fecha',
                ),
                const SizedBox(height: 12),

                _buildBottomSheetField(
                  controller: timeController,
                  label: 'Hora',
                ),
                const SizedBox(height: 12),

                _buildBottomSheetField(
                  controller: placeController,
                  label: 'Lugar / Sala',
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      final index = _sessions.indexOf(session);

                      if (index == -1) {
                        Navigator.pop(context);
                        return;
                      }

                      setState(() {
                        _sessions[index] = CongressSession(
                          name: nameController.text.trim(),
                          date: dateController.text.trim(),
                          time: timeController.text.trim(),
                          place: placeController.text.trim(),
                        );
                      });

                      Navigator.pop(context);

                      AppAlert.show(
                        this.context,
                        title: 'Sesión actualizada',
                        message:
                            'Los datos de la sesión fueron actualizados.',
                        type: AppAlertType.success,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Guardar cambios',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        color: textColor,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: secondaryTextColor,
        ),
        filled: true,
        fillColor: backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: borderColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: borderColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: primaryColor,
          ),
        ),
      ),
    );
  }

  void _deleteSession(CongressSession session) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Eliminar sesión',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Text(
            '¿Deseas eliminar "${session.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _sessions.remove(session);
                });

                Navigator.pop(dialogContext);

                AppAlert.show(
                  context,
                  title: 'Sesión eliminada',
                  message: 'La sesión fue eliminada correctamente.',
                  type: AppAlertType.success,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}

class CongressSession {
  final String name;
  final String date;
  final String time;
  final String place;

  const CongressSession({
    required this.name,
    required this.date,
    required this.time,
    required this.place,
  });
}
