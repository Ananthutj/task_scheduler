import 'package:demo/data/models/enum.dart';
import 'package:demo/data/models/tasks_input.dart';
import 'package:demo/data/services/tasks_input_services.dart';
import 'package:flutter/material.dart';

class TasksFields extends StatefulWidget {
  final TasksData? taskData;
  const TasksFields({super.key, this.taskData});

  @override
  State<TasksFields> createState() => _TasksFieldsState();
}

class _TasksFieldsState extends State<TasksFields> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final TasksInputServices _tasksInputServices = TasksInputServices();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TaskType? _selectedTaskType;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context, initialTime: _selectedTime ?? TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _getDateLabel() {
    return _selectedDate != null
        ? "Selected Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
        : "Please pick a date";
  }

  String _getTimeLabel() {
    return _selectedTime != null
        ? "Time: ${_selectedTime!.hour}:${_selectedTime!.minute}"
        : "Please pick a time";
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.taskData?.title);
    _descriptionController =
        TextEditingController(text: widget.taskData?.description);
    _selectedDate = widget.taskData?.date ?? DateTime.now();
    _selectedTime = widget.taskData != null
        ? TimeOfDay(
            hour: widget.taskData!.time.hour,
            minute: widget.taskData!.time.minute)
        : TimeOfDay.now();
    _selectedTaskType = widget.taskData?.taskType;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Tasks"),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    label: Text("Title"),
                    hintText: 'Please type the title of task',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    label: Text("Description"),
                    hintText: 'Please type the description of task',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          _selectDate(context);
                        });
                      },
                      // ignore: unnecessary_null_comparison
                      label: Text(_getDateLabel())),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: FilledButton.icon(
                    onPressed: () {
                      _selectTime(context);
                    },
                    label: Text(_getTimeLabel()),
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: DropdownButton<TaskType>(
                    value: _selectedTaskType,
                    isExpanded: true,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text("Please choose an option"),
                      ),
                      ...TaskType.values.map((TaskType type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.name),
                        );
                      }).toList(),
                    ],
                    onChanged: (TaskType? newValue) {
                      setState(() {
                        _selectedTaskType = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await _tasksInputServices.postANewTask({
                          'title': _titleController.text,
                          'description': _descriptionController.text,
                          'date': _selectedDate,
                          'time': _selectedTime != null
                              ? '${_selectedTime!.hour}:${_selectedTime!.minute}'
                              : null,
                          'taskType': _selectedTaskType?.name ??
                              TaskType.individual.name
                        });
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("A new task is added successfully"),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      } catch (e) {
                        rethrow;
                      }
                    }
                  },
                  label: const Text("Add"),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
