import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Canlı Kamera Yayını")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Kamera Görüntüsü", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                "https://10.131.159.6:8080/",// ÖRNEK IP – okulda değiştireceksin
                width: 300,
                height: 200,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    "Görüntü yüklenemedi.\nKamera bağlantısı yok.",
                    textAlign: TextAlign.center,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
