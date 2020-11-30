import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      // home: MyFirstWidget(),
      home: MySecondWidget(),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
            ),
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
            ),
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const Text(
              'You have pushed the button this many times:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyFirstWidget extends StatelessWidget {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    print(count++);
    return Container(
      child: const Center(
        child: Text('Hello')
      )
    );
  }
}

class MySecondWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MySecondWidgetState();
}

class _MySecondWidgetState extends State<MySecondWidget> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    print(count++);
    return Container(
      child: const Center(
        child: Text('Hello')
      )
    );
  }
}