import 'package:arcore_flutter/camera/camera.dart';
import 'package:flutter/material.dart';

void main() => runApp(ARCoreFaceFilters());

class ARCoreFaceFilters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Face filters',
      home: ARCore(),
    );
  }
}
