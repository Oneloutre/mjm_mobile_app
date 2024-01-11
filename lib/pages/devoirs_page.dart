import 'package:flutter/material.dart';

class DevoirsPage extends StatefulWidget {
  const DevoirsPage({super.key});

  @override
  _DevoirsPageState createState() => _DevoirsPageState();
}


class _DevoirsPageState extends State<DevoirsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Devoirs',
              style: TextStyle(fontSize: 50),
            ),
          ],
        ),
      ),
    );
  }
}