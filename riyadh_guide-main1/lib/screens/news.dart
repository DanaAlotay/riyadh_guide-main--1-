import 'package:flutter/material.dart';

class news extends StatefulWidget {
  const news({super.key});

  @override
  State<news> createState() => _newsState();
}

class _newsState extends State<news> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('أحداث اليوم'),
          backgroundColor: Color.fromARGB(255, 228, 207, 254)),
      body: Center(child: Text('أحداث اليوم')),
    );
  }
}
