enum TaskType {
  individual,
  group
} 

extension TaskTypeExtension on TaskType {
  String get name => this.toString().split('.').last;

  static TaskType fromString(String value) {
    return TaskType.values.firstWhere((e) => e.name == value);
  }
}