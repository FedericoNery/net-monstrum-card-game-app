import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Column(
                  children: [
                    Icon(Icons.store),
                    Text('Tienda'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Column(
                  children: [
                    Icon(Icons.auto_awesome),
                    Text('EJEMPLO'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
