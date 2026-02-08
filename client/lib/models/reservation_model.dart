import 'package:cloud_firestore/cloud_firestore.dart';

enum ReservationStatus {
  active,
  returnRequested,
  returnApproved,
  completed,
}

class Reservation {
  final String id;
  final String userId;
  final String bookId;
  final String bookTitle;
  final ReservationStatus status;
  final Timestamp reservedAt;
  final Timestamp? returnRequestedAt;
  final Timestamp? approvedAt;

  Reservation({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.bookTitle,
    required this.status,
    required this.reservedAt,
    this.returnRequestedAt,
    this.approvedAt,
  });

  factory Reservation.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Reservation(
      id: doc.id,
      userId: data['userId'],
      bookId: data['bookId'],
      bookTitle: data['bookTitle'],
      status: _statusFromString(data['status']),
      reservedAt: data['reservedAt'],
      returnRequestedAt: data['returnRequestedAt'],
      approvedAt: data['approvedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bookId': bookId,
      'bookTitle': bookTitle,
      'status': status.name,
      'reservedAt': reservedAt,
      'returnRequestedAt': returnRequestedAt,
      'approvedAt': approvedAt,
    };
  }

  static ReservationStatus _statusFromString(String value) {
    return ReservationStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ReservationStatus.active,
    );
  }
}
