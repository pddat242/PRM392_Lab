import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget{
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ex1'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome to Flutter'),
            const SizedBox(height: 16.0),
            Image.network('https://picsum.photos/400/200'),
            const SizedBox(height: 20),
            const Card(
              child: ListTile(
                leading: Icon(Icons.star),
                title: Text('Movie Item'),
                subtitle: Text('This is a sample ListTile inside a Card'),
              ),
            ),  
          ],
        ),
      ),
    );
  }
}