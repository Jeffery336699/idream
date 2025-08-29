import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;

void main() {
  doTask1();
  doTask2();
  doTask3();
}

late StreamSubscription<List<int>> subscription;
int fileLength = 0;
int counter = 0;

void doTask2() async {
  File file =
      File(path.join(Directory.current.path, "assets", "Jane Eyre.txt"));
  print("开始读取 Jane Eyre.txt ");
  fileLength = await file.length();
  Stream<List<int>> stream = file.openRead();
  subscription = stream.listen(_onData, onDone: _onDone, onError: (onError){
    print("读取文件出错：$onError");
  }, cancelOnError: true);
}

void _onData(List<int> bytes) async {
  counter += bytes.length;
  double progress = counter * 100 / fileLength;
  DateTime time = DateTime.now();
  String timeStr =
      "[${time.hour}:${time.minute}:${time.second}:${time.millisecond}]";
  print(timeStr + "=" * (progress ~/ 2) + '[${progress.toStringAsFixed(2)}%]');
  if (progress >= 50) {
    ///流的onData并不会被调用
    subscription.cancel();
  }
}

void _onDone() {
  print("_onDone 读取 Jane Eyre.txt 结束");
}

void doTask1() {
  print('doTask1');
}

void doTask3() {
  print('doTask3');
}
