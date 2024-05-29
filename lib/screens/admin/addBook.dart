import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/functions/alertDialog.dart';
import 'package:final_project/models/Book.dart';
import 'package:final_project/models/User.dart';
import 'package:final_project/widgets/wBackHeader.dart';
import 'package:final_project/widgets/wCustomWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController autorController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  final db = FirebaseFirestore.instance;

  static const String errorTitle= 'Error al agregar libro';

  @override
  void initState() {
    super.initState();

    if(FirebaseAuth.instance.currentUser == null){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/login");
      });
    }
    checkIsAdmin();
  }

  checkIsAdmin() async {
    DocumentSnapshot  querySnapshot = await db.collection('usuarios').doc(FirebaseAuth.instance.currentUser?.email).get();
    UserModel userFetched = UserModel.fromDocument(querySnapshot);
    if(!userFetched.isAdmin){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/");
      });
    }
  }

  _register() async {
      //showAlertDialog(context, title: 'Error', content: 'Login error');
      if (!addBasicCheck()) {
        return;
      }
      print('register');
      try {
        BookModel bookModel = BookModel(titulo: titleController.text,
          autor: autorController.text,
          desc: descController.text,
          year: int.tryParse(yearController.text)
        );
        db.collection('libros').add(bookModel.toJson());
        showAlertDialog(context, title: 'Registrado', content: 'Libro registrado con exito');
        Navigator.pushNamed(context, '/');
      } on FirebaseAuthException catch (e) {
        showAlertDialog(context, title: errorTitle, content: e.code);
      }catch (e) {
        print(e);
        showAlertDialog(context, title: 'Error', content: errorTitle);
      }
    }

  bool addBasicCheck(){
    if (titleController.text.trim() == '') {
      showAlertDialog(context, title: errorTitle, content: 'Debe ingresar un titulo para el registro');
      return false;
    }
    if (autorController.text.trim() == '') {
        showAlertDialog(context, title: errorTitle, content: 'Debe ingresar un autor para el registro');
        return false;
    }
    if (yearController.text.trim() == '') {
      showAlertDialog(context, title: errorTitle, content: 'Debe ingresar un año para el registro');
      return false;
    }
    if (int.tryParse(yearController.text) == null) {
      showAlertDialog(context, title: errorTitle, content: 'Debe ingresar un valor numerico para el año');
      return false;
    }
    if (descController.text.trim() == '') {
        showAlertDialog(context, title: errorTitle, content: 'Debe ingresar una descripcion para el registro');
        return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: WBackHeader(child:Padding(padding: EdgeInsets.only(top: 70, 
          left: MediaQuery.of(context).size.width / 10, right: MediaQuery.of(context).size.width / 10), 
          child: Center(
        child: Column(children: [
        const Text('Crear libro', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 60),
        WCustomTextField(controller: titleController, hintText: 'Titulo'),
        const SizedBox(height: 10),
        WCustomTextField(controller: autorController, hintText: 'Autor'),
        const SizedBox(height: 10),
        WCustomTextField(controller: yearController, hintText: 'Año', keyboardType: TextInputType.number,),
        const SizedBox(height: 10),
        WCustomTextField(controller: descController, maxLines: 3, hintText: 'Descripcion'),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: _register, child: const Text('Agregar')),
      ])
      ))
    ));
  }
}