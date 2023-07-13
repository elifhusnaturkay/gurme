import 'package:flutter/material.dart';

enum EditPart {
  name,
  password;
}

class EditScreen extends StatefulWidget {
  const EditScreen({super.key, required this.editPart});
  final EditPart editPart;

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
    );
  }
}
