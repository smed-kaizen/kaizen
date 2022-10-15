import 'package:flutter/material.dart';
import 'package:kaizen/api/Api.dart';
import 'package:kaizen/entities/Todo.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Kaizen'),
        ),
        body: FutureBuilder<List<Todo>>(
          future: Api.todoController.getTodosOfToday(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            List<Widget> children;
            if (snapshot.hasData) {
              print(snapshot.data);
              children = <Widget>[
                Text('Found Data ${snapshot.data}')
              ];
            } else if (snapshot.hasError) {
              print(snapshot.error);
              children = <Widget>[
                Text('There was an error')
              ];
            } else {
              children = <Widget> [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(),
                ),
              ];
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          },
        ),
        // body: Column(
        //   children: [
        //     Row(
        //       children: [
        //         Text('This Is the title'),
        //         ElevatedButton(onPressed: () => {
        //           print('I was foking pressed mate')
        //         }, child: Text('Click bitch'))
        //       ],
        //     )
        //   ],
        // ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
          },
          child: Icon(Icons.add_sharp),
        ),
      ),
    );
  }
}
