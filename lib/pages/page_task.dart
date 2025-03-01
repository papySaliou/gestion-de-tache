import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Fonction pour obtenir la couleur en fonction de la priorité
Color getPriorityColor(String priority) {
  switch (priority) {
    case "Élevée":
      return Colors.red.shade300;
    case "Moyenne":
      return Colors.orange.shade300;
    case "Basse":
      return Colors.green.shade300;
    default:
      return Colors.grey.shade300;
  }
}

class PageTask extends StatefulWidget {
  const PageTask({super.key});

  @override
  State<PageTask> createState() => _PageTaskState();
}

class _PageTaskState extends State<PageTask> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Liste des Tâches")),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Task").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text("Aucune Tâche"));
            }

            List<dynamic> tasks = snapshot.data!.docs.toList();

            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                final titre = task['titre'];
                final Timestamp timestamp = task['date'];
                final String date = DateFormat.yMd().add_jm().format(timestamp.toDate());
                final priority = task['priority'];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Card(
                    color: getPriorityColor(priority), // Appliquer la couleur de la priorité
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        '$titre',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(date),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white, // Couleur du bouton
                              foregroundColor: Colors.black, // Texte du bouton
                            ),
                            onPressed: () {
                              // Redirection vers la page des détails de la tâche
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskDetailPage(task: task),
                                ),
                              );
                            },
                            child: Text("Détails"),
                          ),
                          SizedBox(width: 10), // Espacement entre les deux boutons
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red, // Couleur du bouton
                              foregroundColor: Colors.white, // Texte du bouton
                            ),
                            onPressed: () {
                              // Supprimer la tâche de la base de données
                              FirebaseFirestore.instance.collection('Task').doc(task.id).delete().then((_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Tâche supprimée")),
                                );
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Erreur lors de la suppression")),
                                );
                              });
                            },
                            child: Text("Supprimer"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class TaskDetailPage extends StatelessWidget {
  final dynamic task;

  const TaskDetailPage({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titre = task['titre'];
    final contenu = task['contenu'];
    final Timestamp timestamp = task['date'];
    final String date = DateFormat.yMd().add_jm().format(timestamp.toDate());
    final priority = task['priority'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Détails de la Tâche", textAlign: TextAlign.center),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center( // Centre toute la carte sur l'écran
          child: Card(
            color: getPriorityColor(priority), // Appliquer la couleur de la priorité
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20), // Ajout de padding pour aérer
              child: Column(
                mainAxisSize: MainAxisSize.min, // Réduit la hauteur au contenu
                crossAxisAlignment: CrossAxisAlignment.center, // Centrer les éléments
                children: [
                  Text(
                    titre,
                    style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, 
                    color: Colors.white),
                    textAlign: TextAlign.center, // Centrer le texte
                  ),
                  SizedBox(height: 25),
                  Text(
                    "Date : $date",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                    textAlign: TextAlign.center,
                    
                  ),
                  SizedBox(height: 25),
                  Text(
                    "Priorité : $priority",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                    color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25),
                  Text(
                    "Description :",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,
                    color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25),
                  Text(
                    contenu,
                    style: TextStyle(fontSize: 18,
                    color: Colors.white),
                    textAlign: TextAlign.center, // Centrer la description
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
