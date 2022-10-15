import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Task> tasks = [
    Task(difficulty: 'easy', title: 'title1', done: false),
    Task(difficulty: 'medium', title: 'title2', done: true),
    Task(difficulty: 'hard', title: 'title1', done: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //     image: DecorationImage(
      //         image: AssetImage('assets/bg_home.jpg'),
      //         fit: BoxFit.fitHeight
      //     )
      // ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Kaizen'),
          centerTitle: false,
          actions: [
            IconButton(
                icon: Icon(Icons.access_alarm),
              onPressed: () => {},
            ),
            SizedBox(width: 10),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => {},
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index){
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Slidable(
                    key: Key(tasks[index].title),
                    endActionPane: ActionPane(
                      motion: BehindMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) => {},
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          // label: 'Delete',
                        ),
                        SlidableAction(
                          onPressed: (context) => {},
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.done,
                          // label: 'done',
                        ),
                      ],
                    ),
                    child: Container(
                      color: Color.fromRGBO(228, 92, 67, 0.3),
                      child: ListTile(
                        
                        onLongPress: () => {},
                        trailing: Text('wsup'),
                        title: Text(
                          tasks[index].title,
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'ArchitectsDaughter',
                            color: Colors.white,
                            // letterSpacing: 1
                          ),
                        ),
                        subtitle: Text(tasks[index].difficulty),
                      ),
                    ),
                  ),
                )
              );
            },
          ),
        ),
        floatingActionButton: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _showAddTaskBottomModal(context);
          },
          color: Colors.red
        ),
      ),
    );
  }
}

void _showAddTaskBottomModal(context) {
  showModalBottomSheet(context: context, builder: (BuildContext bc) {
    return Container(
      height: MediaQuery.of(context).size.height * .60,
      child: Form(
        child: Column(
          children: [
            ListTile(
              title: TextFormField(
                validator: (value) =>
                value!.isEmpty ? "You can't have an empty name." : null,
                onSaved: (value) {
                  print(value);
                },
                decoration: InputDecoration(labelText: 'NAME'),
              ),
            ),
            ListTile(
              title: RaisedButton(
                onPressed: () {
                  // final form = key.currentState;
                  //
                  // if (form.validate()) {
                  //   form.save();
                  //
                  //   // ...
                  // }
                },
                child: Text('Submit '),
              ),
            )
          ],
        ),
      )
    );
  });
}

class Task {
  String difficulty;
  String title;
  bool done;

  Task({required this.difficulty, required this.title, this.done: false});
}



