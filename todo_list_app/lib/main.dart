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
  final TextEditingController _controller = TextEditingController();
  int updateIndex = -1;
  DateTime? selectedDate;
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = focusedDay;
  }

  void addTask(String task) {
    setState(() {
      todoList.add(Task(title: task, dueDate: selectedDate));
      _controller.clear();
      selectedDate = null;
    });
  }

  void updateTask(String task, int index) {
    setState(() {
      final oldTask = todoList[index];
      todoList[index] = Task(
        title: task,
        dueDate: selectedDate,
        isDone: oldTask.isDone,
      );
      updateIndex = -1;
      _controller.clear();
      selectedDate = null;
    });
  }

  void deleteTask(int index) {
    setState(() {
      todoList.removeAt(index);
    });
  }

  void toggleDone(int index, bool? value) {
    setState(() {
      todoList[index].isDone = value ?? false;
    });
  }

  void pickDate(BuildContext context) async {
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

  Widget buildCalendarPage() {
    List<Task> filteredList = todoList
        .where((task) =>
            task.dueDate != null &&
            DateFormat('yyyy-MM-dd').format(task.dueDate!) ==
                DateFormat('yyyy-MM-dd').format(selectedDay!))
        .toList();

    return Column(
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
          ),
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle:
                TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      onChanged: (value) =>
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
                              decoration: task.isDone
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text(
                                task.dueDate != null
                                    ? DateFormat('HH:mm').format(task.dueDate!)
                                    : "--:--",
                                style: TextStyle(color: Colors.grey[700]),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.indigo),
                      onPressed: () {
                        setState(() {
                          _controller.text = task.title;
                          updateIndex = todoList.indexOf(task);
                          selectedDate = task.dueDate;
                        });
                      },
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Enter task...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                onPressed: () => pickDate(context),
                icon: Icon(Icons.calendar_today, color: Colors.indigo),
              ),
              SizedBox(width: 8),
              FloatingActionButton(
                mini: true,
                onPressed: () {
                  if (_controller.text.trim().isEmpty) return;
                  updateIndex != -1
                      ? updateTask(_controller.text, updateIndex)
                      : addTask(_controller.text);
                },
                backgroundColor: Colors.indigo,
                child: Icon(updateIndex != -1 ? Icons.edit : Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      AllTasksScreen(
        tasks: todoList,
        onToggleDone: toggleDone,
      ),
      buildCalendarPage(),
      //Center(child: Text("Profile Screen Coming Soon")),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Tasks"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Calendar"),
          //BottomNavigationBarItem(icon: Icon(Icons.person), label: "Mine"),
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
