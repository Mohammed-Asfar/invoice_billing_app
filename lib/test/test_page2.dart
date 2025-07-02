import 'package:flutter/material.dart';

class TestPage2 extends StatelessWidget {
  const TestPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Balloon-Like Shape Example")),
        body: Center(
          child: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.all(
                Radius.elliptical(100, 70),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 3,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              "Balloon",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
