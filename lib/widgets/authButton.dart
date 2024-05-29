import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String data;
  final void Function()? onPressed;
  const AuthButton(this.data, {required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            data,
            style: const TextStyle(fontSize: 18),
          ),
        ));
  }
}
