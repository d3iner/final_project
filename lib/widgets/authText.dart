import 'package:flutter/material.dart';

class AuthText extends StatelessWidget {
  final String data;
  const AuthText(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(data, style: const TextStyle(fontSize: 26));
  }
}