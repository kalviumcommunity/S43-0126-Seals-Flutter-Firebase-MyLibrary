import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> reserveBook(String bookId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final bookRef = _db.collection('books').doc(bookId);
    final reservationRef = _db.collection('reservations').doc();

    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(bookRef);

      final int availableCopies = snapshot['availableCopies'];

      if (availableCopies <= 0) {
        throw Exception('No copies available');
      }

      transaction.update(bookRef, {'availableCopies': availableCopies - 1});

      transaction.set(reservationRef, {
        'userId': user.uid,
        'bookId': bookId,
        'reservedAt': FieldValue.serverTimestamp(),
        'status': 'active',
      });
    });
  }

  Stream<QuerySnapshot> myReservations() {
    final user = _auth.currentUser;
    return _db
        .collection('reservations')
        .where('userId', isEqualTo: user!.uid)
        .snapshots();
  }

  Future<void> returnBook({
    required String reservationId,
    required String bookId,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final bookRef = _db.collection('books').doc(bookId);
    final reservationRef = _db.collection('reservations').doc(reservationId);

    await _db.runTransaction((transaction) async {
      final bookSnapshot = await transaction.get(bookRef);

      final int availableCopies = bookSnapshot['availableCopies'];

      transaction.update(bookRef, {'availableCopies': availableCopies + 1});

      transaction.update(reservationRef, {
        'status': 'returned',
        'returnedAt': FieldValue.serverTimestamp(),
      });
    });
  }
}
