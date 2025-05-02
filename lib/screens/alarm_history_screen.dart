import 'package:flutter/material.dart';

class AlarmHistoryScreen extends StatelessWidget {
  final List<String> alarms;
  const AlarmHistoryScreen({super.key, required this.alarms});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Alarm Geçmişi")),
      body: alarms.isEmpty
          ? const Center(child: Text("Henüz alarm kaydı yok."))
          : ListView.builder(
              itemCount: alarms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.warning, color: Colors.red),
                  title: Text(alarms[index]),
                );
              },
            ),
    );
  }
}
