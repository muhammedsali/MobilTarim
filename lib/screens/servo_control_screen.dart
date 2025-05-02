import 'package:flutter/material.dart';

class ServoControlScreen extends StatefulWidget {
  const ServoControlScreen({super.key});

  @override
  State<ServoControlScreen> createState() => _ServoControlScreenState();
}

class _ServoControlScreenState extends State<ServoControlScreen> {
  String status = "Manuel kontrol bekleniyor";
  bool isAutoMode = false;

  void updateDirection(String direction) {
    setState(() {
      status = "$direction yönüne gönderildi";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Güneş Paneli Kontrol")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Otomatik Takip Modu"),
              value: isAutoMode,
              onChanged: (val) {
                setState(() {
                  isAutoMode = val;
                  status =
                      isAutoMode ? "Otomatik mod aktif" : "Manuel mod aktif";
                });
              },
            ),
            const SizedBox(height: 16),
            if (!isAutoMode)
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => updateDirection("Yukarı"),
                        child: const Icon(Icons.arrow_upward),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => updateDirection("Sol"),
                        child: const Icon(Icons.arrow_back),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () => updateDirection("Sağ"),
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => updateDirection("Aşağı"),
                        child: const Icon(Icons.arrow_downward),
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 24),
            Text(status, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
