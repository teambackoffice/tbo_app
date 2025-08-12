import 'package:flutter/material.dart';

class CompletedDetails extends StatelessWidget {
  const CompletedDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Completed Details')),
      body: Center(child: Text('This is the completed details screen.')),
    );
  }
}
