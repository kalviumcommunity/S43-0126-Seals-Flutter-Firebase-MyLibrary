import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/reservation_service.dart';

class AdminIssueBooksScreen extends StatefulWidget {
  const AdminIssueBooksScreen({super.key});

  @override
  State<AdminIssueBooksScreen> createState() =>
      _AdminIssueBooksScreenState();
}

class _AdminIssueBooksScreenState extends State<AdminIssueBooksScreen> {
  final ReservationService _reservationService = ReservationService();

  String? _issuingReservationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issue Books'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('reservations')
            .where('status', isEqualTo: 'reserved')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No pending reservations',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final reservations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              final doc = reservations[index];
              final data = doc.data() as Map<String, dynamic>;

              final reservationId = doc.id;
              final bookTitle = data['bookTitle'] ?? 'Unknown Book';
              final userId = data['userId'] ?? 'Unknown User';

              final Timestamp? reservedAt = data['reservedAt'];

              final bool isLoading =
                  _issuingReservationId == reservationId;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    bookTitle,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('User ID: $userId'),
                      const SizedBox(height: 4),
                      Text(
                        reservedAt == null
                            ? 'Reserved at: unknown'
                            : 'Reserved at: ${reservedAt.toDate()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              setState(() {
                                _issuingReservationId = reservationId;
                              });

                              try {
                                await _reservationService.issueBook(
                                  reservationId: reservationId,
                                );

                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('✅ Book issued successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    _issuingReservationId = null;
                                  });
                                }
                              }
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Issue'),
                    ),
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
