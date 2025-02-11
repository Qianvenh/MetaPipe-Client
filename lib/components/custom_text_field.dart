import 'package:flutter/material.dart';

class ComplexTextField extends StatelessWidget {
  final String label;
  final String? help, suffix, hint, prefix, counter;
  final Icon? prefixIcon, outterIcon, suffixIcon;
  final TextEditingController? controller;

  const ComplexTextField({
    super.key,
    required this.label,
    this.controller,
    this.help,
    this.counter,
    this.suffix,
    this.suffixIcon,
    this.hint,
    this.outterIcon,
    this.prefix,
    this.prefixIcon = const Icon(Icons.language),
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(fontSize: 12),
      maxLines: 3,
      minLines: 1,
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeData().focusColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeData().hoverColor),
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        labelText: label,
        helperText: help,
        suffixText: suffix,
        suffixIcon: suffixIcon,
        counterText: counter,
        prefixText: prefix != null ? "$prefix  " : null,
        prefixIcon: prefixIcon,
        filled: true,
        hintText: hint,
        hintMaxLines: 3,
        hintStyle: TextStyle(color: ThemeData().hintColor, fontSize: 10),
        icon: outterIcon,
      ),
    );
  }
}
