import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double? value;
  const Loader({super.key, this.value});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: Colors.white, value: value),
    );
  }
}
