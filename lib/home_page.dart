import 'package:flutter/material.dart';
import 'page1.dart';
import 'page2.dart';
import 'page3.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Page1(),
    Page2(),
    Page3(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: DefaultTextStyle(
        style: TextStyle(color: Colors.black),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Page 1',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Page 2',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Page 3',
            ),
          ],
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedIconTheme: IconThemeData(color: Colors.black),
          unselectedItemColor: Colors.black,
          unselectedLabelStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
