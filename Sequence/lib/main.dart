import 'package:flutter/material.dart';
import 'home.dart'; // Import HomePage
import 'seq.dart'; // Import GameBoard

void main() {
  // Initialize FFI for sqflite (only for desktop or testing environments)
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print(details.exceptionAsString()); // Log error
  };

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sequence',
      debugShowCheckedModeBanner: false, // Hide debug banner
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (context) => SequenceGameApp(), // HomePage
        '/gameboard': (context) => GameBoard(), // GameBoard
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('Page not found'),
            ),
          ),
        );
      },
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
    );
  }
}
