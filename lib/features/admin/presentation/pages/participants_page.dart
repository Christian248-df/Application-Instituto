
import 'package:flutter/material.dart';
import '../../../../core/widgets/app_alert.dart';

class ParticipantsPage extends StatefulWidget {
  const ParticipantsPage({super.key});

  @override
  State<ParticipantsPage> createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends State<ParticipantsPage> {
  // ================================================================
  // COLORES
  // ================================================================

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color textColor = Color(0xFF111827);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  // ================================================================
  // CONTROLADORES
  // ================================================================

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _institutionController =
      TextEditingController();
  final TextEditingController _identifierController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // ================================================================
  // DATOS DE PRUEBA
  // ================================================================

  final List<Map<String, String>> _participants = [
    {
      'name': 'María Fernanda López',
      'email': 'maria.lopez@email.com',
      'institution': 'UAEM',
      'identifier': 'CON-001',
    },
    {
      'name': 'Carlos Hernández García',
      'email': 'carlos.hernandez@email.com',
      'institution': 'UNAM',
      'identifier': 'CON-002',
    },
    {
      'name': 'Ana Sofía Martínez',
      'email': 'ana.martinez@email.com',
      'institution': 'IPN',
      'identifier': 'CON-003',
    },
    {
      'name': 'Luis Alberto Ramírez',
      'email': 'luis.ramirez@email.com',
      'institution': 'UAEM',
      'identifier': 'CON-004',
    },
  ];

  // ================================================================
  // ESTADO
  // ================================================================

  bool _isLoading = false;

  // ================================================================
  // INIT
  // ================================================================

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _institutionController.dispose();
    _identifierController.dispose();
    _searchController.dispose();

    super.dispose();
  }

  // ================================================================
  // PARTICIPANTES FILTRADOS
  // ================================================================

  List<Map<String, String>> get _filteredParticipants {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _participants;
    }

    return _participants.where((participant) {
      final name = participant['name']!.toLowerCase();
      final email = participant['email']!.toLowerCase();
      final institution = participant['institution']!.toLowerCase();
      final identifier = participant['identifier']!.toLowerCase();

      return name.contains(query) ||
          email.contains(query) ||
          institution.contains(query) ||
          identifier.contains(query);
    }).toList();
  }

  // ================================================================
  // REGISTRAR PARTICIPANTE
  // ================================================================

  Future<void> _registerParticipant() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    final participant = {
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'institution': _institutionController.text.trim(),
      'identifier': _identifierController.text.trim(),
    };

    setState(() {
      _participants.insert(0, participant);
      _isLoading = false;
    });

    _clearForm();

    if (!mounted) return;

    AppAlert.show(
      context,
      title: 'Participante registrado',
      message: 'El participante fue agregado correctamente.',
      type: AppAlertType.success,
    );
  }

  // ================================================================
  // LIMPIAR FORMULARIO
  // ================================================================

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _institutionController.clear();
    _identifierController.clear();

    FocusScope.of(context).unfocus();
  }

  // ================================================================
  // ELIMINAR PARTICIPANTE
  // ================================================================

  void _deleteParticipant(Map<String, String> participant) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Eliminar participante',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Deseas eliminar a ${participant['name']}?',
            style: const TextStyle(
              color: secondaryText,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: secondaryText,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _participants.remove(participant);
                });

                Navigator.pop(context);

                AppAlert.show(
                  this.context,
                  title: 'Participante eliminado',
                  message: 'El registro fue eliminado correctamente.',
                  type: AppAlertType.success,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // EDITAR PARTICIPANTE
  // ================================================================

  void _editParticipant(Map<String, String> participant) {
    _nameController.text = participant['name'] ?? '';
    _emailController.text = participant['email'] ?? '';
    _institutionController.text = participant['institution'] ?? '';
    _identifierController.text = participant['identifier'] ?? '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _buildEditModal(participant);
      },
    );
  }

  // ================================================================
  // MODAL DE EDICIÓN
  // ================================================================

  Widget _buildEditModal(Map<String, String> participant) {
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Editar participante',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: secondaryText,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildInput(
              controller: _nameController,
              label: 'Nombre completo',
              hint: 'Ej. Juan Pérez García',
              icon: Icons.person_outline_rounded,
            ),

            const SizedBox(height: 14),

            _buildInput(
              controller: _emailController,
              label: 'Correo electrónico',
              hint: 'correo@ejemplo.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            const SizedBox(height: 14),

            _buildInput(
              controller: _institutionController,
              label: 'Institución',
              hint: 'Ej. UAEM',
              icon: Icons.school_outlined,
            ),

            const SizedBox(height: 14),

            _buildInput(
              controller: _identifierController,
              label: 'Identificador',
              hint: 'Ej. CON-001',
              icon: Icons.badge_outlined,
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    participant['name'] = _nameController.text.trim();
                    participant['email'] = _emailController.text.trim();
                    participant['institution'] =
                        _institutionController.text.trim();
                    participant['identifier'] =
                        _identifierController.text.trim();
                  });

                  Navigator.pop(context);
                  _clearForm();

                  AppAlert.show(
                    this.context,
                    title: 'Cambios guardados',
                    message:
                        'La información del participante fue actualizada.',
                    type: AppAlertType.success,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
                child: const Text(
                  'Guardar cambios',
                  style: TextStyle(
                    fontSize: 15,
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

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  24,
                  22,
                  24,
                  30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPageTitle(),

                    const SizedBox(height: 24),

                    _buildRegistrationCard(),

                    const SizedBox(height: 30),

                    _buildParticipantsHeader(),

                    const SizedBox(height: 14),

                    _buildSearch(),

                    const SizedBox(height: 16),

                    _buildParticipantsList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // HEADER
  // ================================================================

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        14,
        20,
        14,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: borderColor,
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: textColor,
            ),
          ),

          const SizedBox(width: 4),

          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.people_alt_outlined,
              color: primaryBlue,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Participantes',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Gestión de participantes',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 11,
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
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_participants.length}',
              style: const TextStyle(
                color: primaryBlue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // TÍTULO
  // ================================================================

  Widget _buildPageTitle() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gestionar participantes',
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Registra y administra las personas que participarán en el congreso.',
          style: TextStyle(
            color: secondaryText,
            fontSize: 13,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // ================================================================
  // TARJETA DE REGISTRO
  // ================================================================

  Widget _buildRegistrationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.person_add_alt_1_rounded,
                    color: primaryBlue,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 12),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nuevo participante',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Completa la información requerida',
                        style: TextStyle(
                          color: secondaryText,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            _buildInput(
              controller: _nameController,
              label: 'Nombre completo',
              hint: 'Ej. Juan Pérez García',
              icon: Icons.person_outline_rounded,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa el nombre completo';
                }

                if (RegExp(r'^\d+$').hasMatch(value.trim())) {
                  return 'El nombre no puede contener solo números';
                }

                return null;
              },
            ),

            const SizedBox(height: 14),

            _buildInput(
              controller: _emailController,
              label: 'Correo electrónico',
              hint: 'correo@ejemplo.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa el correo electrónico';
                }

                final emailRegex =
                    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Ingresa un correo válido';
                }

                return null;
              },
            ),

            const SizedBox(height: 14),

            _buildInput(
              controller: _institutionController,
              label: 'Institución',
              hint: 'Ej. Universidad Autónoma del Estado de Morelos',
              icon: Icons.school_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa la institución';
                }

                return null;
              },
            ),

            const SizedBox(height: 14),

            _buildInput(
              controller: _identifierController,
              label: 'Identificador del participante',
              hint: 'Ej. CON-001',
              icon: Icons.badge_outlined,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa el identificador';
                }

                if (value.trim().length < 3) {
                  return 'El identificador es demasiado corto';
                }

                return null;
              },
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              _clearForm();
                            },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: secondaryText,
                        side: const BorderSide(
                          color: borderColor,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: const Text(
                        'Limpiar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed:
                          _isLoading ? null : _registerParticipant,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            primaryBlue.withOpacity(0.55),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      icon: _isLoading
                          ? const SizedBox(
                              width: 19,
                              height: 19,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.person_add_alt_1_rounded,
                              size: 19,
                            ),
                      label: Text(
                        _isLoading
                            ? 'Registrando...'
                            : 'Registrar participante',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // INPUT
  // ================================================================

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 7),

        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            color: textColor,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 13,
            ),
            prefixIcon: Icon(
              icon,
              color: secondaryText,
              size: 20,
            ),
            filled: true,
            fillColor: backgroundColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 15,
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
                color: primaryBlue,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFDC2626),
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: Color(0xFFDC2626),
                width: 1.5,
              ),
            ),
            errorStyle: const TextStyle(
              color: Color(0xFFDC2626),
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // HEADER DE LISTA
  // ================================================================

  Widget _buildParticipantsHeader() {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Participantes registrados',
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Consulta y administra los registros.',
                style: TextStyle(
                  color: secondaryText,
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: borderColor,
            ),
          ),
          child: Text(
            '${_filteredParticipants.length} registros',
            style: const TextStyle(
              color: secondaryText,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ================================================================
  // BUSCADOR
  // ================================================================

  Widget _buildSearch() {
    return TextField(
      controller: _searchController,
      style: const TextStyle(
        color: textColor,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: 'Buscar por nombre, correo o identificador...',
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 12,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: secondaryText,
          size: 21,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  _searchController.clear();
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: secondaryText,
                  size: 19,
                ),
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
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
            color: primaryBlue,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  // ================================================================
  // LISTA DE PARTICIPANTES
  // ================================================================

  Widget _buildParticipantsList() {
    final participants = _filteredParticipants;

    if (participants.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: participants.map((participant) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 12,
          ),
          child: _buildParticipantCard(participant),
        );
      }).toList(),
    );
  }

  // ================================================================
  // TARJETA DE PARTICIPANTE
  // ================================================================

  Widget _buildParticipantCard(
    Map<String, String> participant,
  ) {
    final name = participant['name'] ?? '';
    final email = participant['email'] ?? '';
    final institution = participant['institution'] ?? '';
    final identifier = participant['identifier'] ?? '';

    final initial = name.isNotEmpty
        ? name.substring(0, 1).toUpperCase()
        : '?';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              initial,
              style: const TextStyle(
                color: primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 13),

          // Información
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: secondaryText,
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: secondaryText,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Row(
                  children: [
                    const Icon(
                      Icons.school_outlined,
                      color: secondaryText,
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        institution,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: secondaryText,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 7),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    identifier,
                    style: const TextStyle(
                      color: textColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Acciones
          PopupMenuButton<String>(
            color: Colors.white,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            icon: const Icon(
              Icons.more_vert_rounded,
              color: secondaryText,
              size: 21,
            ),
            onSelected: (value) {
              if (value == 'edit') {
                _editParticipant(participant);
              }

              if (value == 'delete') {
                _deleteParticipant(participant);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      color: primaryBlue,
                      size: 19,
                    ),
                    SizedBox(width: 10),
                    Text('Editar'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFDC2626),
                      size: 19,
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

  // ================================================================
  // ESTADO VACÍO
  // ================================================================

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 45,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.people_outline_rounded,
            color: Color(0xFF9CA3AF),
            size: 48,
          ),

          SizedBox(height: 14),

          Text(
            'No se encontraron participantes',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 5),

          Text(
            'Prueba con otro término de búsqueda.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: secondaryText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

