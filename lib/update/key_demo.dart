import 'dart:async';

import 'package:flutter/material.dart';
import 'package:idream/utils/random_color.dart';

void main() {
  runApp(const MyApp());
}

void printNumber(){
  int num = 0;
  for(int i = 0; i < 10; i++){
    num++;
  }
  print(num);
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Key Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue,),
      home: Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  // List<Widget> widgets = [
  //   StatelessContainer(),
  //   StatelessContainer(),
  // ];

  // List<Widget> widgets = [
  //   StatefulContainer(),
  //   StatefulContainer(),
  // ];

  ///为了提升性能 Flutter 的比较算法（diff）是有范围的，它并不是对第一个 StatefulWidget 进行比较，而是对某一个层级的 Widget 进行比较。
  ///下面color每次会有变化，可以看出context(Element)每次都是新的
  // List<Widget> widgets = [
  //   Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: StatefulContainer(key: UniqueKey())
  //   ),
  //   Padding(
  //     padding: const EdgeInsets.all(8.0),
  //     child: StatefulContainer(key: UniqueKey())
  //   ),
  // ];

  ///这种在上面的基础上就是正确交换了，注意UniqueKey的位置
  List<Widget> widgets = [
    Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.all(8.0),
      child: StatefulContainer(),
    ),
    Padding(
      key: UniqueKey(),
      padding: const EdgeInsets.all(8.0),
      child: StatefulContainer(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    var canUpdate = Widget.canUpdate(widgets[0], widgets[1]);
    print('canUpdate-- $canUpdate');
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgets,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: switchWidget,
        child: Icon(Icons.undo),
      ),
    );
  }

  switchWidget(){
    widgets.insert(0, widgets.removeAt(1));
    setState(() {});
  }
}


class StatelessContainer extends StatelessWidget {
  final Color color = RandomColor().randomColor();

  StatelessContainer({super.key}){
    print('StatelessContainer-- ${this.hashCode}');
  }

  @override
  Widget build(BuildContext context) {
    // StatelessContainer-- 309030935
    // StatelessContainer-- 295484734
    // canUpdate-- true
    // 309030935，context-- 690188816
    // 295484734，context-- 902831466
    // canUpdate-- true
    // 295484734，context-- 690188816
    // 309030935，context-- 902831466
    ///无状态组件点击切换后,配置widget发生变化了,同时canUpdate为true,所以Element表现为复用，但是build UI直接采用了新的配置widget（结果变化）
    print('${context.widget.hashCode}，context-- ${context.hashCode}');
    return Container(
      width: 100,
      height: 100,
      color: color,
    );
  }
}

class StatefulContainer extends StatefulWidget {
   StatefulContainer({super.key}){
    print('StatefulContainer-- ${this.hashCode}');
   }

  @override
  _StatefulContainerState createState() => _StatefulContainerState();
}

class _StatefulContainerState extends State<StatefulContainer> {
  final Color color = RandomColor().randomColor();

  @override
  Widget build(BuildContext context) {
    // StatefulContainer-- 731155863
    // StatefulContainer-- 852487528
    // canUpdate-- true
    // 731155863,context-- context.hashCode:647538802
    // 852487528,context-- context.hashCode:289279353
    // canUpdate-- true
    // 852487528,context-- context.hashCode:647538802
    // 731155863,context-- context.hashCode:289279353
    ///有状态组件点击切换后,虽然配置widget发生变化了,但是canUpdate为true,所以Element表现为复用，采用与之对应的state对象来build UI（结果不变）
    print('${context.widget.hashCode},context-- context.hashCode:${context.hashCode}');
    return Container(
      width: 100,
      height: 100,
      color: color,
    );
  }
}



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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

Future futureA(){
  return Future.delayed(Duration(seconds: 5),() => print('finish..'),).timeout(Duration(seconds: 3), onTimeout: (){
    print('超时了');
  });
}
