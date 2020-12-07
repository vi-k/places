import 'package:flutter/material.dart';

class SightListScreen extends StatefulWidget {
  @override
  _SightListScreenState createState() => _SightListScreenState();
}

class _SightListScreenState extends State<SightListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 128, // 40 + 72 + 16
        titleSpacing: 16, // отступы по-горизонтали
        title: const Padding(
          padding: EdgeInsets.only(top: 40, bottom: 16), // + 24 высота системного бара
          child: Text(
            'Список интересных мест',
            maxLines: 2,
            style: TextStyle(
              color: Color(0xFF3B3E5B),
              fontSize: 32,
              height: 1.125,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 200,
              color: const Color(0xFFF5F5F5),
              child: const Text('Card 1'),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              height: 200,
              color: const Color.fromARGB(0xff, 0xf5, 0xf5, 0xf5),
              child: const Text('Card 2'),
            ),
          ),
        ],
      ),
    );
  }
}
