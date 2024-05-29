import 'package:final_project/screens/admin/addBook.dart';
import 'package:final_project/screens/admin/updateBook.dart';
import 'package:final_project/screens/auth/login.dart';
import 'package:final_project/screens/auth/register.dart';
import 'package:final_project/screens/bookDetails.dart';
import 'package:final_project/screens/home.dart';
import 'package:final_project/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      initialRoute: '/login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent)
      ),
      routes: {
        '/login': (context) =>  const Login(),
        '/register': (context) =>  const Register(),
        '/': (context) => const Home(),
        '/profile': (context) => const Profile(),
        '/book/add': (context) => const AddBook(),
        '/book/update': (context) => const UpdateBook(),
        '/book': (context) => const BookDetails()
      },
    );
  }
}
