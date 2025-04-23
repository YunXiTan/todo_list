import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
    );
  }
}

// Updated Task model with isDone
class Task {
  String title;
  DateTime? dueDate;
  bool isDone;

  Task({required this.title, this.dueDate, this.isDone = false});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> todoList = [];
  final TextEditingController _controller = TextEditingController();
  int updateIndex = -1;
  DateTime? selectedDate;

  addList(String task) {
    setState(() {
      todoList.add(Task(title: task, dueDate: selectedDate));
      _controller.clear();
      selectedDate = null;
    });
  }

  updateListItem(String task, int index) {
    setState(() {
      final existingTask = todoList[index];
      todoList[index] = Task(
        title: task,
        dueDate: selectedDate,
        isDone: existingTask.isDone,
      );
      updateIndex = -1;
      _controller.clear();
      selectedDate = null;
    });
  }

  deleteItem(index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  toggleDone(int index, bool? value) {
    setState(() {
      todoList[index].isDone = value ?? false;
    });
  }

  pickDate(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Todo Application",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 76, 92, 175),
        foregroundColor: Colors.white,
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              flex: 90,
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  final task = todoList[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    color: const Color.fromARGB(255, 76, 92, 175),
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Checkbox(
                            value: task.isDone,
                            onChanged: (value) => toggleDone(index, value),
                            checkColor: Colors.white,
                            activeColor: const Color.fromARGB(255, 255, 255, 255),
                          ),
                          Expanded(
                            flex: 80,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    decoration: task.isDone
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  task.dueDate != null
                                      ? "Due: ${DateFormat('yyyy-MM-dd').format(task.dueDate!)}"
                                      : "No due date",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _controller.clear();
                                _controller.text = task.title;
                                updateIndex = index;
                                selectedDate = task.dueDate;
                              });
                            },
                            icon: Icon(Icons.edit,
                                size: 30, color: Colors.white),
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            onPressed: () {
                              deleteItem(index);
                            },
                            icon: Icon(Icons.delete,
                                size: 30, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  Expanded(
                    flex: 60,
                    child: SizedBox(
                      height: 60,
                      child: TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: const Color.fromARGB(255, 76, 92, 175),
                            ),
                          ),
                          filled: true,
                          labelText: 'Create Task....',
                          labelStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today,
                        color: const Color.fromARGB(255, 76, 92, 175)),
                    onPressed: () => pickDate(context),
                  ),
                  SizedBox(width: 5),
                  FloatingActionButton(
                    backgroundColor: const Color.fromARGB(255, 76, 92, 175),
                    foregroundColor: Colors.white,
                    onPressed: () {
                      if (_controller.text.trim().isEmpty) return;
                      updateIndex != -1
                          ? updateListItem(_controller.text, updateIndex)
                          : addList(_controller.text);
                    },
                    child: Icon(
                      updateIndex != -1 ? Icons.edit : Icons.add,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
