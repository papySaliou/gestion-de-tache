
import 'package:flutter/material.dart';

class PageHome extends StatelessWidget {
  const PageHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenu sur BokkTache',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 55, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              'Organisez vos tâches facilement et atteignez vos objectifs !',
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
            const Padding(padding: EdgeInsets.only(top: 30)),
            
          ],
        ),
      );
  }
}