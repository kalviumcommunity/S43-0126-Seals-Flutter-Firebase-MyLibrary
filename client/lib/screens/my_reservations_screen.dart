import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/reservation_service.dart';

class MyReservationsScreen extends StatelessWidget {
  const MyReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    final service = ReservationService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Activity'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: service.myReservations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No activity yet',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final reservations = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final doc = reservations[index];
              final data = doc.data() as Map<String, dynamic>;

              final status = data['status'] as String;
              final bookTitle = data['bookTitle'] ?? 'Unknown Book';

              final Timestamp? issuedAt = data['issuedAt'];
              final Timestamp? dueAt = data['dueAt'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 📘 BOOK TITLE
                      Text(
                        bookTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // 🏷 STATUS CHIP
                      _StatusChip(status: status),

                      const SizedBox(height: 12),

                      // ⏳ TIMELINE INFO
                      if (status == 'issued' && dueAt != null)
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'Due: ${dueAt.toDate().toLocal()}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),

                      if (status == 'returnRequested')
                        const Text(
                          'Waiting for admin approval',
                          style: TextStyle(color: Colors.orange),
                        ),

                      if (status == 'completed')
                        const Text(
                          'Book returned successfully',
                          style: TextStyle(color: Colors.green),
                        ),

                      if (status == 'expired')
                        const Text(
                          'Reservation expired',
                          style: TextStyle(color: Colors.red),
                        ),

                      // 🔘 RETURN BUTTON (ONLY WHEN ISSUED)
                      if (status == 'issued')
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            icon: const Icon(Icons.assignment_return),
                            label: const Text('Request Return'),
                            onPressed: () async {
                              await service.requestReturn(
                                reservationId: doc.id,
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Return request sent',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    late Color color;
    late String label;

    switch (status) {
      case 'reserved':
        color = Colors.amber;
        label = 'Reserved';
        break;
      case 'issued':
        color = Colors.blue;
        label = 'Issued';
        break;
      case 'returnRequested':
        color = Colors.orange;
        label = 'Return Requested';
        break;
      case 'completed':
        color = Colors.green;
        label = 'Completed';
        break;
      case 'expired':
        color = Colors.red;
        label = 'Expired';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Chip(
      label: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }
}