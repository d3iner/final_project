import 'package:final_project/functions/alertDialog.dart';
import 'package:final_project/widgets/authButton.dart';
import 'package:final_project/widgets/authText.dart';
import 'package:final_project/widgets/centralContainer.dart';
import 'package:final_project/widgets/wCustomWidget.dart';
import 'package:final_project/widgets/wPressableText.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  @override
  void initState() {
    super.initState();

    if(FirebaseAuth.instance.currentUser != null){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    

    login() async {
      //showAlertDialog(context, title: 'Error', content: 'Login error');
      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
        Navigator.pushNamed(context, '/');
      } on FirebaseAuthException catch (e) {
        showAlertDialog(context, title: 'Error de ingreso', content: e.code);
      }catch (e) {
        print(e);
        showAlertDialog(context, title: 'Error', content: 'Error de ingreso');
      }
    }

    return Scaffold(
      body: CentralContainer(
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height /2.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthText('Login'),
          const SizedBox(height: 10),
          WCustomTextField(controller: emailController, hintText: 'Email',),
          const SizedBox(height: 10),
          WCustomTextField(controller: passwordController, obscureText: true, hintText: 'Contraseña',),
          const SizedBox(height: 10),
          AuthButton('Login', onPressed: login),
          const SizedBox(height: 10),
          WPressableText('Registrate', onTap: () {
            Navigator.pushNamed(context, '/register');
          },)
        ],
      ))
    );
  }
}

