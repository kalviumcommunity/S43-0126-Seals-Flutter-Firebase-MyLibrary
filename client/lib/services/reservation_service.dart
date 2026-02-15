import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> expireStaleReservations() async {
  final now = Timestamp.now();

  final query = await _db
      .collection('reservations')
      .where('status', isEqualTo: 'reserved')
      .where('expiresAt', isLessThan: now)
      .get();

  for (final doc in query.docs) {
    await doc.reference.update({
      'status': 'expired',
      'expiredAt': Timestamp.now(),
    });
  }
}


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

  Future<void> issueBook({required String reservationId}) async {
    final isAdmin = await _isAdmin();
    if (!isAdmin) {
      throw Exception('Only admin can issue books');
    }

    final reservationRef = FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservationId);

    final now = Timestamp.now();
    final dueAt = Timestamp.fromMillisecondsSinceEpoch(
      now.millisecondsSinceEpoch + Duration(days: 14).inMilliseconds,
    );

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snap = await transaction.get(reservationRef);
      final data = snap.data();

      if (data == null) {
        throw Exception('Reservation not found');
      }

      if (data['status'] != 'reserved') {
        throw Exception('Only reserved books can be issued');
      }

      final String bookId = data['bookId'];
      final bookRef = FirebaseFirestore.instance
          .collection('books')
          .doc(bookId);
      final bookSnap = await transaction.get(bookRef);
      final int availableCopies = bookSnap['availableCopies'];

      // hold the book
      transaction.update(bookRef, {
        'availableCopies': availableCopies - 1,
      });

      // create reservation (NOT issued yet)
      transaction.update(reservationRef, {
        'status': 'issued',
        'issuedAt': now,
        'dueAt': dueAt,
      });
    });
  }

  Future<void> approveReturn({required String reservationId}) async {
    final isAdmin = await _isAdmin();
    if (!isAdmin) {
      throw Exception('Only admin can approve returns');
    }

    final reservationRef = FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservationId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final reservationSnap = await transaction.get(reservationRef);
      final data = reservationSnap.data();

      if (data == null) {
        throw Exception('Reservation not found');
      }

      final String bookId = data['bookId'];

      final bookRef = FirebaseFirestore.instance
          .collection('books')
          .doc(bookId);

      final bookSnap = await transaction.get(bookRef);
      final int availableCopies = bookSnap['availableCopies'];

      // increment inventory
      transaction.update(bookRef, {'availableCopies': availableCopies + 1});

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

  final now = Timestamp.now();
  final expiresAt = Timestamp.fromMillisecondsSinceEpoch(
    now.millisecondsSinceEpoch + const Duration(hours: 24).inMilliseconds,
  );

  try {
    await _db.runTransaction((transaction) async {
      final bookSnap = await transaction.get(bookRef);
      final int availableCopies = bookSnap['availableCopies'];

      if (availableCopies <= 0) {
        throw Exception('No copies available');
      }

      transaction.set(reservationRef, {
        'userId': user.uid,
        'bookId': bookId,
        'bookTitle': bookTitle,
        'status': 'reserved',
        'reservedAt': now,
        'expiresAt': expiresAt,
      });
    });
  } catch (e) {
    rethrow; // 🔥 REQUIRED for UX feedback
  }
}


  Stream<QuerySnapshot> myReservations() {
    final user = _auth.currentUser;
    return _db
        .collection('reservations')
        .where('userId', isEqualTo: user!.uid)
        .snapshots();
  }
}
