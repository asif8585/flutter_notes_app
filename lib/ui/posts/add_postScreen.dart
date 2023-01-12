import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_flutter_int/ui/posts/post_screen.dart';
import 'package:firebase_flutter_int/ui/utilities/utils.dart';
import 'package:firebase_flutter_int/widgets/custom_btn.dart';
import 'package:flutter/material.dart';

class Add_PostScreen extends StatefulWidget {
  const Add_PostScreen({Key? key}) : super(key: key);

  @override
  State<Add_PostScreen> createState() => _Add_PostScreenState();
}

class _Add_PostScreenState extends State<Add_PostScreen> {
  bool loading = false;
  final db_reference = FirebaseDatabase.instance.ref('Post');
  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 18,
            ),
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter Your Post",
              ),
            ),
            SizedBox(
              height: 19,
            ),
            Custom_btn(
              loading: loading,
              btn_title: "Add",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Post_Screen(),
                    ));
                setState(() {
                  loading = true;
                });
                String id = DateTime
                    .now()
                    .millisecondsSinceEpoch
                    .toString();
                db_reference.child(id).set({
                  'id': id,
                  'note': postController.text.toString(),
                }).then((value) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage('Post added');
                }).onError((error, stackTrace) {
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(error.toString());
                });
              },
            )
          ],
        ),
      ),
    );
  }

}
