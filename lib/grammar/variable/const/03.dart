/**
 * 在第 7 行 `p0 = Person('toly');` 中，变量 `p0` 被重新赋值了。

    - **初始状态**:
    - `p0` 和 `p1` 都指向同一个由 `const Person('张风捷特烈')` 创建的编译时常量对象。因此，它们在内存中是同一个对象，`identical` 返回 `true`，`hashCode` 也相同。

    - **变化**:
    - 第 7 行代码执行后，`p0` 指向了一个新创建的 `Person('toly')` 对象。
    - `p1` 仍然指向原来的 `const Person('张风捷特烈')` 对象（`p1` 是 `const` 变量，不能被重新赋值）。

    - **最终状态**:
    - 此时 `p0` 和 `p1` 指向了内存中完全不同的两个对象。因此，在第 9 行调用 `identical(p0, p1)` 会返回 `false`。
 */
main() {
  Person p0 = const Person('张风捷特烈'); // const 修饰构造
  const Person p1 = Person('张风捷特烈'); // const 修饰量

  print('p0:${p0.hashCode}, p1:${p1.hashCode}');
  print(identical(p0, p1));
  p0 = Person('toly');
  // p1 = Person('toly');
  print(identical(p0, p1));
}

class Person {
  final String name;

  const Person(this.name);
}
