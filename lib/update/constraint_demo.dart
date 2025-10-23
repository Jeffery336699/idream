//书写main函数
import 'package:flutter/material.dart';

main() {
  runApp(
      /**
     * 屏幕强制 UnconstrainedBox 变得和屏幕一样大， 而 UnconstrainedBox 允许其子级的 Container 可以变为任意大小。
     * 不幸的是，在这种情况下，容器的宽度为 4000 像素， 这实在是太大，以至于无法容纳在 UnconstrainedBox 中，
     * 因此 UnconstrainedBox 将显示溢出警告（overflow warning）
     */
      // UnconstrainedBox(
      //   child: Container(color: Colors.red, width: 4000, height: 50),
      // )
      /**
     * 屏幕强制 OverflowBox 变得和屏幕一样大， 并且 OverflowBox 允许其子容器设置为任意大小。
     * OverflowBox 与 UnconstrainedBox 类似，但不同的是，如果其子级超出该空间，它将不会显示任何警告。
     * 在这种情况下，容器的宽度为 4000 像素，并且太大而无法容纳在 OverflowBox 中，但是 OverflowBox 会全部显示，而不会发出警告。
     */
      // OverflowBox(
      //   minWidth: 0.0,
      //   minHeight: 0.0,
      //   maxWidth: double.infinity,
      //   maxHeight: double.infinity,
      //   child: Container(color: Colors.red, width: 4000, height: 50),
      // )
      /**
     * 这将不会渲染任何东西，而且你能在控制台看到错误信息。
     * UnconstrainedBox 让它的子级决定成为任何大小(给的宽高也是无限大小maxWidth Infinity, maxHeight Infinity)，
     * 但是其子级是一个具有无限大小的 Container(父给无限，子又是无限，鬼知道多大，直接报错)
     * Flutter 无法渲染无限大的东西，所以它抛出以下错误： BoxConstraints forces an infinite width.
     */
      //     UnconstrainedBox(child: LayoutBuilder(builder: (context, constraints) {
      //   // constraints===>:maxWidth Infinity, maxHeight Infinity
      //   print('constraints===>:maxWidth ${constraints.maxWidth}, maxHeight ${constraints.maxHeight}');
      //   return Container(
      //     color: Colors.red,
      //     width: double.infinity,
      //     height: 100,
      //   );
      // }))
      /**
     * UnconstrainedBox 给 LimitedBox 一个无限的大小； 但它向其子级传递了最大为 100 的约束。
     * 注：LimitedBox 限制仅在获得无限约束时才适用！！（缓存Center失效）
     * LimitedBox 是条件性的约束（仅无限时），ConstrainedBox 是强制性的约束（始终有效）
     */
      // UnconstrainedBox(
      //         child: LimitedBox(
      //             maxWidth: 100,
      //             child: Container(
      //               color: Colors.red,
      //               width: double.infinity,
      //               height: 100,
      //             )
      //         )
      //     )
      /**
     * 屏幕强制 FittedBox 变得和屏幕一样大（强约束）， 而 Text 则是有一个自然宽度（也被称作 intrinsic 宽度）， 它取决于文本数量，字体大小等因素。
     * FittedBox 让 Text 可以变为任意大小。 但是在 Text 告诉 FittedBox 其大小后， FittedBox 缩放文本直到填满所有可用宽度。
     */
      // FittedBox(
      //     child: Directionality(
      //         textDirection: TextDirection.ltr,
      //         child: Text(
      //           'Some Example Text.',
      //           // 加不加fontSize都一样，会被FittedBox缩放至撑满屏幕
      //           // style: TextStyle(fontSize: 12,color: Colors.green),
      //         )))

      /**
     * Center 将会让 FittedBox 能够变为任意大小， 取决于屏幕大小。(宽松约束)
     * FittedBox 然后会根据 Text 调整自己的大小， 然后让 Text 可以变为所需的任意大小， 由于二者具有同一大小，因此不会发生缩放。
     */
      // Center(
      //         child: FittedBox(
      //           child: Text('Some Example Text.'),
      //         )
      //     )

      /**
     * FittedBox 位于 Center 中， 但 Text 太大而超出屏幕，会发生什么？
     * FittedBox 会尝试根据 Text 大小调整大小， 但不能大于屏幕大小。然后假定屏幕大小， 并调整 Text 的大小以使其也适合屏幕。
     */
      // Center(
      //     child: FittedBox(
      //       child: Directionality(
      //                 textDirection: TextDirection.ltr,
      //                 child: Text('This is some very very very large text that is too big to fit a regular screen in a single line.'),
      //       ))
      // )

      /**
     * 如果你删除了 FittedBox， Text 则会从屏幕上获取其最大宽度， 并在合适的地方换行。
     */
      // Center(
      //     child: Directionality(
      //     textDirection: TextDirection.ltr,
      //     child: Text(
      //         'This is some very very very large text that is too big to fit a regular screen in a single line.' * 2),))

    /**
     * FittedBox 只能在有限制的宽高中 对子 widget 进行缩放（宽度和高度不会变得无限大）。
     * 否则，它将无法渲染任何内容，并且你会在控制台中看到错误。
     */
      // FittedBox(
      //     child: Container(
      //       height: 20.0,
      //       width: double.infinity,
      //     )
      // )
    /**
     * 屏幕强制 Row 变得和屏幕一样大，所以 Row 充满屏幕。
     * 和 UnconstrainedBox 一样， Row 也不会对其子代施加任何约束， 而是让它们成为所需的任意大小。
     * Row 然后将它们并排放置， 任何多余的空间都将保持空白。
     */
  // Directionality(
  //       textDirection: TextDirection.ltr,
  //       child: Row(
  //           children:[
  //             Container(color: Colors.red, child: Text('Hello!')),
  //             Container(color: Colors.green, child: Text('Goodbye!')),
  //           ]
  //       ),
  //     )

    /**
     * 由于 Row 不会对其子级施加任何约束， 因此它的 children 很有可能太大 而超出 Row 的可用宽度。
     * 在这种情况下， Row 会和 UnconstrainedBox 一样显示溢出警告。
     */
    // Directionality(
    // textDirection: TextDirection.ltr,
    // child: Row(
    //     children:[
    //       Container(color: Colors.red, child: Text('This is a very long text that won’t fit the line.'*3)),
    //       Container(color: Colors.green, child: Text('Goodbye!')),
    //     ]
    //   )
    // )
    /**
     * 当 Row 的子级被包裹在了 Expanded widget 之后， Row 将不会再让其决定自身的宽度了。
     * Row 会根据所有 Expanded 的子级 来计算其该有的宽度，同时默认的Text会根据maxWidth来换行显示，不会溢出。
     */
      // Directionality(
      // textDirection: TextDirection.ltr,
      // child: Row(
      //     children:[
      //       Expanded(
      //           child: Container(color: Colors.red, child: Text('This is a very long text that won’t fit the line.'*3))
      //       ),
      //       Container(color: Colors.green, child: Text('Goodbye!')),
      //     ]
      //   )
      // )

    /**
     * 如果所有 Row 的子级都被包裹了 Expanded widget， 每一个 Expanded 大小都会与其 flex 因子成比例，
     * 并且 Expanded widget 将会强制其子级具有与 Expanded 相同的宽度。
     * 换句话说，Expanded 忽略了其子 Widget 想要的宽度。
     */
  // Directionality(
  //         textDirection: TextDirection.ltr,
  //         child: Row(children: [
  //           Expanded(
  //             child: Container(
  //                 color: Colors.red,
  //                 child: Text(
  //                     'This is a very long text that won’t fit the line.' * 3)),
  //           ),
  //           Expanded(
  //             child: Container(
  //               color: Colors.green,
  //               child: Text('Goodbye!'),
  //             ),
  //           )
  //         ]))
  /**
   * Flexible 会让其子级具有与 Flexible 相同或者更小的宽度。 而 Expanded 将会强制其子级具有和 Expanded 相同的宽度。
   * 但无论是 Expanded 还是 Flexible 在它们决定子级大小时都会忽略其宽度。
   * Optimize: Row 要么使用子级的宽度，要么使用Expanded 和 Flexible 从而忽略子级的宽度。
   */
  // Directionality(
  //         textDirection: TextDirection.ltr,
  //         child: Row(children: [
  //           Flexible(
  //               child: Container(color: Colors.red,
  //                   child: Text(
  //                       'This is a very long text that won’t fit the line.'*2))),
  //           Flexible(
  //               child: Container(color: Colors.green, child: Text('Goodbye!'))),
  //           ]
  //         )
  //     )
    /**
     * 屏幕强制 Scaffold 变得和屏幕一样大， 所以 Scaffold 充满屏幕。
     * 然后 Scaffold 告诉 Container 可以变为任意大小， 但不能超出屏幕(宽松约束)
     * Optimize: 当一个 widget 告诉其子级可以比自身更小的话， 我们通常称这个 widget 对其子级使用 宽松约束（loose）
     */
    // Directionality(
    //         textDirection: TextDirection.ltr,
    //         child: Scaffold(
    //             body: LayoutBuilder(
    //               builder: (BuildContext context, BoxConstraints constraints) {
    //                 // constraints(isTight=false)===>:maxWidth 502, maxHeight 906
    //                 print('constraints(isTight=${constraints.isTight})===>:maxWidth '
    //                     '${constraints.maxWidth}, maxHeight ${constraints.maxHeight}');
    //                 return  Container(
    //                   color: Colors.blue,
    //                   child: Column(
    //                       children: [
    //                         Text('Hello!'),
    //                         Text('Goodbye!'),
    //                       ]
    //                   ));},
    //             ))
    // )
    /**
     * 如果你想要 Scaffold 的子级变得和 Scaffold 本身一样大的话， 你可以将这个子级外包裹一个 SizedBox.expand(转为紧约束)
     * Optimize: 当一个 widget 告诉它的子级必须变成某个大小的时候， 我们通常称这个 widget 对其子级使用 严格约束（tight）
     */
      Directionality(
            textDirection: TextDirection.ltr,
            child: Scaffold(
                body: SizedBox.expand(
                    child: LayoutBuilder(
                      builder: (BuildContext context, BoxConstraints constraints) {
                        // constraints(isTight=true)===>:maxWidth 502, maxHeight 906
                        print('constraints(isTight=${constraints.isTight})===>:maxWidth ${constraints.maxWidth}, maxHeight ${constraints.maxHeight}');
                        return Container(
                          color: Colors.blue,
                          child: Column(
                            children: [
                              Text('Hello!'),
                              Text('Goodbye!'),
                            ],
                          ));
                      },
                    )))
      )


  );
}
