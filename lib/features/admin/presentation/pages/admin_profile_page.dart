import 'package:flutter/material.dart';
import '../../../../core/widgets/app_alert.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color textColor = Color(0xFF111827);
  static const Color secondaryText = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);

  String adminName = 'Administrador';
  String adminEmail = 'admin@congreso.edu.mx';
  String adminRole = 'Administrador del sistema';

  bool notificationsEnabled = true;

  void _showEditProfile() {
    final nameController = TextEditingController(text: adminName);
    final emailController = TextEditingController(text: adminEmail);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Editar perfil',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Actualiza la información de tu cuenta.',
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryText,
                  ),
                ),

                const SizedBox(height: 24),

                _buildInput(
                  controller: nameController,
                  label: 'Nombre',
                  hint: 'Ingresa tu nombre',
                  icon: Icons.person_outline_rounded,
                ),

                const SizedBox(height: 16),

                _buildInput(
                  controller: emailController,
                  label: 'Correo electrónico',
                  hint: 'Ingresa tu correo',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.trim().isEmpty ||
                          emailController.text.trim().isEmpty) {
                        AppAlert.show(
                          context,
                          title: 'Campos incompletos',
                          message: 'Completa todos los campos.',
                          type: AppAlertType.warning,
                        );
                        return;
                      }

                      setState(() {
                        adminName = nameController.text.trim();
                        adminEmail = emailController.text.trim();
                      });

                      Navigator.pop(context);

                      AppAlert.show(
                        context,
                        title: 'Perfil actualizado',
                        message:
                            'La información del administrador fue actualizada correctamente.',
                        type: AppAlertType.success,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
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
      },
    );
  }

  void _showChangePassword() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Cambiar contraseña',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  'Mantén segura tu cuenta utilizando una contraseña segura.',
                  style: TextStyle(
                    fontSize: 14,
                    color: secondaryText,
                  ),
                ),

                const SizedBox(height: 24),

                _buildInput(
                  controller: currentPasswordController,
                  label: 'Contraseña actual',
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  obscureText: true,
                ),

                const SizedBox(height: 16),

                _buildInput(
                  controller: newPasswordController,
                  label: 'Nueva contraseña',
                  hint: '••••••••',
                  icon: Icons.lock_reset_rounded,
                  obscureText: true,
                ),

                const SizedBox(height: 16),

                _buildInput(
                  controller: confirmPasswordController,
                  label: 'Confirmar contraseña',
                  hint: '••••••••',
                  icon: Icons.lock_outline_rounded,
                  obscureText: true,
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      if (currentPasswordController.text.isEmpty ||
                          newPasswordController.text.isEmpty ||
                          confirmPasswordController.text.isEmpty) {
                        AppAlert.show(
                          context,
                          title: 'Campos incompletos',
                          message: 'Completa todos los campos.',
                          type: AppAlertType.warning,
                        );
                        return;
                      }

                      if (newPasswordController.text.length < 6) {
                        AppAlert.show(
                          context,
                          title: 'Contraseña inválida',
                          message:
                              'La nueva contraseña debe tener al menos 6 caracteres.',
                          type: AppAlertType.error,
                        );
                        return;
                      }

                      if (newPasswordController.text !=
                          confirmPasswordController.text) {
                        AppAlert.show(
                          context,
                          title: 'Las contraseñas no coinciden',
                          message:
                              'Verifica que ambas contraseñas sean iguales.',
                          type: AppAlertType.error,
                        );
                        return;
                      }

                      Navigator.pop(context);

                      AppAlert.show(
                        context,
                        title: 'Contraseña actualizada',
                        message:
                            'Tu contraseña fue actualizada correctamente.',
                        type: AppAlertType.success,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Actualizar contraseña',
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
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Cerrar sesión',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            '¿Estás seguro de que deseas cerrar la sesión?',
            style: TextStyle(
              color: secondaryText,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: secondaryText,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                AppAlert.show(
                  context,
                  title: 'Sesión cerrada',
                  message: 'Has cerrado sesión correctamente.',
                  type: AppAlertType.success,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: const Text('Cerrar sesión'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            prefixIcon: Icon(
              icon,
              color: secondaryText,
            ),
            filled: true,
            fillColor: backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: borderColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: borderColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: primaryBlue,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 12,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color iconColor = primaryBlue,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 5,
        ),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 21,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: secondaryText,
            ),
          ),
        ),
        trailing: trailing ??
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String initial =
        adminName.isNotEmpty ? adminName[0].toUpperCase() : 'A';

    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: textColor,
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mi perfil',
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Configuración de administrador',
              style: TextStyle(
                color: secondaryText,
                fontSize: 11,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PERFIL PRINCIPAL
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: borderColor,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.10),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryBlue.withOpacity(0.15),
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          initial,
                          style: const TextStyle(
                            color: primaryBlue,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Text(
                      adminName,
                      style: const TextStyle(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      adminEmail,
                      style: const TextStyle(
                        color: secondaryText,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: primaryBlue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.verified_user_rounded,
                            color: primaryBlue,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            adminRole,
                            style: const TextStyle(
                              color: primaryBlue,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: OutlinedButton.icon(
                        onPressed: _showEditProfile,
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 18,
                        ),
                        label: const Text(
                          'Editar perfil',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: primaryBlue,
                          side: const BorderSide(
                            color: primaryBlue,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // INFORMACIÓN DE CUENTA
              _buildSectionTitle('Cuenta'),

              _buildOption(
                icon: Icons.person_outline_rounded,
                title: 'Información personal',
                subtitle: 'Nombre y correo electrónico',
                onTap: _showEditProfile,
              ),

              _buildOption(
                icon: Icons.badge_outlined,
                title: 'Rol de usuario',
                subtitle: adminRole,
                onTap: () {
                  AppAlert.show(
                    context,
                    title: 'Rol de administrador',
                    message:
                        'Esta cuenta tiene permisos administrativos dentro del sistema.',
                    type: AppAlertType.info,
                  );
                },
              ),

              const SizedBox(height: 14),

              // SEGURIDAD
              _buildSectionTitle('Seguridad'),

              _buildOption(
                icon: Icons.lock_outline_rounded,
                title: 'Cambiar contraseña',
                subtitle: 'Actualiza la contraseña de acceso',
                onTap: _showChangePassword,
              ),

              _buildOption(
                icon: Icons.security_outlined,
                title: 'Seguridad de la cuenta',
                subtitle: 'Protección y control de acceso',
                onTap: () {
                  AppAlert.show(
                    context,
                    title: 'Cuenta protegida',
                    message:
                        'La cuenta cuenta con controles de seguridad activos.',
                    type: AppAlertType.success,
                  );
                },
              ),

              const SizedBox(height: 14),

              // PREFERENCIAS
              _buildSectionTitle('Preferencias'),

              _buildOption(
                icon: Icons.notifications_none_rounded,
                title: 'Notificaciones',
                subtitle: notificationsEnabled
                    ? 'Las notificaciones están activadas'
                    : 'Las notificaciones están desactivadas',
                onTap: () {
                  setState(() {
                    notificationsEnabled = !notificationsEnabled;
                  });

                  AppAlert.show(
                    context,
                    title: notificationsEnabled
                        ? 'Notificaciones activadas'
                        : 'Notificaciones desactivadas',
                    message: notificationsEnabled
                        ? 'Recibirás las notificaciones del sistema.'
                        : 'Ya no recibirás notificaciones del sistema.',
                    type: AppAlertType.info,
                  );
                },
                trailing: Switch(
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                  activeColor: primaryBlue,
                ),
              ),

              const SizedBox(height: 14),

              // INFORMACIÓN DEL SISTEMA
              _buildSectionTitle('Sistema'),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: borderColor,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.green,
                          ),
                        ),

                        const SizedBox(width: 12),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sistema operativo',
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                'Todos los servicios funcionan correctamente',
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
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.10),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'ACTIVO',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    const Divider(
                      color: borderColor,
                      height: 1,
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Versión de la aplicación',
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '1.0.0',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // CERRAR SESIÓN
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: _showLogoutDialog,
                  icon: const Icon(
                    Icons.logout_rounded,
                    size: 19,
                  ),
                  label: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(
                      color: Colors.red.withOpacity(0.35),
                    ),
                    backgroundColor: Colors.red.withOpacity(0.03),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Center(
                child: Text(
                  'Congreso Educativo • Panel administrativo',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}