import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'model/task_model.dart';

class AllTasksScreen extends StatefulWidget {
  final List<Task> tasks;
  final Function(int, bool?) onToggleDone;

  const AllTasksScreen({
    super.key,
    required this.tasks,
    required this.onToggleDone,
  });

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Tasks"),
      ),
      body: widget.tasks.isEmpty
          ? Center(
              child: Text(
                "No tasks yet!",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: widget.tasks.length,
              itemBuilder: (context, index) {
                final task = widget.tasks[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: task.isDone ? Colors.grey[200] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: task.isDone,
                        onChanged: (value) {
                          widget.onToggleDone(index, value);
                          setState(() {});
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                decoration: task.isDone ? TextDecoration.lineThrough : null,
                                color: task.isDone ? Colors.grey : Colors.black,
                              ),
                            ),
                            if (task.dueDate != null) ...[
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    DateFormat('yyyy-MM-dd HH:mm').format(task.dueDate!),
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: const Color.fromARGB(255, 42, 32, 181)),
                            onPressed: () => showEditTaskModal(context, index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              setState(() {
                                widget.tasks.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void showEditTaskModal(BuildContext context, int taskIndex) {
    final task = widget.tasks[taskIndex];
    final TextEditingController titleController = TextEditingController(text: task.title);
    DateTime? selectedDueDate = task.dueDate;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Task',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () async {
                  final DateTime? newDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDueDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (newDate != null) {
                    final TimeOfDay? newTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(selectedDueDate ?? DateTime.now()),
                    );
                    if (newTime != null) {
                      setState(() {
                        selectedDueDate = DateTime(
                          newDate.year,
                          newDate.month,
                          newDate.day,
                          newTime.hour,
                          newTime.minute,
                        );
                      });
                    }
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.access_time, size: 20, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        selectedDueDate != null
                            ? DateFormat('yyyy-MM-dd HH:mm').format(selectedDueDate!)
                            : 'Select Due Date',
                        style: TextStyle(fontSize: 16, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.tasks[taskIndex] = Task(
                      title: titleController.text,
                      dueDate: selectedDueDate,
                      isDone: task.isDone,
                    );
                  });
                  Navigator.pop(context);
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        );
      },
    );
  }
}
