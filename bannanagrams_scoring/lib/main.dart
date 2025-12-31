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
  Navigator.of(context).push(MaterialPageRoute(builder: 
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFFFF5C2),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Yellow background
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 246, 244, 230),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        // Camera icon on top
                        const Icon(Icons.camera_alt_outlined, size: 40),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'score a game!',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Expanded(flex: 2, child: SizedBox()), // Bottom spacing
          ],
        ),
      ),
    );
  }
}
