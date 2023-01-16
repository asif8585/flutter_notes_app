import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_flutter_int/auth/login_screen.dart';
import 'package:firebase_flutter_int/ui/posts/add_postScreen.dart';
import 'package:firebase_flutter_int/ui/posts/editNote.dart';
import 'package:firebase_flutter_int/ui/splash_screen.dart';
import 'package:firebase_flutter_int/ui/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';

class Post_Screen extends StatefulWidget {
  const Post_Screen({Key? key}) : super(key: key);

  @override
  State<Post_Screen> createState() => _Post_ScreenState();
}

class _Post_ScreenState extends State<Post_Screen> {
  final auth = FirebaseAuth.instance;
  final db_reference = FirebaseDatabase.instance.ref('Post');
  final searchFilterController = TextEditingController();
  final editUpdateController = TextEditingController();

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey(); // Create a key

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: Icon(
                  Icons.home,
                ),
                title: const Text('Page 1'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.train,
                ),
                title: const Text('Page 2'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.logout_outlined,
                ),
                title: const Text('Log out'),
                onTap: () {
                  auth.signOut().then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  });
                },
              ),
              ListTile(
                leading: IconButton(
                    icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
                        ? Icons.dark_mode
                        : Icons.light_mode),
                    onPressed: () {
                      MyApp.themeNotifier.value =
                          MyApp.themeNotifier.value == ThemeMode.light
                              ? ThemeMode.dark
                              : ThemeMode.light;
                    }),
                title: Text("Change Theme"),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Add_PostScreen(),
              ));
        },
        child: Icon(Icons.add,size: 30),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextFormField(
                controller: searchFilterController,
                onChanged: (String value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    prefixIcon: IconButton(
                        onPressed: () {
                          _drawerKey.currentState!.openDrawer();
                        },
                        icon: Icon(Icons.menu)),
                    hintText: "Search your notes",
                    suffixIcon: IconButton(
                        icon: Icon(MyApp.themeNotifier.value == ThemeMode.light
                            ? Icons.dark_mode
                            : Icons.light_mode),
                        onPressed: () {
                          MyApp.themeNotifier.value =
                              MyApp.themeNotifier.value == ThemeMode.light
                                  ? ThemeMode.dark
                                  : ThemeMode.light;
                        }),
                    border: OutlineInputBorder()),
              ),
            ),
            Expanded(
              child: FirebaseAnimatedList(
                query: db_reference,
                itemBuilder: (context, snapshot, animation, index) {
                  final title = snapshot.child('title').value.toString();
                  final subtitle = snapshot.child('subtitle').value.toString();

                  // title ki file seprate hai bit id ki nahi kyunki id ki file seprate krne se
                  // id mismatch hoti hai coz of milliseconds or fir error ata hai jese null

                  if (searchFilterController.text.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Edit_note(),
                              ));
                        },
                        child:
                        ListTile(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          // tileColor: Colors.transparent,
                          // leading: Text(snapshot.child('date_id').value.toString()),

                          title: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  snapshot.child('subtitle').value.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          ),
                          // subtitle: Text(snapshot.child('id').value.toString(),),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    showMyDialog(
                                        title,
                                        snapshot
                                            .child('id')
                                            .value
                                            .toString());
                                  },
                                  leading: Icon(Icons.edit_outlined),
                                  title: Text("Edit"),
                                ),
                              ),
                              PopupMenuItem(
                                  value: 2,
                                  child: ListTile(
                                    leading: Icon(Icons.delete_outlined),
                                    title: Text("Delete"),
                                    onTap: () {
                                      Navigator.pop(context);
                                      db_reference
                                          .child(snapshot
                                              .child('id')
                                              .value
                                              .toString())
                                          .remove();
                                    },
                                  ))
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (title.toLowerCase().contains(
                      searchFilterController.text.toLowerCase().toString())) {
                    return ListTile(
                      tileColor: Colors.orangeAccent.shade100,
                      title: Text(snapshot.child('title').value.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                      subtitle: Text(snapshot.child('id').value.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500)),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showMyDialog(String title, String id) async {
    editUpdateController.text = title;
    return showDialog(
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Container(
            child: TextField(
              maxLines: 2,
              controller: editUpdateController,
              decoration: InputDecoration(hintText: "Edit"),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  db_reference.child(id).update({
                    'note': editUpdateController.text.toLowerCase()
                  }).then((value) {
                    Utils().toastMessage('Post updated');
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                  });
                },
                child: Text('Update')),
          ],
        );
      },
      context: context,
    );
  }
}

//
// Expanded(child: StreamBuilder(
// stream: db_reference.onValue,
// builder: (context, snapshot) {
// if(!snapshot.hasData){
// return CircularProgressIndicator();
// }else{
// Map<dynamic,dynamic> map = snapshot.data!.snapshot.value as dynamic;
// List<dynamic> list = [];
// list.clear();
// list = map.values.toList();
// return ListView.builder(
// itemCount: snapshot.data!.snapshot.children.length,
// itemBuilder: (context, index) {
// return ListTile(
// title: Text(list[index]['note'].toString()),
// subtitle: Text(list[index]['id'].toString()),
// );
// },
// );
//
// }
// },
// )),
