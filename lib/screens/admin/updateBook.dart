import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/functions/alertDialog.dart';
import 'package:final_project/models/Book.dart';
import 'package:final_project/models/User.dart';
import 'package:final_project/widgets/wBackHeader.dart';
import 'package:final_project/widgets/wCustomWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class UpdateBookArguments{
  BookModel? book;
  UpdateBookArguments({this.book});
}

class UpdateBook extends StatefulWidget {
  const UpdateBook({super.key});

  @override
  State<UpdateBook> createState() => _UpdateBookState();
}

class _UpdateBookState extends State<UpdateBook> {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController autorController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  
  UpdateBookArguments? args;

  final db = FirebaseFirestore.instance;

  static const String errorTitle= 'Error al editar el libro';

  @override
  void initState() {
    super.initState();

    if(FirebaseAuth.instance.currentUser == null){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/login");
      });
    }
    
    checkIsAdmin();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        args = ModalRoute.of(context)!.settings.arguments as UpdateBookArguments;
      });
      titleController.text=args?.book?.titulo ?? '';
      autorController.text=args?.book?.autor ?? '';
      yearController.text='${args?.book?.year}';
      descController.text=args?.book?.desc ?? '';
    });
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
        BookModel? book = args?.book;
        final batch = db.batch();
        var bookRef = db.collection('libros').doc(book?.docId);
        batch.update(bookRef, {
          'titulo': titleController.text,
          'autor': autorController.text,
          'desc': descController.text,
          'year': int.tryParse(yearController.text)
        });
        batch.commit();
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
      showAlertDialog(context, title: errorTitle, content: 'Debe ingresar un titulo para la edicion');
      return false;
    }
    if (autorController.text.trim() == '') {
        showAlertDialog(context, title: errorTitle, content: 'Debe ingresar un autor para la edicion');
        return false;
    }
    if (yearController.text.trim() == '') {
      showAlertDialog(context, title: errorTitle, content: 'Debe ingresar un año para la edicion');
      return false;
    }
    if (int.tryParse(yearController.text) == null) {
      showAlertDialog(context, title: errorTitle, content: 'Debe ingresar un valor numerico para el año');
      return false;
    }
    if (descController.text.trim() == '') {
        showAlertDialog(context, title: errorTitle, content: 'Debe ingresar una descripcion para la edicion');
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
        const Text('Edicion del libro', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 60),
        WCustomTextField(controller: titleController, hintText: 'Titulo'),
        const SizedBox(height: 10),
        WCustomTextField(controller: autorController, hintText: 'Autor'),
        const SizedBox(height: 10),
        WCustomTextField(controller: yearController, hintText: 'Año', keyboardType: TextInputType.number,),
        const SizedBox(height: 10),
        WCustomTextField(controller: descController, maxLines: 3, hintText: 'Descripcion'),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: _register, child: const Text('Editar')),
      ])
      ))
    ));
  }
}