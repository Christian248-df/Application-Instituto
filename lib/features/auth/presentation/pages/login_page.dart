import 'package:flutter/material.dart';

import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';

import '../../../../core/database/database_helper.dart';
import '../../../home/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

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
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final user = _emailController.text.trim();
      final pass = _passwordController.text.trim();

      // 1. Intentar login como Administrador
      final admin = await DatabaseHelper.instance.login(user, pass);
      if (admin != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bienvenido Administrador'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage(rol: 'admin')),
        );
        return;
      }

      // 2. Intentar login como Participante (Alumno)
      final participante = await DatabaseHelper.instance.loginParticipante(
        user,
        pass,
      );
      if (participante != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hola, ${participante.nombreCompleto}'),
            backgroundColor: Colors.blue,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomePage(
              rol: 'participante',
              idParticipante: participante.id,
              nombreParticipante: participante.nombreCompleto,
              identificador: participante.identificador,
            ),
          ),
        );
        return;
      }

      // 3. Si ambos fallan
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Credenciales incorrectas'),
          backgroundColor: Colors.redAccent,
        ),
      );
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
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.60),
                  Colors.black.withOpacity(0.88),
                ],
              ),
            ),
          ),

          // ============================================================
          // CONTENIDO
          // ============================================================
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
                        // ==================================================
                        // BOTÓN REGRESAR
                        // ==================================================
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

                        // ==================================================
                        // ICONO
                        // ==================================================
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

                        // ==================================================
                        // TÍTULO
                        // ==================================================
                        const Text(
                          'Bienvenido de nuevo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          'Inicia sesión para continuar',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),

                        const SizedBox(height: 30),

                        // ==================================================
                        // FORMULARIO
                        // ==================================================
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // =================================================
                              // CORREO / USUARIO
                              // =================================================
                              AppTextField(
                                controller: _emailController,
                                label: 'Correo electrónico o Usuario',
                                hint: 'correo@ejemplo.com',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  // Se quitó el Regex estricto para permitir la palabra "admin"
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Ingresa tu usuario o correo';
                                  }
                                  return null;
                                },
                              ),

                              const SizedBox(height: 20),

                              // =================================================
                              // CONTRASEÑA
                              // =================================================
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
                                  // Se quitó el mínimo de 6 caracteres para permitir "admin"
                                  if (value == null || value.isEmpty) {
                                    return 'Ingresa tu contraseña';
                                  }
                                  return null;
                                },
                              ),

                              // =================================================
                              // RECUPERAR CONTRASEÑA
                              // =================================================
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    // TODO:
                                    // Recuperar contraseña
                                  },
                                  child: const Text(
                                    '¿Olvidaste tu contraseña?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15),

                              // =================================================
                              // BOTÓN LOGIN
                              // =================================================
                              AppButton(
                                text: 'Iniciar sesión',
                                onPressed: _login,
                              ),

                              const SizedBox(height: 18),

                              // =================================================
                              // REGISTRO
                              // =================================================
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '¿No tienes una cuenta?',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Aquí Christian deberá colocar la navegación al register_page.dart
                                    },
                                    child: const Text(
                                      'Registrarse',
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

                        const SizedBox(height: 25),

                        // ====================================================
                        // FOOTER
                        // ====================================================
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
