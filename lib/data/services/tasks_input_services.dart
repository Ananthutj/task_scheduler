import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class TasksInputServices {
  Future<DocumentReference<Map<String, dynamic>>> postANewTask(Map<String, dynamic> tasksData) async {
    try {
      return await FirebaseFirestore.instance.collection('NewTasks').add(
        tasksData
      );
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchTasks(){
    return FirebaseFirestore.instance.collection('NewTasks').snapshots();
  }

  Future<void> deleteATask(String docId) async{
    return FirebaseFirestore.instance.collection('NewTasks').doc(docId).delete();
  }

  Future<void> updateTask(String docId, Map<String,dynamic> updatedData) async{
    return FirebaseFirestore.instance.collection('NewTasks').doc(docId).update(updatedData);
  }
}
