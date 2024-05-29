import 'package:final_project/models/User.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WHomeHeader extends StatelessWidget {
  final UserModel user;
  const WHomeHeader(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(onPressed: () => Navigator.of(context).pushNamed("/profile"), icon: const Icon(Icons.person, size: 50,)),
        user.isAdmin ? SizedBox(child: user.isAdmin ? IconButton(onPressed: () => Navigator.of(context).pushNamed("/book/add"), icon: const Icon(Icons.add, size: 50,)) : null) : const SizedBox()
      ],
    ));
  }
}