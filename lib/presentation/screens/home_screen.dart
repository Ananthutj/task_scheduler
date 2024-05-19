import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/models/tasks_input.dart';
import 'package:demo/data/services/tasks_input_services.dart';
import 'package:demo/presentation/screens/tasks.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final TasksInputServices _tasksInputServices = TasksInputServices();
  
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 27, 41),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "ToDo",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream: _tasksInputServices.fetchTasks(),
        builder: (context, snapshot) {

          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }

          if(snapshot.hasError){
            return const Center(child: CircularProgressIndicator());
          }

          List<TasksData> taskData = snapshot.data!.docs.map((doc)=> TasksData.fromDocSnapshot(doc)).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SafeArea(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: taskData.length,
                    itemBuilder: (context, index) {
                      final tasks = taskData[index];
                      final docId = snapshot.data!.docs[index].id;
                      return  Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        ),
                        width: MediaQuery.sizeOf(context).width,
                        child: Row(
                          children:[
                            Expanded(
                              child: ListTile(
                              title: Text(tasks.title),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(tasks.description),
                                  Text('Task date: ${tasks.date.day}/${tasks.date.month}/${tasks.date.year}'),
                                   Text('Task Time: ${DateFormat('h:mm a').format(DateTime(0, 0, 0, tasks.time.hour, tasks.time.minute))}'),
                                ],
                              ),
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => TasksFields(taskData: taskData[index],)));
                                },
                                icon: Icon(Icons.edit,color: Colors.brown,)
                                ),
                              IconButton(
                                onPressed: () async{
                                  await _tasksInputServices.deleteATask(docId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Task deleted successfully"),backgroundColor: Colors.red,),
                                  );
                                }, 
                                icon: Icon(Icons.delete,color: Colors.red,)
                                ),
                            ],
                          )
                          ]
                        ),
                      ),
                    );
                    },
                  ),
                ],
              ),
            ),
          );
        }
      ),
      floatingActionButton: FilledButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TasksFields(taskData: null)));
          },
          child: Icon(Icons.add)
        ),
    );
  }
}
