import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:passport_university_for_unsa/screens/update_data_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  String? futureCodeStudent = '';

  void getCodeStudentStore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      futureCodeStudent = prefs.getString('storeCodeStudent') ?? '';
    });
  }

  @override
  void initState() {
    getCodeStudentStore();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Passport University')),
      ),
      body: Column(
        children: [
          const Expanded(
              child: FittedBox(
                  child:
                      Icon(Icons.camera_front_rounded, color: Colors.indigo))),
          ElevatedButton.icon(
              onPressed: () async {
                futureCodeStudent = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateDataScreen()),
                );
                // obtain shared preferences
                if (futureCodeStudent != null) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('storeCodeStudent', futureCodeStudent!);
                  setState(() {
                    futureCodeStudent;
                  });
                }
              },
              icon: const Icon(Icons.create),
              label: const Text("Crear mi pasaporte")),
          BarcodeWidget(
              padding: const EdgeInsets.all(20),
              height: 100.0,
              barcode: Barcode.code39(),
              data: futureCodeStudent ?? '',
              errorBuilder: (context, error) => Center(
                      child: RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Aqui estara ",
                          style: TextStyle(color: Colors.black),
                        ),
                        WidgetSpan(
                          child: Icon(
                            Icons.card_membership,
                            size: 20,
                            color: Colors.blue,
                          ),
                        ),
                        TextSpan(
                          text: " tu codigo de barras",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  )))
        ],
      ),
    );
  }
}
