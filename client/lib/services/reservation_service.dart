import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> requestReturn({required String reservationId}) async {
    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservationId)
        .update({
          'status': 'returnRequested',
          'returnRequestedAt': Timestamp.now(),
        });
  }

  Future<bool> _isAdmin() async {
    final user = FirebaseAuth.instance.currentUser!;
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.data()?['role'] == 'admin';
  }

  Future<void> approveReturn({
  required String reservationId,
}) async {
  final isAdmin = await _isAdmin();
  if (!isAdmin) {
    throw Exception('Only admin can approve returns');
  }

  final reservationRef =
      FirebaseFirestore.instance.collection('reservations').doc(reservationId);

  await FirebaseFirestore.instance.runTransaction((transaction) async {
    final reservationSnap = await transaction.get(reservationRef);
    final data = reservationSnap.data();

    if (data == null) {
      throw Exception('Reservation not found');
    }

    final String bookId = data['bookId'];

    final bookRef =
        FirebaseFirestore.instance.collection('books').doc(bookId);

    final bookSnap = await transaction.get(bookRef);
    final int availableCopies = bookSnap['availableCopies'];

    // increment inventory
    transaction.update(bookRef, {
      'availableCopies': availableCopies + 1,
    });

    // complete reservation
    transaction.update(reservationRef, {
      'status': 'completed',
      'approvedAt': Timestamp.now(),
    });
  });
}


  Future<void> reserveBook({
    required String bookId,
    required String bookTitle,
  }) async {
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
        'bookTitle': bookTitle,
        'reservedAt': Timestamp.now(),
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

  
}
