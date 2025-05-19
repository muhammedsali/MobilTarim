import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(const MaterialApp(
    home: BluetoothDataScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class BluetoothDataScreen extends StatefulWidget {
  const BluetoothDataScreen({super.key});

  @override
  State<BluetoothDataScreen> createState() => _BluetoothDataScreenState();
}

class _BluetoothDataScreenState extends State<BluetoothDataScreen> {
  BluetoothDevice? _device;
  String _data = "";

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    FlutterBluePlus.scanResults.listen((results) async {
      for (ScanResult r in results) {
        if (r.device.platformName == "HC-05") {
          FlutterBluePlus.stopScan();
          await _connectToDevice(r.device);
          break;
        }
      }
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      _device = device;
    });

    List<BluetoothService> services = await device.discoverServices();
    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.notify || characteristic.properties.read) {
          await characteristic.setNotifyValue(true);
          characteristic.lastValueStream.listen((value) {
            setState(() {
              _data += utf8.decode(value);
            });
          });
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _device?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bluetooth Veri Okuma"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _device != null
            ? SingleChildScrollView(
                child: Text(
                  _data,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            : const Center(child: Text("Bluetooth cihaz aranıyor...")),
      ),
    );
  }
}
