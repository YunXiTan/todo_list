import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'model/task_model.dart';
import 'all_tasks_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  List<Task> todoList = [];
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = focusedDay;
  }

  void addTask(String task, DateTime? dueDate) {
    setState(() {
      todoList.add(Task(title: task, dueDate: dueDate));
    });
  }

  void toggleDone(int index, bool? value) {
    setState(() {
      todoList[index].isDone = value ?? false;
    });
  }

  void deleteTask(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  void showAddTaskModal(BuildContext context) {
  final TextEditingController taskController = TextEditingController();
  DateTime? pickedDate = DateTime.now();
  TimeOfDay? pickedTime = TimeOfDay.now();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add New Task",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: taskController,
                  decoration: InputDecoration(
                    labelText: "Task Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                CalendarDatePicker(
                  initialDate: pickedDate!,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onDateChanged: (date) {
                    setState(() => pickedDate = date);
                  },
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: pickedTime ?? TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() => pickedTime = time);
                    }
                  },
                  child: Text(
                    pickedTime != null
                        ? "Due Time: ${pickedTime!.format(context)}"
                        : "Select Time",
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (taskController.text.trim().isNotEmpty) {
                      final fullDateTime = DateTime(
                        pickedDate!.year,
                        pickedDate!.month,
                        pickedDate!.day,
                        pickedTime?.hour ?? 0,
                        pickedTime?.minute ?? 0,
                      );
                      addTask(taskController.text.trim(), fullDateTime);
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Add Task",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      );
    },
  );
}

void showEditTaskModal(BuildContext context, int index) {
  final task = todoList[index];
  final TextEditingController taskController = TextEditingController(text: task.title);
  DateTime? pickedDate = task.dueDate ?? DateTime.now();
  TimeOfDay? pickedTime = TimeOfDay.fromDateTime(task.dueDate ?? DateTime.now());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext ctx) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          top: 20,
          left: 20,
          right: 20,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Edit Task",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: taskController,
                  decoration: InputDecoration(
                    labelText: "Task Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                CalendarDatePicker(
                  initialDate: pickedDate!,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onDateChanged: (date) {
                    setState(() => pickedDate = date);
                  },
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: pickedTime ?? TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() => pickedTime = time);
                    }
                  },
                  child: Text(
                    pickedTime != null
                        ? "Due Time: ${pickedTime!.format(context)}"
                        : "Select Time",
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (taskController.text.trim().isNotEmpty) {
                      final updatedDateTime = DateTime(
                        pickedDate!.year,
                        pickedDate!.month,
                        pickedDate!.day,
                        pickedTime?.hour ?? 0,
                        pickedTime?.minute ?? 0,
                      );
                      setState(() {
                        todoList[index] = Task(
                          title: taskController.text.trim(),
                          dueDate: updatedDateTime,
                          isDone: task.isDone,
                        );
                      });
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Save Changes", style: TextStyle(color: Colors.white)),
                ),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      );
    },
  );
}

  Widget buildCalendarPage() {
  List<Task> filteredList = todoList
      .where(
        (task) =>
            task.dueDate != null &&
            DateFormat('yyyy-MM-dd').format(task.dueDate!) ==
                DateFormat('yyyy-MM-dd').format(selectedDay!),
      )
      .toList();
      return Stack(
        children: [
          Column(
            children: [
              TableCalendar(
                focusedDay: focusedDay,
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                selectedDayPredicate: (day) => isSameDay(selectedDay, day),
                onDaySelected: (selected, focused) {
                  setState(() {
                    selectedDay = selected;
                    focusedDay = focused;
                  });
                },
                eventLoader: (day) {
                  return todoList
                      .where((task) =>
                          task.dueDate != null &&
                          DateFormat('yyyy-MM-dd').format(task.dueDate!) ==
                              DateFormat('yyyy-MM-dd').format(day))
                      .toList();
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.indigo.shade300,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.indigo,
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.red),
                  defaultTextStyle: TextStyle(color: Colors.black),
                  markersAlignment: Alignment.bottomCenter,
                  markerDecoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 1,
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  final task = filteredList[index];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: task.isDone,
                          onChanged:
                              (value) =>
                                  toggleDone(todoList.indexOf(task), value),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              if (task.dueDate != null)
                                Text(
                                  "Due: ${DateFormat('hh:mm a').format(task.dueDate!)}",
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: const Color.fromARGB(255, 42, 32, 181)),
                          onPressed: () => showEditTaskModal(context, todoList.indexOf(task)),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTask(todoList.indexOf(task)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            backgroundColor: Colors.indigo,
            onPressed: () => showAddTaskModal(context),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      AllTasksScreen(tasks: todoList, onToggleDone: toggleDone),
      buildCalendarPage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Tasks"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Calendar",
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
