void main() {
  foo();
  foo1();
}
void foo(){
  try {
    print(getMean("card"));
  } catch (e,s) {
    print("${e.runtimeType}: ${e.toString()}");
    print("${s.runtimeType}: ${s.toString()}");
  }
}
void foo1(){
  try {
    getMean("card2");
  } on NoElementInDictException catch(e,s){
    // 特定种类的异常处理
    print("1111 ${e.runtimeType}: ${e.toString()}");
    // 打印出栈信息，在控制台能直接定位到代码行
    print("2222 ${s.runtimeType}: ${s.toString()}");
  } catch (e,s) {
    // 其余异常处理
  } finally{
    print("finally bloc call");
  }
}

void foo2(){
  try {
    getMean("about");
  } catch (e,s) {
    print("${e.runtimeType}: ${e.toString()}");
    print("${s.runtimeType}: ${s.toString()}");
  } finally{
    print("finally bloc call");
  }
}

String getMean(String arg) {
  if(arg.isEmpty){
    throw Exception("empty arg!");
  }
  Map<String, String> dict = {"card": "卡片", "but": "但是"};
  String? result = dict[arg];
  if (result == null) {
    throw NoElementInDictException("empty $arg mean in dict");
  }
  return result;
}

class NoElementInDictException implements Exception{
  final String arg;

  NoElementInDictException(this.arg);

  @override
  String toString() => "empty $arg mean in dict";
}
