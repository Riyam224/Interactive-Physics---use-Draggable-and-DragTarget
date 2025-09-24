import 'package:flutter/material.dart';
import 'package:physics_playground/home_view.dart';

void main() {
  runApp(const PhysicsPlayground());
}

class PhysicsPlayground extends StatelessWidget {
  const PhysicsPlayground({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeView());
  }
}
