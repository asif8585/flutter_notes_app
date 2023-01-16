import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Edit_note extends StatefulWidget {
  const Edit_note({Key? key}) : super(key: key);

  @override
  State<Edit_note> createState() => _Edit_noteState();
}

class _Edit_noteState extends State<Edit_note> {
  final auth = FirebaseAuth.instance;
  final db_reference = FirebaseDatabase.instance.ref('Post');
  final searchFilterController = TextEditingController();
  final editUpdateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            child: StreamBuilder(
          stream: db_reference.onValue,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              Map<dynamic, dynamic> map =
                  snapshot.data!.snapshot.value as dynamic;
              List<dynamic> list = [];
              list.clear();
              list = map.values.toList();
              return ListView.builder(
                itemCount: snapshot.data!.snapshot.children.length,
                itemBuilder: (context, index) {
                  return
                    ListTile(
                    title: Text(list[index]['title'].toString()),
                    subtitle: Text(list[index]['title'].toString()),


                  );
                },
              );
            }
          },
        )),
      ],
    ));
  }
}
