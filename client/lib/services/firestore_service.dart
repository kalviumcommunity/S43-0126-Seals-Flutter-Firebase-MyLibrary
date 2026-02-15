import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Book>> getBooks() {
    return _db.collection('books').snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => Book.fromFirestore(doc))
          .toList(),
    );
  }
}
