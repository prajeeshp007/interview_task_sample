import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:interview_task_sample/controller/home_screen_controller/home_screen_Controller.dart';
import 'package:interview_task_sample/firebase_options.dart';
import 'package:interview_task_sample/view/home_screen/home_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => homescreencontroller(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
