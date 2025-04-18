import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

class GuestListScreen extends ConsumerWidget {
  const GuestListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final token = ref.watch(authProvider);
    final guestsFuture = ApiService().getGuests(token!);

    return Scaffold(
      appBar: AppBar(title: const Text('Guest List')),
      body: FutureBuilder(
        future: guestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final guests = snapshot.data as List;
          return ListView.builder(
            itemCount: guests.length,
            itemBuilder: (context, index) {
              final guest = guests[index];
              return ListTile(
                title: Text('${guest['firstName']} ${guest['lastName']}'),
                subtitle: Text('Room: ${guest['roomNumber']} • Stay: ${guest['lengthOfStay']} days'),
              );
            },
          );
        },
      ),
    );
  }
}