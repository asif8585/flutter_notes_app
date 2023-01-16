import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter_int/ui/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final ValueNotifier<ThemeMode> themeNotifier =
  ValueNotifier(ThemeMode.light);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: MyApp.themeNotifier,
      builder: (context, ThemeMode currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(useMaterial3: true,primarySwatch: Colors.orange,listTileTheme: ListTileThemeData(tileColor: Colors.transparent,)),
          darkTheme: ThemeData.dark( useMaterial3: true),
          themeMode: currentMode,
          home: Splash_screen(),
        );
      },
    );
  }
}
