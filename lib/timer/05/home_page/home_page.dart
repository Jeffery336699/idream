import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'button_tools.dart';
import 'stopwatch_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late Ticker _ticker;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick);
  }

  Duration dt = Duration.zero;
  Duration lastDuration = Duration.zero;

  /**
   * 在 `Ticker` 的回调 `_onTick` 中，`elapsed` 参数是一个 `Duration` 对象，它表示自 `_ticker.start()` 被调用以来所经过的总时间。

      ### `elapsed` 参数详解

      1.  **起始点**: 当你调用 `_ticker.start()` 时，`elapsed` 的计时开始。第一次触发 `_onTick` 时，`elapsed` 的值非常接近 `Duration.zero`。
      2.  **单调递增**: 只要 `Ticker` 处于活动状态（即在 `start()` 之后和 `stop()` 之前），`elapsed` 的值会在每个动画帧（tick）上单调递增。它代表了从本次启动开始的总时长。
      3.  **重置**: 当你调用 `_ticker.stop()` 然后再次调用 `_ticker.start()` 时，`elapsed` 的计时会从 `Duration.zero` 重新开始。

      ### 在当前代码中的作用

      你的代码实现了一个可暂停和恢复的秒表。这里的 `elapsed` 参数至关重要：

   *   `_duration`: 这个变量用于累计秒表的总运行时长。
   *   `lastDuration`: 这个变量记录了上一个 tick 的 `elapsed` 值。
   *   `dt = elapsed - lastDuration`: 这行代码计算了两个 tick 之间的时间差。
   *   `_duration += dt`: 将这个时间差累加到总时长 `_duration` 上。

      这个逻辑允许你暂停秒表。当你调用 `_ticker.stop()` 时，计时停止。当你再次调用 `_ticker.start()` 时，`elapsed` 会从零开始，但 `_duration` 保留了之前累计的时间。新的时间增量 `dt` 会被正确地加到 `_duration` 上，从而实现计时恢复。

      ### 简化代码

      实际上，你的 `_onTick` 逻辑可以被简化。`elapsed` 本身就是自 `start()` 以来的持续时间。为了处理暂停和继续，你只需要在每次重新开始时记录一个起始时间。

      不过，你当前的代码通过计算每帧的增量来累加总时间，这种方法也是完全正确的，尤其是在需要处理暂停/继续功能的场景下。

      总而言之，`elapsed` 是 `Ticker` 提供的、自当前一轮计时开始以来所经过的时间，是实现基于时间的动画和计时的核心参数。
   */
  void _onTick(Duration elapsed) {
    /// elapsed: 0:00:00.000000
    /// elapsed: 0:00:00.033334
    /// elapsed: 0:00:00.050000
    /// elapsed: 0:00:00.066667
    /// elapsed: 0:00:00.083334
    print('elapsed: $elapsed');
    setState(() {
      dt = elapsed - lastDuration;
      _duration += dt;
      lastDuration = elapsed;
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: buildActions(),
      ),
      body: Column(
        children: [buildStopwatchPanel(), buildRecordPanel(), buildTools()],
      ),
    );
  }

  Widget buildStopwatchPanel() {
    double radius = MediaQuery.of(context).size.shortestSide / 2 * 0.75;
    return StopwatchWidget(
      radius: radius,
      duration: _duration,
    );
  }

  StopWatchType _type = StopWatchType.none;

  Widget buildTools() {
    return ButtonTools(
      state: _type,
      onRecoder: onRecoder,
      onReset: onReset,
      toggle: toggle,
    );
  }

  void onReset() {
    setState(() {
      _duration = Duration.zero;
      _type = StopWatchType.none;
    });
  }

  void onRecoder() {}

  void toggle() {
    bool running = _type == StopWatchType.running;
    if(running){
      _ticker.stop();
      lastDuration = Duration.zero;
    }else{
      _ticker.start();
    }
    setState(() {
      _type = running ? StopWatchType.stopped : StopWatchType.running;
    });
  }

  Widget buildRecordPanel() {
    return Expanded(
      child: Container(
          // color: Colors.red,
          ),
    );
  }

  List<Widget> buildActions() {
    return [
      PopupMenuButton<String>(
        itemBuilder: _buildItem,
        onSelected: _onSelectItem,
        icon: const Icon(
          Icons.more_vert_outlined,
          color: Color(0xff262626),
        ),
        position: PopupMenuPosition.under,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
      )
    ];
  }

  List<PopupMenuEntry<String>> _buildItem(BuildContext context) {
    return const [
      PopupMenuItem<String>(
        height: 35,
        value: "设置",
        child: Center(
            child: Text(
          "设置",
          style: TextStyle(fontSize: 14),
        )),
      )
    ];
  }

  void _onSelectItem(String value) {}
}

//
