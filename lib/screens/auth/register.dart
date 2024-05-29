import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/functions/alertDialog.dart';
import 'package:final_project/models/User.dart';
import 'package:final_project/widgets/authButton.dart';
import 'package:final_project/widgets/authText.dart';
import 'package:final_project/widgets/centralContainer.dart';
import 'package:final_project/widgets/wCustomWidget.dart';
import 'package:final_project/widgets/wPressableText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatedController = TextEditingController();

  final currentUser = FirebaseAuth.instance.currentUser;

  static const String errorTitle= 'Error de registro';

  @override
  void initState() {
    super.initState();

    if(FirebaseAuth.instance.currentUser != null){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/");
      });
    }
  }

  _register() async {
      //showAlertDialog(context, title: 'Error', content: 'Login error');
      if (!registerBasicCheck()) {
        return;
      }
      try {
        var db = FirebaseFirestore.instance;
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
        var credentialUser = credential.user;
        UserModel user = UserModel(email: credentialUser?.email, 
        name: _firstNameController.text, lastName: _lastNameController.text,
        gotBooks: <int>[], id: credentialUser?.uid);
        db.collection('usuarios').doc(user.email).set(user.toJson());
        //await FirebaseAuth.instance.signInWithCredential(credential as AuthCredential);
        Navigator.pushNamed(context, '/');
      } on FirebaseAuthException catch (e) {
        showAlertDialog(context, title: errorTitle, content: e.code);
      }catch (e) {
        print(e);
        showAlertDialog(context, title: 'Error', content: errorTitle);
      }
    }

  bool registerBasicCheck(){
    if (_emailController.text.trim() == '') {
      showAlertDialog(context, title: errorTitle, content: 'Debe ingresar un email para el registro');
      return false;
    }
    if (_passwordController.text != _passwordRepeatedController.text) {
        showAlertDialog(context, title: errorTitle, content: 'Las contraseñas deben ser iguales');
        return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if(FirebaseAuth.instance.currentUser != null){
      print(FirebaseAuth.instance.currentUser);
    }
    return Scaffold(
      body: CentralContainer(
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height /1.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthText('Registro'),
          const SizedBox(height: 10),
          WCustomTextField(controller: _emailController, hintText: 'Email',),
          const SizedBox(height: 10),
          WCustomTextField(controller: _firstNameController, hintText: 'Nombre',),
          const SizedBox(height: 10),
          WCustomTextField(controller: _lastNameController, hintText: 'Apellido',),
          const SizedBox(height: 10),
          WCustomTextField(controller: _passwordController, obscureText: true, hintText: 'Contraseña',),
          const SizedBox(height: 10),
          WCustomTextField(controller: _passwordRepeatedController, obscureText: true, hintText: 'Repetir contraseña',),
          const SizedBox(height: 10),
          AuthButton('Registrarse', onPressed: _register),
          const SizedBox(height: 10),
          WPressableText('Si ya tienes cuenta, ingresa', onTap: () {
            Navigator.pushNamed(context, '/login');
          },)
        ],
      ))
    );
  }
}