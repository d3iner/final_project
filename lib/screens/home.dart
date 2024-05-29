import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/Book.dart';
import 'package:final_project/models/User.dart';
import 'package:final_project/widgets/wBookCard.dart';
import 'package:final_project/widgets/wHomeHeader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var userSesion = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  
  List<BookModel> books = <BookModel>[];
  UserModel user = UserModel();

  @override
  void initState() {
    super.initState();
    fetchBooks();
    getUser();

    if(FirebaseAuth.instance.currentUser == null){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed("/login");
      });
    }
  }

  Future<void> fetchBooks() async {
    try {
      QuerySnapshot querySnapshot = await db.collection('libros').get();
      List<BookModel> loadedBooks = querySnapshot.docs.map((doc) => BookModel.fromDocument(doc)).toList();
      setState(() {
        books = loadedBooks;
      });
    } catch (e) {
      print('Error fetching books: $e');
    }
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

  changeStatus(BookModel book) async {
    try {
      final batch = db.batch();
      var userRef = db.collection('usuarios').doc(userSesion?.email);
      var bookRef = db.collection('libros').doc(book.docId);
      List<BookModel> newBooks = books.map((e) => e.docId != book.docId ? e : 
      BookModel(id: book.id, autor: book.autor, desc: book.desc, disponible: !book.disponible,
      docId: book.docId, titulo: book.titulo, year: book.year)).toList();
      List<dynamic> newBooksForUser = user.gotBooks;
      if (book.disponible) {
        newBooksForUser.add(book.id);
      } else {
        newBooksForUser.remove(book.id);
      }
      UserModel newUser = UserModel(email: user.email, id: user.id, isAdmin: user.isAdmin, lastName: user.lastName, name: user.name,
      gotBooks: newBooksForUser
      );
      batch.update(userRef, {'gotBooks': newBooksForUser});
      batch.update(bookRef, {'disponible':!book.disponible});
      batch.commit();
      setState(() {
        books = newBooks;
        user = newUser;
      });
    } catch (e) {
      print('Error saving rent: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (BuildContext context, int index) {
                    BookModel book = books[index];
                    var status = books[index].disponible ? 'available' : 
                    user.gotBooks.contains(books[index].id) ? 'yours' : 'others';
                    if (index == 0) {
                      return Column(children: [
                        WHomeHeader(user),
                        WBookCard(
                            title: books[index].titulo ?? '',
                            author: books[index].autor ?? '',
                            description: books[index].desc ?? '',
                            year: books[index].year,
                            id: books[index].docId,
                            status: status,
                            onPressed: (){
                              changeStatus(book);
                            }, 
                            )
                      ]);
                    } else {
                      return WBookCard(
                          title: books[index].titulo ?? '',
                          author: books[index].autor ?? '',
                          description: books[index].desc ?? '',
                          year: books[index].year,
                          id: books[index].docId,
                          status: status,
                          onPressed: (){
                            changeStatus(book);
                          },
                          );
                    }
                  }))
        ],
      ),
    );
  }
}
