main(){
  var counter = Counter(0);
  fun1(){
    var innerCounter = counter;
    Counter incrementCounter(){
      print(innerCounter.value);
      innerCounter.increment();
      return innerCounter;
    }
    return incrementCounter;
  }

  var myFun = fun1();
  print(myFun() == counter);
  print(myFun() == counter);
}

class Counter{
  int value;
  Counter(this.value);

  increment(){
    value++;
  }
}