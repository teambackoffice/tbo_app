import 'package:flutter/material.dart';

class AdminToDoDetails extends StatelessWidget {
  const AdminToDoDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('todo Details')),
      body: Center(child: Text('This is the todo details page.')),
    );
  }
}
