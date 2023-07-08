import 'package:flutter/material.dart';

class DefaultTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;

  const DefaultTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE8E8E8)),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        fillColor: Colors.grey.shade100,
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFBDBDBD),
        ),
      ),
      validator: validator,
    );
  }
}

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?) validator;

  const PasswordFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.validator,
  });

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE8E8E8)),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        fillColor: Colors.grey.shade100,
        filled: true,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Color(0xFFBDBDBD),
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: _obscureText
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
        ),
      ),
      validator: widget.validator,
    );
  }
}
