import 'package:flutter/material.dart';
import 'screens/gallery_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bannanagrams Scoring',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor:const Color.fromARGB(255, 220, 208, 39)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Bannanagrams Scoring'),
    );
  }
}
void _navigatetoCamera (BuildContext context) async{
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: 
  (context) => const GalleryScreen()));
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Expanded(flex: 1, child: SizedBox()), // Top spacing
            const Text('Lets Play!', 
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
            const Expanded(flex: 3, child: SizedBox()), // Middle spacing
            Image.asset('assets/banana.png', width: 100, height: 100),
            const Expanded(flex: 1, child: SizedBox()),
            InkWell(
              onTap: () {
                _navigatetoCamera(context);
              },
              child: const Icon(Icons.camera_alt_outlined),
            ),
            const Expanded(flex: 2, child: SizedBox()), // Bottom spacing
          ],
        ),
      ),
    );
  }
}
