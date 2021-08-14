// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotFound extends StatefulWidget {
  const NotFound({Key? key}) : super(key: key);

  @override
  _NotFoundState createState() => _NotFoundState();
}

class _NotFoundState extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Not fount'),
        ),
        body: const Center(
          child: Text('Page not found'),
        ),
      ),
    );
  }
}
