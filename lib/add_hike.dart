import 'package:flutter/material.dart';

class AddHike extends StatelessWidget {
  const AddHike({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Scaffold(
        body: Center(child: Text("Add a hike")),
      ),
    );
  }
}