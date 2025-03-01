import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conference/pages/page_task.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

class PageAddTask extends StatefulWidget {
  const PageAddTask({super.key});

  @override
  State<PageAddTask> createState() => _PageAddTaskState();
}

class _PageAddTaskState extends State<PageAddTask> {

  final _formKey = GlobalKey<FormState>();

  // final confNameController = TextEditingController();
  // final speakerNameController = TextEditingController();
  // String selectedConfType = 'Talk';
  // DateTime selectedConfDate = DateTime.now();



  final taskTitreController = TextEditingController();
  final taskContenuController = TextEditingController();
  DateTime selectedTaskDate = DateTime.now();
  String selectedTaskPriority = 'Moyenne';

  @override
  void dispose() {
    super.dispose();

    // confNameController.dispose();
    // speakerNameController.dispose();

    taskTitreController.dispose();
    taskContenuController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Titre de la tache',
                  hintText: 'Entrer le titre de la tache',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty){
                    return "Tu dois completer ce texte";
                  }
                  return null;
                } ,
                // controller: confNameController,
                controller: taskTitreController, 
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Contenu',
                  hintText: 'Entrer le contenu de la tache',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty){
                    return "Tu dois completer ce texte";
                  }
                  return null;
                } ,
                // controller: speakerNameController,
                controller: taskContenuController,
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: 15),
              child: DropdownButtonFormField(
                items: [
                  DropdownMenuItem(
                    value: 'Élevée' ,
                    child: Text("Élevée")),
                    DropdownMenuItem(
                    value: 'Moyenne' ,
                    child: Text("Moyenne")),
                    DropdownMenuItem(
                    value: 'Basse' ,
                    child: Text("Basse"))
                ], 
                decoration: InputDecoration(
                  border: OutlineInputBorder()
                ),
                // value: selectedConfType,
                // onChanged: (value){
                //   setState(() {
                //     selectedConfType = value!;
                //   });

                  value: selectedTaskPriority,
                onChanged: (value){
                  setState(() {
                    selectedTaskPriority = value!;
                  });
                   
                }),
            ),

            Container(
              margin: EdgeInsets.only(bottom: 25),
  child: DateTimeFormField(
    decoration: const InputDecoration(
      hintStyle: TextStyle(color: Colors.black45),
      errorStyle: TextStyle(color: Colors.redAccent),
      border: OutlineInputBorder(),
      suffixIcon: Icon(Icons.event_note),
      labelText: 'Choisir une date',
    ),
    mode: DateTimeFieldPickerMode.dateAndTime,
    autovalidateMode: AutovalidateMode.always,
    validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
    onDateSelected: (DateTime value) {
      
      // setState(() {
      //   selectedConfDate = value;
      // });

      setState(() {
        selectedTaskDate = value;
      });
      
    },
  ),
),


            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(

              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, // Change la couleur ici
              foregroundColor: Colors.white, // Change la couleur du texte

              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Ajuste la taille du bouton
              shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Arrondi les bords
                     ),
  ),
                onPressed: (){
                  if (_formKey.currentState!.validate()){
                    // final confName = confNameController.text;
                    // final speakerName = speakerNameController.text;

                    final taskTitre = taskTitreController.text;
                    final taskContenu = taskContenuController.text;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Envoie en cour..."))
                    );
                    FocusScope.of(context).requestFocus(FocusNode());


                    //Ajout dans la base de données
                    // CollectionReference eventsRef = FirebaseFirestore.instance.collection("Events");
                    // eventsRef.add({
                      // 'speaker' : speakerName,
                      // 'date': selectedConfDate,
                      // 'subject' :confName,
                      // 'type': selectedConfType,
                      // 'avatar': 'user5',
                    CollectionReference tasksRef = FirebaseFirestore.instance.collection("Task");
                    tasksRef.add({
                      'titre': taskTitre,
                      'contenu': taskContenu,
                      'date': selectedTaskDate,
                      'priority': selectedTaskPriority,
                    }).then((value) {
                      // Redirection vers la page de confirmation après l'ajout
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PageTask()),
                      );
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Erreur: $error")),
                      );
                    });
                  }
                }, 
                child: Text("Envoyer",
                  style: TextStyle(
                  fontSize: 20, // Taille du texte
                  fontWeight: FontWeight.bold, // Gras
                  fontStyle: FontStyle.italic, // Italique
                  color: Colors.white, // Couleur du texte
                  letterSpacing: 1, // Espacement des lettres
                   ),

                )
              ),
            ),
          ],
        )),
    );
  }
}