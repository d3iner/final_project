import 'package:flutter/material.dart';

class WCustomTextField extends StatefulWidget {
    final TextEditingController controller;
    final String hintText;
    final int? maxLines;
    final TextInputType? keyboardType;
    final bool obscureText;
    final bool enableSuggestions;
    final bool autocorrect;
    const WCustomTextField(
        {required this.controller, this.hintText = '', this.maxLines, this.keyboardType,
        this.obscureText = false, this.enableSuggestions = true, this.autocorrect=true, super.key});
  
    @override
    State<WCustomTextField> createState() => _WCustomTextFieldState();
  }
  
  class _WCustomTextFieldState extends State<WCustomTextField> {
    @override
    Widget build(BuildContext context) {
      return TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          enableSuggestions: widget.enableSuggestions,
          autocorrect: widget.autocorrect,
          decoration: InputDecoration(
              hintText: widget.hintText,
              border:
                  const OutlineInputBorder(borderSide: BorderSide(width: 1))));
    }
  }
