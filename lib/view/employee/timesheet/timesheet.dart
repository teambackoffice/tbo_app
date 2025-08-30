import 'package:flutter/material.dart';

class Timesheet extends StatelessWidget {
  const Timesheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Timesheet')),
      body: Center(child: Text('Timesheet content goes here')),
    );
  }
}
