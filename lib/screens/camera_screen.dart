import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  final String streamUrl = 'http://10.39.15.33:8888'; // Raspberry Pi IP adresi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Canlı Kamera'),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Mjpeg(
              stream: streamUrl,
              isLive: true,
              timeout: const Duration(seconds: 5),
            ),
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(0, 0, 0, 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.videocam, color: Colors.greenAccent, size: 20),
                  SizedBox(width: 6),
                  Text(
                    "Canlı Yayın Aktif",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
