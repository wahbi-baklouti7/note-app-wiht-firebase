import 'package:flutter/material.dart';

class NoteView extends StatefulWidget {
  final notes;
  const NoteView({Key? key,this.notes}) : super(key: key);

  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Note View"),),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              width:double.infinity,
              height: 250,
              child: Image.network("${widget.notes["imageUrl"]}",fit: BoxFit.fill,),
            ),
            const SizedBox(height:24),
            Text("${widget.notes["title"]}",style:const TextStyle(fontSize:30,fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              height: 180,
              margin:const  EdgeInsets.all(18),
              color:Colors.amber[50],
              child: Text("${widget.notes["description"]},",style:const TextStyle(fontSize: 16))
            )
          ],
        ),
       
      ),
    );
  }
}
