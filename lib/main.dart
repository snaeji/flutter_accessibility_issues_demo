import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter accessibility issues demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter accessibility issues demo page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  bool _extendBody = false;
  List<Widget> bodyList = [SliderPage(), ListTilePage(), NestedListViewPage()];

  void onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Demo"),
          actions: [
            Tooltip(
              message: 'Til baka',
              child: FlatButton(
                child: Text(
                    _extendBody ? "Disable extend body" : "Enable extend body"),
                onPressed: () {
                  setState(() {
                    _extendBody = !_extendBody;
                  });
                },
              ),
            )
          ],
        ),
        body: bodyList[_currentIndex],
        extendBody: _extendBody,
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          onTap: onTap,
          currentIndex: _currentIndex,
          items: [
            // Screen reader speaks the label text two times for each item
            // "Slider page example, Slider page example, tab 1 of 3, double tap to activate.
            BottomNavigationBarItem(
                label: 'Slider page example', icon: Icon(Icons.tv, size: 20.0)),
            BottomNavigationBarItem(
                label: 'Tiles in ListView',
                icon: Icon(Icons.radio, size: 20.0)),
            BottomNavigationBarItem(
                label: 'Nested ListView example',
                icon: Icon(Icons.live_tv, size: 20.0)),
          ],
        ),
      ),
    );
  }
}

class SliderPage extends StatefulWidget {
  const SliderPage({Key key}) : super(key: key);

  @override
  _SliderPageState createState() => _SliderPageState();
}

class _SliderPageState extends State<SliderPage> {
  double sliderValue = 0.0;
  double onChangeEndValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('sliderValue: $sliderValue'),
        Text('onChangeEnd: $onChangeEndValue'),
        Slider(
            value: sliderValue,
            min: 0.0,
            onChangeStart: (e) {
              print("onChangeStart: $e");
            },
            onChanged: (e) {
              print("onChanged: $e");
              setState(() {
                sliderValue = e;
              });
            },
            onChangeEnd: (e) {
              print("onChangeEnd: $e");
              setState(() {
                sliderValue = e;
                onChangeEndValue = e;
              });
            }),
      ],
    );
  }
}

class ListTilePage extends StatefulWidget {
  const ListTilePage({Key key}) : super(key: key);

  @override
  _ListTilePageState createState() => _ListTilePageState();
}

class _ListTilePageState extends State<ListTilePage> {
  double sliderValue = 0.0;
  double onChangeEndValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: List<Widget>.generate(
            200, (index) => ListTile(title: Text('Item number $index'))));
  }
}

class NestedListViewPage extends StatefulWidget {
  @override
  _NestedListViewPageState createState() => _NestedListViewPageState();
}

class _NestedListViewPageState extends State<NestedListViewPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: List<Widget>.generate(
        50,
        (index1) => Container(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: List<Widget>.generate(
                10,
                (index2) => GestureDetector(
                      onTap: () => null,
                      child: Center(child: Text('Row $index1, Line $index2')),
                    )),
          ),
        ),
      ),
    );
  }
}
