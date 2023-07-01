import 'package:flutter/material.dart';

import 'package:json_data/page_one.dart';
import 'package:json_data/page_two.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cambo Fx App',
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
              Tab(text: 'Tab 3'),
              Tab(text: 'Tab 4'),
            ]),
          ),
          body: const TabBarView(
            children: [
              PageOne(),
              PageTwo(),
              Text('page3'),
              Text('page4'),
            ],
          ),
        ),
      ),
    );
  }
}
