import 'package:flutter/material.dart';

class CentralContainer extends StatelessWidget {

  final Widget? child;
  final double? width;
  final double? height;

  const CentralContainer({this.child, this.height, this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 30),
        width: width,
        height: height,
        decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.green), borderRadius: BorderRadius.circular(height! / 10)),
        child: child
      )
      );
  }
}