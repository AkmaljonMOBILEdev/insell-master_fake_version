import 'package:flutter/material.dart';

class ScrollForTestWidget extends StatefulWidget {
  const ScrollForTestWidget({super.key});

  @override
  State<ScrollForTestWidget> createState() => _ScrollForTestWidgetState();
}

class _ScrollForTestWidgetState extends State<ScrollForTestWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            cacheExtent: 100,
            itemExtent: 50,
            itemBuilder: (context, index) => Text('$index', style: const TextStyle(color: Colors.white, fontSize: 20)),
            itemCount: 10000));
  }
}
