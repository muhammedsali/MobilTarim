import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'alarm_history_screen.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  final List<String> days = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"];
  final random = Random();

  List<FlSpot> tempData = [];
  List<FlSpot> humidityData = [];
  List<FlSpot> lightData = [];

  final List<String> alarmHistory = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    generateFakeData();
    startSimulation();
  }

  void generateFakeData() {
    tempData = List.generate(7, (i) => FlSpot(i.toDouble(), 20 + random.nextInt(10).toDouble()));
    humidityData = List.generate(7, (i) => FlSpot(i.toDouble(), 40 + random.nextInt(30).toDouble()));
    lightData = List.generate(7, (i) => FlSpot(i.toDouble(), 60 + random.nextInt(30).toDouble()));
    setState(() {});
  }

  void startSimulation() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 4));
      generateFakeData();
      return true;
    });
  }

  double minFn(double a, double b) => a < b ? a : b;
  double maxFn(double a, double b) => a > b ? a : b;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Veri Grafikleri"),
          actions: [
            IconButton(
              icon: const Icon(Icons.history),
              tooltip: "Alarm Geçmişi",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AlarmHistoryScreen(alarms: alarmHistory),
                  ),
                );
              },
            )
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Sıcaklık"),
              Tab(text: "Nem"),
              Tab(text: "Işık"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            buildChart(tempData, Colors.red, "Sıcaklık"),
            buildChart(humidityData, Colors.blue, "Nem"),
            buildChart(lightData, Colors.amber, "Işık"),
          ],
        ),
      ),
    );
  }

  Widget buildChart(List<FlSpot> data, Color color, String label) {
    double min = data.map((e) => e.y).reduce(minFn);
    double max = data.map((e) => e.y).reduce(maxFn);
    double avg = data.map((e) => e.y).reduce((a, b) => a + b) / data.length;

    bool isAlarm = (label == "Sıcaklık" && max > 28) ||
        (label == "Nem" && min < 45) ||
        (label == "Işık" && max > 90);

    if (isAlarm) {
      final now = DateTime.now().toLocal().toString().substring(0, 19);
      final alarmText = "$now • $label alarmı";
      if (!alarmHistory.contains(alarmText)) {
        alarmHistory.add(alarmText);
      }
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 100,
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final index = value.toInt();
                        if (value % 1 != 0 || index < 0 || index >= days.length) {
                          return const SizedBox.shrink();
                        }
                        return Center(
                          child: Text(
                            days[index],
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, interval: 20),
                  ),
                  topTitles: AxisTitles(),
                  rightTitles: AxisTitles(),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: data,
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (spots) => spots.map((spot) {
                      return LineTooltipItem(
                        "$label\n${spot.y.toStringAsFixed(1)}",
                        const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _summaryBox("Min", min),
              _summaryBox("Ort", avg),
              _summaryBox("Max", max),
            ],
          ),
        ),
        if (isAlarm)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              "$label verisi tehlikeli aralıkta!",
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }

  Widget _summaryBox(String label, double value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value.toStringAsFixed(1),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
