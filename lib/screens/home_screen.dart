// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:note_app_fireb/screens/add_note_screen.dart';
import 'package:note_app_fireb/screens/edit_screen.dart';
import 'package:note_app_fireb/screens/note_view.dart';
import 'package:note_app_fireb/screens/sign_in_screen.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference colRef = FirebaseFirestore.instance.collection("notes");
  var fcm = FirebaseMessaging.instance;

  var serverToken =
      "AAAA0QGXEMU:APA91bEr4APda2RFZk5FiHXnJvyujscvRcqEwGZebAa1Z_TtVGxEvgtDhxDV_b5oGav_lUE87adVBJYkqskbyCQ7sRXqfVfV2wcbmsdy04IdvPTJcJeaFLxTtHypXfVyGuHMWGFkoYjA";
  sendNotification(String body, String title) async {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': body, 'title': title},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to':"/topics/wahbi" //await FirebaseMessaging.instance.getToken(),
        },
      ),
    );
  }

  getmessage() async {
    FirebaseMessaging.onMessage.listen((event) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("${event.notification!.body}")));
      print("#" * 40);
      print("${event.notification!.title}");
    });
  }

  @override
  void initState() {
    FirebaseMessaging.instance.subscribeToTopic("wahbi");
    getmessage();
    // fcm.getToken().then((value) {
    //   print("#" * 30 + "token" + "#" * 30);
    //   print(value);
    // });
    super.initState();

    // FirebaseMessaging.onMessage.listen((event) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text("${event.notification!.body}")));
    // });

    // FirebaseMessaging.onMessageOpenedApp.listen((event) {
    //   Navigator.push(context,
    //       MaterialPageRoute(builder: (context) => const AddNoteScreen()));
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              },
              icon: Icon(Icons.exit_to_app))
        ],
        title: const Text("firebase"),
      ),
      body: FutureBuilder(
          future: colRef
              .where("userId",
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: UniqueKey(),
                    onDismissed: (direction) async {
                      await colRef.doc(snapshot.data.docs[index].id).delete();
                      await FirebaseStorage.instance
                          .refFromURL(snapshot.data.docs[index]["imageUrl"])
                          .delete();
                    },
                    child: ListNotes(
                      note: snapshot.data.docs[index].data(),
                      noteId: snapshot.data.docs[index].id,
                    ),
                  );
                },
              );
            }
            return Center(child: const CircularProgressIndicator());
          }),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddNoteScreen()));
            // sendNotification("this api test", "api notification");
          }),
    );
  }
}

class ListNotes extends StatelessWidget {
  final note;
  final noteId;
  ListNotes({this.note, this.noteId});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NoteView(
                      notes: note,
                    )));
      },
      child: Card(
          child: Row(children: [
        Container(
            height: 100,
            width: 100,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                      "${note["imageUrl"]}",
                    ),
                    fit: BoxFit.cover))),
        const SizedBox(
          width: 24,
        ),
        Column(children: [
          Text("${note["title"]}", style: TextStyle(fontSize: 20)),
          const SizedBox(
            height: 8,
          ),
          Text("${note["description"]}", style: TextStyle(fontSize: 12)),
        ]),
        const Spacer(),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditScreen(docId: noteId, listNote: note)));
            },
            icon: const Icon(Icons.edit)),
      ])),
    );
  }
}
