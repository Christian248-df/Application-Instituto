import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const AppTextField({
    super.key,
    this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          style: const TextStyle(
            color: Colors.white,
          ),

          decoration: InputDecoration(
            hintText: hint,

            hintStyle: const TextStyle(
              color: Colors.white54,
            ),

            prefixIcon: Icon(
              icon,
              color: Colors.white70,
            ),

            suffixIcon: suffixIcon,

            filled: true,

            fillColor: Colors.white.withOpacity(0.12),

            // Borde normal
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.25),
              ),
            ),

            // Borde cuando está habilitado
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: Colors.white.withOpacity(0.25),
              ),
            ),

            // Borde cuando tiene el foco
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.white,
                width: 1.5,
              ),
            ),

            // Borde cuando hay error
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1.5,
              ),
            ),

            // Borde cuando hay error y el input tiene el foco
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1.5,
              ),
            ),

            // Texto del error
            errorStyle: const TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}