import 'package:flutter/material.dart';

import '../../../../core/widgets/app_alert.dart';
import 'participants_page.dart';
import 'admin_profile_page.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  // ================================================================
  // COLORES
  // ================================================================

  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color textColor = Color(0xFF111827);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  // ================================================================
  // ALERTA DE MÓDULOS NO DISPONIBLES
  // ================================================================

  void _showComingSoon(String title, String message) {
    AppAlert.show(
      context,
      title: title,
      message: message,
      type: AppAlertType.info,
    );
  }

  // ================================================================
  // NAVEGACIÓN
  // ================================================================

  void _onNavigationTap(int index) {
    // --------------------------------------------------------------
    // INICIO
    // --------------------------------------------------------------

    if (index == 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return;
    }

    // --------------------------------------------------------------
    // SESIONES
    // --------------------------------------------------------------

    if (index == 1) {
      setState(() {
        _selectedIndex = 1;
      });

      _showComingSoon(
        'Sesiones',
        'El módulo de gestión de sesiones estará disponible próximamente.',
      );

      return;
    }

    // --------------------------------------------------------------
    // ASISTENCIA
    // --------------------------------------------------------------

    if (index == 2) {
      setState(() {
        _selectedIndex = 2;
      });

      _showComingSoon(
        'Asistencia',
        'El módulo de registro y consulta de asistencia estará disponible próximamente.',
      );

      return;
    }

    // --------------------------------------------------------------
    // PERFIL
    // --------------------------------------------------------------

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AdminProfilePage(),
        ),
      );

      return;
    }
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
            _buildTopBar(),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  24,
                  20,
                  24,
                  30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcome(),

                    const SizedBox(height: 28),

                    _buildSectionHeader(
                      title: 'Resumen del congreso',
                      subtitle: 'Información general',
                    ),

                    const SizedBox(height: 16),

                    _buildStatistics(),

                    const SizedBox(height: 32),

                    _buildSectionHeader(
                      title: 'Acciones rápidas',
                      subtitle: 'Gestiona las actividades del congreso',
                    ),

                    const SizedBox(height: 16),

                    _buildActions(),

                    const SizedBox(height: 28),

                    _buildSystemStatus(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ================================================================
  // BARRA SUPERIOR
  // ================================================================

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        24,
        18,
        24,
        18,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primaryBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.event_available_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: 12),

          // Títulos
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CONGRESO EDUCATIVO',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Panel de administración',
                  style: TextStyle(
                    color: secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Notificaciones
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor,
              ),
            ),
            child: IconButton(
              onPressed: () {
                _showComingSoon(
                  'Notificaciones',
                  'Las notificaciones estarán disponibles próximamente.',
                );
              },
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: textColor,
                size: 21,
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Avatar
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminProfilePage(),
                ),
              );
            },
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFDBEAFE),
                ),
              ),
              child: const Icon(
                Icons.person_outline_rounded,
                color: primaryBlue,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // BIENVENIDA
  // ================================================================

  Widget _buildWelcome() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Buenos días, Administrador',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Aquí tienes un resumen de la actividad del congreso.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.dashboard_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ENCABEZADO DE SECCIÓN
  // ================================================================

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: textColor,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          subtitle,
          style: const TextStyle(
            color: secondaryText,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  // ================================================================
  // ESTADÍSTICAS
  // ================================================================

  Widget _buildStatistics() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.55,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard(
          icon: Icons.people_alt_outlined,
          title: 'Participantes',
          value: '128',
          subtitle: 'Registrados',
          iconColor: primaryBlue,
        ),

        _buildStatCard(
          icon: Icons.event_note_outlined,
          title: 'Sesiones',
          value: '3',
          subtitle: 'Programadas',
          iconColor: const Color(0xFF7C3AED),
        ),

        _buildStatCard(
          icon: Icons.fact_check_outlined,
          title: 'Asistencias',
          value: '96',
          subtitle: 'Registradas',
          iconColor: const Color(0xFF059669),
        ),

        _buildStatCard(
          icon: Icons.description_outlined,
          title: 'Reportes',
          value: '3',
          subtitle: 'Disponibles',
          iconColor: const Color(0xFFD97706),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.09),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 21,
                ),
              ),

              const Spacer(),

              Text(
                value,
                style: const TextStyle(
                  color: textColor,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const Spacer(),

          Text(
            title,
            style: const TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            subtitle,
            style: const TextStyle(
              color: secondaryText,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // ACCIONES
  // ================================================================

  Widget _buildActions() {
    return Column(
      children: [
        _buildActionCard(
          icon: Icons.people_alt_outlined,
          title: 'Gestionar participantes',
          description:
              'Registrar, consultar y administrar participantes.',
          iconColor: primaryBlue,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ParticipantsPage(),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        _buildActionCard(
          icon: Icons.event_note_outlined,
          title: 'Gestionar sesiones',
          description:
              'Crear y administrar las sesiones del congreso.',
          iconColor: const Color(0xFF7C3AED),
          onTap: () {
            _showComingSoon(
              'Sesiones',
              'El módulo de sesiones estará disponible próximamente.',
            );
          },
        ),

        const SizedBox(height: 12),

        _buildActionCard(
          icon: Icons.qr_code_scanner_rounded,
          title: 'Registrar asistencia',
          description:
              'Registrar la entrada mediante QR o identificador.',
          iconColor: const Color(0xFF059669),
          onTap: () {
            _showComingSoon(
              'Registrar asistencia',
              'El módulo de asistencia estará disponible próximamente.',
            );
          },
        ),

        const SizedBox(height: 12),

        _buildActionCard(
          icon: Icons.search_rounded,
          title: 'Consultar asistencia',
          description:
              'Consultar participantes y estados de asistencia.',
          iconColor: const Color(0xFFD97706),
          onTap: () {
            _showComingSoon(
              'Consultar asistencia',
              'La consulta de asistencia estará disponible próximamente.',
            );
          },
        ),

        const SizedBox(height: 12),

        _buildActionCard(
          icon: Icons.picture_as_pdf_outlined,
          title: 'Generar reporte',
          description:
              'Crear reportes de participantes y asistencias.',
          iconColor: const Color(0xFFDC2626),
          onTap: () {
            _showComingSoon(
              'Generar reporte',
              'La generación de reportes estará disponible próximamente.',
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String description,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
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
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,
                      style: const TextStyle(
                        color: secondaryText,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF9CA3AF),
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // ESTADO DEL SISTEMA
  // ================================================================

  Widget _buildSystemStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: Color(0xFF059669),
              size: 23,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sistema operativo',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 3),

                Text(
                  'El panel administrativo está listo para trabajar.',
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
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'ACTIVO',
              style: TextStyle(
                color: Color(0xFF059669),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // NAVEGACIÓN INFERIOR
  // ================================================================

  Widget _buildBottomNavigation() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          child: Row(
            children: [
              _buildNavigationItem(
                index: 0,
                icon: Icons.dashboard_rounded,
                label: 'Inicio',
              ),

              _buildNavigationItem(
                index: 1,
                icon: Icons.event_note_outlined,
                label: 'Sesiones',
              ),

              _buildNavigationItem(
                index: 2,
                icon: Icons.fact_check_outlined,
                label: 'Asistencia',
              ),

              _buildNavigationItem(
                index: 3,
                icon: Icons.person_outline_rounded,
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================================================================
  // ITEM DE NAVEGACIÓN
  // ================================================================

  Widget _buildNavigationItem({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final bool selected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onNavigationTap(index),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 200,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(
                  milliseconds: 200,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFFEFF6FF)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: selected
                      ? primaryBlue
                      : const Color(0xFF6B7280),
                  size: 21,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? primaryBlue
                      : const Color(0xFF6B7280),
                  fontSize: 10,
                  fontWeight: selected
                      ? FontWeight.bold
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}