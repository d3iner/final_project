import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/Book.dart';
import 'package:final_project/models/User.dart';
import 'package:final_project/widgets/wBackHeader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {

  List<UserModel> users = <UserModel>[];

  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    if(FirebaseAuth.instance.currentUser == null){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/login");
      });
    }

    checkIsAdmin();

    fetchUsers();
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

  Future<void> fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await db.collection('usuarios').get();
      List<UserModel> loadedUsers = querySnapshot.docs.map((doc) => UserModel.fromDocument(doc)).toList();
      setState(() {
        users = loadedUsers;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WBackHeader(child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index){

            if (index == 0) {
              return Column(crossAxisAlignment: CrossAxisAlignment.stretch ,children: [
                const SizedBox(height: 40,),
                const Center(child: Text('Usuarios', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),)),
                const SizedBox(height: 20,),
                UserCard(users[index])
              ],);
            }
            return UserCard(users[index]);
          }
        ),),
    );
  }
}

class UserCard extends StatefulWidget {
  final UserModel user;
  const UserCard(this.user, {super.key});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {

  var userSesion = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;

  bool actualState = false;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        actualState = widget.user.isAdmin;
      });
    });
  }


  changeStatus(bool? e) async {
    try {
      final batch = db.batch();
      var userRef = db.collection('usuarios').doc(widget.user.email);
      batch.update(userRef, {'isAdmin': e});
      batch.commit();
      setState(() {
        actualState = e!;
      });
    } catch (e) {
      print('Error saving rent: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: 300, height: 100, 
      decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadiusDirectional.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
      Text(widget.user.email ?? ''),
      Row(children: [
        const Text('Admin'),
        Checkbox(tristate: false, value: actualState, onChanged: changeStatus)
      ],)
    ],),);
  }
}