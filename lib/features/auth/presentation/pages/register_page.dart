import 'package:flutter/material.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/database/database_helper.dart';
import '../../../../core/widgets/app_alert.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _institucionController = TextEditingController();
  final TextEditingController _identificadorController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    _animationController.forward();
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _institucionController.dispose();
    _identificadorController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final datosRegistro = {
          'nombre_completo': _nombreController.text.trim(),
          'correo': _correoController.text.trim(),
          'institucion': _institucionController.text.trim(),
          'identificador': _identificadorController.text.trim(),
        };

        await DatabaseHelper.instance.registrarParticipante(
          datosRegistro,
          _passwordController.text.trim(),
        );

        if (!mounted) return;
        AppAlert.show(
          context,
          title: '¡Registro Exitoso!',
          message: 'Tu cuenta ha sido creada. Ahora puedes iniciar sesión.',
          type: AppAlertType.success,
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.pop(context);
        });
      } catch (e) {
        if (!mounted) return;
        String error = e.toString().toLowerCase();

        if (error.contains('unique constraint failed')) {
          AppAlert.show(
            context,
            title: 'Datos Duplicados',
            message: 'El correo electrónico o el identificador ya están registrados.',
            type: AppAlertType.warning,
          );
        } else {
          AppAlert.show(
            context,
            title: 'Error',
            message: 'Ocurrió un problema: $e',
            type: AppAlertType.error,
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/conference.jpeg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.40),
                  Colors.black.withOpacity(0.70),
                  Colors.black.withOpacity(0.95),
                ],
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 20,
                ),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      children: [
                        // BOTÓN REGRESAR
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // TÍTULO
                        const Text(
                          'Crear Cuenta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Regístrate para acceder al congreso',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),

                        const SizedBox(height: 30),

                        // FORMULARIO
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // 1. Nombre Completo
                              AppTextField(
                                controller: _nombreController,
                                label: 'Nombre completo',
                                hint: 'Ej. Juan Pérez',
                                icon: Icons.person_outline_rounded,
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                    ? 'Ingresa tu nombre'
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              // 2. Correo Electrónico
                              AppTextField(
                                controller: _correoController,
                                label: 'Correo electrónico',
                                hint: 'correo@ejemplo.com',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty)
                                    return 'Ingresa tu correo';
                                  final emailRegex = RegExp(
                                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                  );
                                  if (!emailRegex.hasMatch(value.trim()))
                                    return 'Ingresa un correo válido';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // 3. Institución
                              AppTextField(
                                controller: _institucionController,
                                label: 'Institución de procedencia',
                                hint: 'Ej. UAEM',
                                icon: Icons.school_outlined,
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                    ? 'Ingresa tu institución'
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              // 4. Identificador / Matrícula
                              AppTextField(
                                controller: _identificadorController,
                                label: 'Identificador o Matrícula',
                                hint: 'Ej. 2023X001',
                                icon: Icons.badge_outlined,
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                    ? 'Ingresa tu identificador'
                                    : null,
                              ),
                              const SizedBox(height: 16),

                              // 5. Contraseña
                              AppTextField(
                                controller: _passwordController,
                                label: 'Contraseña',
                                hint: '••••••••',
                                icon: Icons.lock_outline_rounded,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white70,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty)
                                    return 'Ingresa una contraseña';
                                  if (value.length < 6)
                                    return 'Mínimo 6 caracteres';
                                  return null;
                                },
                              ),
                              const SizedBox(height: 35),

                              // BOTÓN DE REGISTRO
                              _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.blueAccent,
                                    )
                                  : AppButton(
                                      text: 'Registrar participante',
                                      onPressed: _register,
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
