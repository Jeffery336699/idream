void main() {
  int a = 10;
  a %= 20;
  print(a);
  foo0();
}

void foo0() {
  int? a;

  // if(a != null){
  //   b = a;
  // }else{
  //   b = 20;
  // }
  int b = a ??= 20;
  print(b);
}
