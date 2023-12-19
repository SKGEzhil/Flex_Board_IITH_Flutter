import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SampleList extends StatefulWidget {
  const SampleList({super.key});

  @override
  State<SampleList> createState() => _SampleListState();
}

class _SampleListState extends State<SampleList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
        return ListTile(
          title: Text('Item $index'),
        );
      }),
    );
  }
}
