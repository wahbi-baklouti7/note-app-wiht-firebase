import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:note_app_fireb/screens/home_screen.dart';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditScreen extends StatefulWidget {
  final docId;
  final listNote;
  const EditScreen({Key? key, this.docId, this.listNote}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  var _formkey = GlobalKey<FormState>();

  CollectionReference fireStore =
      FirebaseFirestore.instance.collection("notes");

  Reference? fireStorage;

  String? noteTitle, noteDescription, imageUrl;
  File? file;
  var pickedImage;

  updateNote(context) async {
    var formData = _formkey.currentState;

    if (file == null) {
      if (formData!.validate()) {
        formData.save();
        fireStore.doc(widget.docId).update({
          "title": noteTitle,
          "description": noteDescription,
        }).then((value) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }).catchError((onError) {
          print(onError);
        });
      }
    }

    if (formData!.validate()) {
      formData.save();
      await fireStorage!.putFile(file!);
      imageUrl = await fireStorage!.getDownloadURL();
      fireStore.doc(widget.docId).update({
        "title": noteTitle,
        "description": noteDescription,
        "imageUrl": imageUrl,
      }).then((value) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }).catchError((onError) {
          print(onError);
        });;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Note"),
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
          child: Form(
            key: _formkey,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: widget.listNote["title"],
                  onSaved: (val) {
                    noteTitle = val;
                  },
                  validator: (value) {
                    if (value!.length > 20) {
                      return "Title should be not pass 20 letters";
                    } else if (value.length < 2) {
                      return "Title should at least 2 letters";
                    }
                    return null;
                  },
                  maxLength: 20,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.title),
                    label: Text("Title"),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  initialValue: widget.listNote["description"],
                  onSaved: (val) {
                    noteDescription = val;
                  },
                  validator: (value) {
                    if (value!.length > 20) {
                      return "Note should be not pass 200 letters";
                    } else if (value.length < 2) {
                      return "Note should at least 5 letters";
                    }
                    return null;
                  },
                  maxLines: 3,
                  maxLength: 150,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.note),
                    label: Text("Note"),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  // width:50,
                  height: 50,
                  child: ElevatedButton(
                      style:
                          ButtonStyle(elevation: MaterialStateProperty.all(5)),
                      onPressed: () async {
                        pickedImage = await ImagePicker()
                            .getImage(source: ImageSource.gallery);

                        if (pickedImage != null) {
                          file = File(pickedImage.path);
                          String imageName = basename(pickedImage.path);
                          fireStorage = FirebaseStorage.instance
                              .ref("note")
                              .child(imageName);

                          await FirebaseStorage.instance
                              .refFromURL(widget.listNote["imageUrl"])
                              .delete();

                          // await fireStorage!.putFile(file!);
                          // imageUrl = await fireStorage!.getDownloadURL();
                        }
                      },
                      child: const Text(
                        "Update Note Image",
                        style: TextStyle(fontSize: 18),
                      )),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  width: 50,
                  height: 50,
                  child: ElevatedButton(
                      style:
                          ButtonStyle(elevation: MaterialStateProperty.all(5)),
                      onPressed: () async {
                        await updateNote(context);
                      },
                      child: const Text(
                        "Update Note",
                        style: TextStyle(fontSize: 20),
                      )),
                )
              ],
            ),
          ),
        ));
  }
}
