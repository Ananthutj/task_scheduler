import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/data/models/enum.dart';
import 'package:flutter/material.dart';

class TasksData {
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final TaskType taskType;

  const TasksData({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.taskType
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'date': Timestamp.fromDate(date),
      'time': '${time.hour}:${time.minute}',
      'taskType': taskType.name,
    };
  }

  factory TasksData.fromMap(Map<String, dynamic> map) {
    return TasksData(
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      date: map['date'] == null ? DateTime.now() : (map['date'] as Timestamp).toDate(),
      time: map['time'] == null ? TimeOfDay.now() : TimeOfDay(
              hour: int.parse(map['time'].split(':')[0]),
              minute: int.parse(map['time'].split(':')[1]),
            ),
      taskType: map['taskType'] != null ? TaskTypeExtension.fromString(map['taskType']) : TaskType.individual,
    );
  }

  factory TasksData.fromDocSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    try {
      final timeString = doc.data()?['time'];
      return TasksData(
        title: doc.data()?['title'] ?? '',
        description: doc.data()?['description'] ?? '',
        date: doc.data()?['date'] is Timestamp
            ? (doc.data()?['date'] as Timestamp).toDate()
            : DateTime.now(),
        time: timeString != null
            ? TimeOfDay(
                hour: int.parse(timeString.split(':')[0]),
                minute: int.parse(timeString.split(':')[1]),
              )
            : TimeOfDay.now(),
          taskType:  doc.data()?['taskType'] != null ? TaskTypeExtension.fromString(doc.data()?['taskType']) : TaskType.individual,
      );
    } catch (e) {
      rethrow;
    }
  }

  String toJson() => json.encode(toMap());

  factory TasksData.fromJson(String source) =>
      TasksData.fromMap(json.decode(source) as Map<String, dynamic>);

  TasksData copyWith({
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? time,
    TaskType? taskType,
  }) {
    return TasksData(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      taskType: taskType ?? this.taskType
    );
  }
}
