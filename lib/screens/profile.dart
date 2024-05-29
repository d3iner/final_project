import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/functions/alertDialog.dart';
import 'package:final_project/models/User.dart';
import 'package:final_project/widgets/wBackHeader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var userSesion = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  UserModel? user = null;

  @override
  void initState() {
    super.initState();

    getUser();

    if (FirebaseAuth.instance.currentUser == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/login");
      });
    }
  }

  Future<void> getUser() async {
    try {
      var email = userSesion?.email;
      DocumentSnapshot querySnapshot =
          await db.collection('usuarios').doc(email).get();
      UserModel userFetched = UserModel.fromDocument(querySnapshot);
      setState(() {
        user = userFetched;
      });
    } catch (e) {
      showAlertDialog(context, title: 'Error', content: 'Error obteniendo el usuario');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), 
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const WBackHeader(
              child: Text(
            'Perfil',
            style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 75,
              child: Image.asset('lib/assets/user.png'),
            ),
          ),
          user == null ? const Center(child: CircularProgressIndicator()) : Column(
            children: [
            ProfileItem(keyValue: 'Nombre', value: user?.name),
            ProfileItem(keyValue: 'Nombre', value: user?.lastName),
            ProfileItem(keyValue: 'Nombre', value: user?.email),
            ProfileItem(keyValue: 'Rol', value: user!.isAdmin ? 'Admin' : 'User'),
            const SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamed("/login");
            }, child: const Text('Log out'))
          ],)
        ],
      ),)
    ]));
  }
}

class ProfileItem extends StatelessWidget {
  final String? keyValue;
  final String? value;
  const ProfileItem({this.keyValue, this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 5), child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
      Padding(padding: const EdgeInsets.only(left: 10), child: Text(keyValue!, style: const TextStyle(fontSize: 14),),),
      Container(height: 40, 
      margin: const EdgeInsets.only(top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey.shade200),
      child: Row(children: [
        Text(value!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),)
      ],),)
    ],),);
  }
}