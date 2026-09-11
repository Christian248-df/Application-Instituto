import 'package:flutter/material.dart';
import 'package:flutter_crud_app/features/auth/presentation/pages/login_page.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_alert.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
    _nameController.dispose();
    _emailController.dispose();
    _institutionController.dispose();
    _matriculaController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    _animationController.dispose();

    super.dispose();
  }

  void _register() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
        });

AppAlert.show(
  context,
  title: 'Registro exitoso',
  message: 'Tu cuenta fue creada correctamente.',
  type: AppAlertType.success,
);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fondo
          Image.asset('assets/images/conference_bg.png', fit: BoxFit.cover),

          // Capa oscura
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.60),
                  Colors.black.withOpacity(0.88),
                ],
              ),
            ),
          ),

          // Contenido
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
                        // Botón regresar
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Icono
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                            ),
                          ),
                          child: const Icon(
                            Icons.music_note_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Registro de nuevo alumno',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Regístrate para acceder al instituto de música',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),

                        const SizedBox(height: 30),

                        // FORMULARIO
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Nombre completo
                              AppTextField(
                                controller: _nameController,
                                label: 'Nombre completo',
                                hint: 'Ej. Carlos Peralta Trujillo',
                                icon: Icons.person_outline,
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Ingresa tu nombre completo';
                                  }

                                  final name = value.trim();

                                  if (RegExp(r'^\d+$').hasMatch(name)) {
                                    return 'El nombre no puede contener solo números';
                                  }

                                  final nameRegex = RegExp(
                                    r"^[a-zA-ZáéíóúÁÉÍÓÚñÑüÜ\s]+$",
                                  );

                                  if (!nameRegex.hasMatch(name)) {
                                    return 'El nombre solo puede contener letras';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Correo
                              AppTextField(
                                controller: _emailController,
                                label: 'Correo electrónico',
                                hint: 'correo@ejemplo.com',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Ingresa tu correo';
                                  }

                                  final email = value.trim();

                                  final emailRegex = RegExp(
                                    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                                  );

                                  if (!emailRegex.hasMatch(email)) {
                                    return 'Ingresa un correo válido';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Institución
                              AppTextField(
                                controller: _institutionController,
                                label: 'Ingrese el instituto',
                                hint: 'Universidad Tecnológica...',
                                icon: Icons.school_outlined,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Ingresa una institución';
                                  }

                                  final institution = value.trim();

                                  if (RegExp(r'^\d+$').hasMatch(institution)) {
                                    return 'La institución no puede contener solo números';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Matrícula
                              AppTextField(
                                controller: _matriculaController,
                                label: 'Ingresa tu matrícula',
                                hint: '20652MS089',
                                icon: Icons.badge_outlined,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Ingresa tu matrícula';
                                  }

                                  final matricula = value.trim();

                                  if (matricula.length < 5) {
                                    return 'La matrícula es demasiado corta';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Contraseña
                              AppTextField(
                                controller: _passwordController,
                                label: 'Contraseña',
                                hint: '••••••••',
                                icon: Icons.lock_outline_rounded,
                                obscureText: _obscurePassword,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white70,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Ingresa tu contraseña';
                                  }

                                  if (value.length < 6) {
                                    return 'Mínimo 6 caracteres';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // Confirmar contraseña
                              AppTextField(
                                controller: _confirmPasswordController,
                                label: 'Confirmar contraseña',
                                hint: '••••••••',
                                icon: Icons.lock_outline_rounded,
                                obscureText: _obscureConfirmPassword,
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white70,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Confirma tu contraseña';
                                  }

                                  if (value.length < 6) {
                                    return 'Mínimo 6 caracteres';
                                  }

                                  if (value != _passwordController.text) {
                                    return 'Las contraseñas no coinciden';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 25),

                              // Botón registrar
                              AppButton(
                                text: 'Crear cuenta',
                                icon: Icons.person_add_alt_1,
                                loading: _isLoading,
                                onPressed: _register,
                              ),

                              const SizedBox(height: 10),

                              // Ir a Login
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '¿Ya tienes una cuenta?',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Iniciar sesión',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        /**FOOTER */
                        const Text(
                          'Congreso Educativo • 2026',
                          style: TextStyle(color: Colors.white54, fontSize: 12),
                        ),
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
