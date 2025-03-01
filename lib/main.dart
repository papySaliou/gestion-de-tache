
import 'package:conference/pages/page_add_task.dart';
import 'package:conference/pages/page_task.dart';
import 'package:conference/pages/page_home.dart';
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int _currentIndex=0;

  setCurrentIndex(int index){
    setState(() {
      _currentIndex = index;
    });
  }

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.green,
            title: [
              
              Text('Accueil',
               style: TextStyle(color: Colors.white,
               fontSize: 20,
               fontWeight: FontWeight.bold,)
               ),
              Text('Liste des Taches',
              style: TextStyle(color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,)
              ),
              Text('Formulaire',
              style: TextStyle(color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,)
              ),
            ][_currentIndex], 
          ),
          body: [
            PageHome(),
            PageTask(),
            PageAddTask(),
          ][_currentIndex],
           
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setCurrentIndex(index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            iconSize: 25,
            elevation: 10,
            items: const[

              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
                ) ,

                BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Taches',
                ),

                BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Ajout',
                ),      
              ],
              ),
      ),
      
    );
  }
}
