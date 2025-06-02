import 'package:dev_updater/dev_updater.dart';
import 'package:flutter/material.dart';

class example extends StatefulWidget {
  const example({super.key});

  @override
  State<example> createState() => _exampleState();
}

class _exampleState extends State<example> {
  @override
  void initState() {
    DevUpdater().checkAndUpdate(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
