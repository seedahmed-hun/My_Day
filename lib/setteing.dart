import 'package:first_app/home.dart';
import 'package:flutter/material.dart';

class Setteing extends StatefulWidget {
  const Setteing({super.key});

  @override
  State<Setteing> createState() => _Setteing();
}

class _Setteing extends State<Setteing> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pop(MaterialPageRoute(builder: (context) => Home()));
            },
            icon: Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.blue[300],
          title: Text("Setting"),
        ),
        body: Container(
          child: Column(
            children: [
              Card(
                child: ListTile(title: Text("Name"), trailing: Text("2026")),
              ),
              Container(child: Text("Hello")),
            ],
          ),
        ),
      ),
    );
  }
}
