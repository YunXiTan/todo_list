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
                    children: [
                      Checkbox(
                        value: task.isDone,
                        onChanged: (value) {
                          widget.onToggleDone(index, value);
                          setState(() {}); // local UI update
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
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isDone
                                    ? Colors.grey
                                    : Colors.black,
                              ),
                            ),
                            if (task.dueDate != null) ...[
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.access_time,
                                      size: 16, color: Colors.grey),
                                  SizedBox(width: 4),
                                  Text(
                                    DateFormat('yyyy-MM-dd HH:mm')
                                        .format(task.dueDate!),
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              ),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
