import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/Book.dart';
import 'package:final_project/models/User.dart';
import 'package:final_project/screens/admin/updateBook.dart';
import 'package:final_project/widgets/wBackHeader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class BookDetailsArguments{
  BookModel? book;
  BookDetailsArguments({this.book});
}

class BookDetails extends StatefulWidget {
  const BookDetails({super.key});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
  
  var userSesion = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  
  UserModel user = UserModel();
  
  BookDetailsArguments? args;

  @override
  void initState() {
    super.initState();

    getUser();

    if(FirebaseAuth.instance.currentUser == null){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/login");
      });
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        args = ModalRoute.of(context)!.settings.arguments as BookDetailsArguments;
      });
    });
  }

  Future<void> getUser() async {
    try {
      var email = userSesion?.email;
      DocumentSnapshot  querySnapshot = await db.collection('usuarios').doc(email).get();
      UserModel userFetched = UserModel.fromDocument(querySnapshot);
      setState(() {
        user = userFetched;
      });
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        WBackHeader(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        const SizedBox(height: 20),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text(args?.book?.titulo ?? '', textAlign: TextAlign.center, 
        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),),),
        Text('${args?.book?.autor} - ${args?.book?.year}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w100)),
        Container(width: MediaQuery.of(context).size.width / 1.3,
        color: Colors.grey.shade200, 
        margin: const EdgeInsets.symmetric(vertical: 30),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Text(args?.book?.desc ?? '', style: const TextStyle(color: Colors.black), 
        textAlign: TextAlign.justify,),
        ),
        user.isAdmin ? ElevatedButton(onPressed: (){
          Navigator.of(context).pushNamed('/book/update', arguments: UpdateBookArguments(book: args?.book));
        }, child: const Text('Editar')) : const SizedBox()
      ],
    ),),)
      ],)
    );
  }
}