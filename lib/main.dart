
import 'package:flutter/material.dart';
// import 'package:home_widget/home_widget.dart';
import 'package:homescreen_widget/crud/notes_service.dart';
import 'package:homescreen_widget/notes/create_update_note.dart';
import 'package:homescreen_widget/notes/notes_list_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // HomeWidget.registerBackgroundCallback(backgroundCallback);
  runApp(const MyApp());
}

// Future<void> backgroundCallback(Uri? uri) async {
//   if (uri?.host == 'updatenote') {
//     List<String>? listOfText;
//     final allNotes = await NotesService().getAllNotes();
//     for (var i in allNotes) {
//       listOfText?.add(i.text);
//     }

//     await HomeWidget.saveWidgetData<List<String>>('_noteText', listOfText);
//     await HomeWidget.updateWidget(
//         //this must the class name used in .Kt
//         name: 'HomeScreenWidgetProvider',
//         iOSName: 'HomeScreenWidgetProvider');
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesView(),
      routes: {
        '/notes/new-note/': (context) => const CreateUpdateNoteView(),
      },
    );
  }
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => NotesViewState();
}

class NotesViewState extends State<NotesView> {
  late NotesService _notesService;
  // late String? _noteText;
  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    // HomeWidget.widgetClicked.listen((Uri? uri) => loadData());
    // loadData();
    super.initState();
  }

  // void loadData() async {
  //   await HomeWidget.getWidgetData<String>(
  //     '_noteText',
  //     defaultValue: "main.dart line 71",
  //   ).then((value) {
  //     _noteText = value;
  //   });
  //   setState(() {});
  // }

  // Future<void> updateAppWidget() async {
  //   await HomeWidget.saveWidgetData('_noteText', _noteText);
  //   await HomeWidget.updateWidget(
  //     name: 'HomeScreenWidgetProvider',
  //     iOSName: 'HomeScreenWidgetProvider',
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/notes/new-note/');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(builder: (context, snapshot) {
        return StreamBuilder(
          stream: _notesService.allNotes,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final allNotes = snapshot.data as List<DatabaseNote>;
              return NotesListView(
                notes: allNotes,
                onDeleteNote: (note) async {
                  await _notesService.deleteNote(id: note.id);
                },
                onTap: (note) async {
                  Navigator.of(context).pushNamed(
                    '/notes/new-note/',
                    arguments: note,
                  );
                },
              );
            } else {
              return const Text("don't have data");
            }
          },
        );
      }),
    );
  }
}
