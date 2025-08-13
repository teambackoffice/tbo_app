import 'package:flutter/material.dart';

class CRMProfilePage extends StatelessWidget {
  const CRMProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CRM Profile'), backgroundColor: Colors.blue),
      body: Center(child: Text('Welcome to the CRM Profile Page!')),
    );
  }
}
