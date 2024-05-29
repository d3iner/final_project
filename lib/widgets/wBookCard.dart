import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/Book.dart';
import 'package:final_project/models/User.dart';
import 'package:final_project/screens/bookDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WBookCard extends StatelessWidget {
  final String title;
  final String author;
  final String description;
  final int? year;
  final String? id;
  final String status;
  final void Function()? onPressed;
  const WBookCard({this.title = '', this. author = '', this. description = '', this.year, this.id,
  this.status = 'available', required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    
    Map<String, Color> colors = {
      'available': Colors.green,
      'yours': Colors.yellow,
      'others': Colors.red,
    };

    Map<String, String> textBottom = {
      'available': 'Rentar',
      'yours': 'Devolver',
      'others': 'No disponible',
    };

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          Text(
            '$author - $year',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w100),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                    onPressed: status == 'others' ? null : onPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors[status]
                    ),
                    child: Text(textBottom[status]!, style: const TextStyle(color: Colors.white),)),
              ),
              const SizedBox(height: 5,),
              InkWell(onTap: (){
                Navigator.of(context).pushNamed('/book', arguments: BookDetailsArguments(
                  book: BookModel(id: int.tryParse(id!), desc: description, autor: author, 
                  disponible: status == 'available', titulo: title, year: year, docId: id )
                ));
              }, 
              child: const Center(child: Text('See more', style: TextStyle(color: Colors.blueAccent, fontSize: 12),),),)
            ],
          )
        ]));
  }
}
