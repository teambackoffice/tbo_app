import 'package:flutter/material.dart';

class AdminCompletedDetails extends StatelessWidget {
  const AdminCompletedDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Completed Details')),
      body: Center(child: Text('This is the completed details page.')),
    );
  }
}
