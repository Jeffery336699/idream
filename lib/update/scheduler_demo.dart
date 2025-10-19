import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scheduler Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Screen(),
    );
  }
}

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  int counter = 0;

  @override
  void initState() {
    super.initState();
    // 使用 SchedulerBinding 在下一帧渲染之前执行任务
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("First frame rendered. Counter: $counter");
    });
    // 使用 SchedulerBinding 安排一个空闲任务，（推荐写在 initState 里，写在下面_incrementCounter没有效果）
    WidgetsBinding.instance.scheduleTask(
            () => print('Idle task executed. Current counter: $counter'),
        Priority.idle,
        debugLabel: 'IdleTask').then((value) => print('1111111111111111111111'));

    /// FrameCallback开始时（仅当前帧一次回调），真需要在空闲时执行任务还得使用上述scheduleTask方法
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      print("Frame scheduled. Current counter: $counter");
      // 这里并没有执行到...
      if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.idle) {
        // 执行数据预加载、缓存清理等非紧急任务
        print('===================》》》》》_preloadData()');
      }
    });
  }

  void _incrementCounter() {
    setState(() {
      counter++;
    });

    // 使用 SchedulerBinding 在下一帧渲染之前执行任务（仅当前帧一次回调）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("PostFrame incremented to $counter");
    });

    // 每帧的持久回调（多次回调，有多个帧的话）
    // WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
    //   print(
    //       'Persistent frame callback at $timeStamp. Current counter: $counter');
    // });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduler Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
