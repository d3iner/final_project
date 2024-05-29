import 'package:flutter/material.dart';

class WPressableText extends StatelessWidget {
  final String data;
  final Function()? onTap;

  const WPressableText(this.data, { this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: Text(data, style: const TextStyle(color: Colors.green),),
    );
  }
}