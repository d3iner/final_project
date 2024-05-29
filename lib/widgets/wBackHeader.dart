import 'package:flutter/material.dart';

class WBackHeader extends StatelessWidget {
  final void Function()? onPressed;
  final Widget? child;
  const WBackHeader({this.onPressed, this.child = const SizedBox(height: 50,), super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(left: 0, top: 10, child: IconButton(
          onPressed:  onPressed ?? (){
            Navigator.of(context).pop();
          }, icon: const Icon(Icons.arrow_back, size: 25,))),
        Center(child: Padding(padding: const EdgeInsets.only(top: 20), child: child))
      ],
    );
  }
}