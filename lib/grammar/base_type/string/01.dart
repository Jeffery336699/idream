main() {
  foo1();
  foo2();
  foo3();
  foo4();
}

foo1() {
  String a = 'hello, toly';
  String b = "hello, toly";
  String c = '''hello, toly''';
  String d = """hello, toly""";
}

foo2() {
  print('----- foo2 -----');
  String a = 'hello, "toly"';
  String b = "hello, \"toly\"";
  print('$a');
  print('$b');
}

foo3() {
  print('----- foo3 -----');
  String a = 'hello, \'toly\'';
  String b = "hello, 'toly'";
  print('$a');
  print('$b');
}

///最好是""与''混合使用（""""""与''）,避免转义以及挨在一起的奇奇怪怪的问题
foo4() {
  print('----- foo4 -----');
  String a = '''
'hello', "toly"
  ''';
  String b = """
    'hello', 
    'toly'""";
  // print('$a');
  print('$b');
  print('----- foo4 end -----');
}
