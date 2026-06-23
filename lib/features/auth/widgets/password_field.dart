import 'package:flutter/material.dart';

/// Password input with a show/hide toggle.
class PasswordField extends StatefulWidget {
  const PasswordField({super.key, this.label = 'Password', this.controller});

  final String label;
  final TextEditingController? controller;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _obscured,
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(_obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined),
          onPressed: () => setState(() => _obscured = !_obscured),
        ),
      ),
    );
  }
}
