import 'package:flutter/material.dart';
import 'package:flutter_sqlite/data/local/db_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allNotes = [];
  DBHelper? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = DBHelper.getInstance;
    getNotes();
  }

  void getNotes() async {
    print('-------------- Fetching Notes --------------');
    allNotes = await dbRef!.getAllNotes();
    print('-------------- Notes Fetched: $allNotes --------------');
    if (allNotes.isNotEmpty) {
      print('Notes are available for display');
    } else {
      print('No notes found');
    }
    setState(() {
      print('-------------- UI Updated --------------');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter SQLite'),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  leading: Text('${allNotes[index][DBHelper.COLUMN_NOTE_SNO]}'),
                  title: Text(allNotes[index][DBHelper.COLUMN_NOTE_TITLE]),
                  subtitle: Text(allNotes[index][DBHelper.COLUMN_NOTE_DESC]),
                );
              })
          : const Center(child: Text('No Notes yet!!')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print('-------------- Adding Note --------------');
          bool check = await dbRef!.addNote(
              mTitle: "Personal Fav Note",
              mDesc: "Do you love doing your work?");
          print('-------------- Note Added: $check --------------');
          if (check) {
            print('Fetching notes after adding...');
            getNotes();
          } else {
            print('Failed to add note');
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
