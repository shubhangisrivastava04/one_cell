import 'package:flutter/material.dart';

void main() {
  runApp(OneCellApp());
}

class OneCellApp extends StatefulWidget {
  @override
  _OneCellAppState createState() => _OneCellAppState();
}

class _OneCellAppState extends State<OneCellApp> {
  bool _isDarkMode = false;

  void toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      title: 'One Cell',
      home: LoginScreen(toggleDarkMode: toggleDarkMode,
        isDarkMode: _isDarkMode),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final Function() toggleDarkMode;
  final bool isDarkMode;

  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({required this.toggleDarkMode, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: 
  
      Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String password = _passwordController.text;
                if (password=="OneCell")
                {Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubjectScreen(toggleDarkMode: toggleDarkMode,
                    isDarkMode: isDarkMode,)),
                );}
                else
                {
                  showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text("Password is incorrect. Try Again")
                    );}
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectScreen extends StatefulWidget {

  final Function() toggleDarkMode;
  final bool isDarkMode;

  SubjectScreen({required this.toggleDarkMode, required this.isDarkMode});
  
  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  static const List<String> Subjects = ['Personal', 'Work/School'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories", style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: widget.toggleDarkMode,
          ),],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: Subjects.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TodoListScreen(
                                Subject: Subjects[index],
                              )));
                },
                child: Container(
                    height: 362,
                    decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/background$index.png'), // Your background image
                  fit: BoxFit.cover, // Adjust the BoxFit as needed
                ),),
                        //color: Colors.blueGrey[100 * (index + 1)]),
                    child: Center(
                        child: ListTile(
                      title: Text(
                        Subjects[index],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 40
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ))));
          },
        ),
      ),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  final String Subject;
  TodoListScreen({required this.Subject});

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoListScreen> {
  List<String> tasks = [];
  List<Color> taskColors = [];
  Color tileColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 183, 147),
      appBar: AppBar(
        title: Text(
          '${widget.Subject} To-Do List',
        ),
      ),
      body: Container(
        child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Container(
              child: ListTile(
                title: Center(child: Text(tasks[index], style: TextStyle(color: Colors.black))),
                tileColor: taskColors[index],
                leading: IconButton(
                    icon: Icon(Icons.check, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        taskColors[index] = Colors.grey;
                      });
                    }),
                trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.black),
                    onPressed: () {
                      setState(() {
                        tasks.removeAt(index);
                        taskColors.removeAt(index);
                      });
                    }),
              ));
        },
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddTaskScreen(
                    onTaskAdded: (task) {
                      setState(() {
                        taskColors.add(Color.fromARGB(255, 200, 200, 200));
                        tasks.add(task);
                        
                      });
                    },
                  );
                });
          },
          backgroundColor: Colors.black,
          child: Icon(Icons.add, color: Colors.white, size: 40)),
    );
  }
}

class AddTaskScreen extends StatelessWidget {
  final Function(String) onTaskAdded;

  const AddTaskScreen({Key? key, required this.onTaskAdded})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    double dialogHeight = isLandscape ? screenHeight * 0.7 : screenHeight * 0.3;

    String task = '';

    return Dialog(
        child: SizedBox(
            width: screenWidth * 0.8,
            height: dialogHeight,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: Scaffold(
                    appBar: AppBar(title: Text("Add Task")),
                    body: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              decoration:
                                  InputDecoration(labelText: 'Enter Task'),
                              onChanged: (value) {
                                task = value;
                              },
                            ),
                            MaterialButton(
                                color: Colors.black,
                                child: Text('Save',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  onTaskAdded(task);
                                  Navigator.pop(context);
                                })
                          ],
                     ))))));
}
}
