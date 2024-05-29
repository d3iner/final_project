import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  String? docId;
  String? titulo;
  String? desc;
  String? autor;
  bool disponible;
  int? id;
  int? year;

  BookModel(
      {
      this.docId,
      this.titulo = '',
      this.desc = '',
      this.autor = '',
      this.disponible = true,
      this.id = 0,
      this.year
      });

  BookModel.fromJson(Map<String, dynamic> json)
      : titulo = json['titulo'] as String,
        desc = json['desc'] as String,
        autor = json['autor'] as String,
        disponible = json['disponible'] as bool,
        id = json['id'] as int,
        year = json['year'] as int;

  Map<String, dynamic> toJson() => {
        'titulo': titulo,
        'desc': desc,
        'autor': autor,
        'disponible': disponible,
        'id': id,
        'year': year
      };
  factory BookModel.fromDocument(DocumentSnapshot doc) {
    return BookModel(
      docId: doc.id,
      titulo: doc['titulo'],
      desc: doc['desc'],
      autor: doc['autor'],
      disponible: doc['disponible'] as bool,
      id: doc['id'] as int,
      year: doc['year'] as int,
    );
  }

}
