import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef InstanceBuilderCallback<S> = S Function();
class GetXControllerManager {
  // 全局单例容器
  static final Map<String, _InstanceBuilderFactory> _singl = {};

  // 延迟加载容器
  static final Map<String, _Lazy> _lazySingl = {};

  // 实例缓存
  static final Map<String, Object> _instances = {};

  static Map<String, Object> instances = _instances;

  // 标签映射（用于相同类型的多实例管理）
  static final Map<String, Type> _tags = {};

  // 模拟GetX内部的put方法实现
  static T put<T>(
      T dependency, {
        String? tag,
        bool permanent = false,
        InstanceBuilderCallback<T>? builder,
      }) {
    final key = _getKey(T, tag);

    // 1. 检查是否已存在
    if (_instances.containsKey(key)) {
      return _instances[key] as T;
    }

    // 2. 注册到容器
    _instances[key] = dependency!;

    // 2. 我自己添加的
    if (dependency is GetxController) {
      dependency.permanent = permanent;
    }

    // 3. 设置生命周期管理,如果不是永久的
    if (!permanent) {
      _setupLifecycleManagement<T>(dependency, tag);
    }

    // 4. 初始化Controller（如果是GetxController）
    if (dependency is GetxController) {
      _initializeController(dependency);
    }

    print('🔧 Controller注册: ${T.toString()}${tag != null ? ' (tag: $tag)' : ''}');
    return dependency;
  }

  static T lazyPut<T>(
      InstanceBuilderCallback<T> builder, {
        String? tag,
        bool fenix = false,
      }) {
    final key = _getKey(T, tag);

    // 延迟加载工厂注册
    _lazySingl[key] = _Lazy<T>(
      builder: builder,
      fenix: fenix,
      tag: tag,
    );

    print('⏳ 延迟注册: ${T.toString()}');
    return _EmptyController() as T; // 返回占位符
  }

  static T find<T>({String? tag}) {
    final key = _getKey(T, tag);

    // 1. 先从实例缓存查找
    if (_instances.containsKey(key)) {
      print('✅ 找到缓存实例: ${T.toString()}');
      return _instances[key] as T;
    }

    // 2. 检查延迟加载
    if (_lazySingl.containsKey(key)) {
      final lazy = _lazySingl[key] as _Lazy<T>;
      final instance = lazy.builder();

      // 实例化并缓存
      _instances[key] = instance!;
      _lazySingl.remove(key);

      if (instance is GetxController) {
        _initializeController(instance);
      }

      print('🏗️ 延迟实例化: ${T.toString()}');
      return instance;
    }

    throw Exception('Controller未找到: ${T.toString()}');
  }

  static void _initializeController(GetxController controller) {
    // 设置响应式更新机制
    controller._setGetxControllerContext();

    // 调用生命周期方法
    controller.onInit();

    // 延迟调用onReady
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.onReady();
    });
  }

  static String _getKey(Type type, String? tag) {
    return tag == null ? type.toString() : '${type.toString()}_$tag';
  }

  static void _setupLifecycleManagement<T>(T dependency, String? tag) {
    // 与路由生命周期绑定
    if (Get.routing.current.isBlank == false) {
      final route = Get.routing.route;
      _bindToRoute(route!, dependency, tag);
    }
  }

  static void _bindToRoute<T>(Route route, T dependency, String? tag) {
    // 路由销毁时自动清理Controller
    route.popped.then((_) {
      if (dependency is GetxController && !dependency.permanent) {
        dependency.onClose();
        final key = _getKey(T, tag);
        _instances.remove(key);
        print('🗑️ 自动清理Controller: ${T.toString()}');
      }
    });
  }
}

class _EmptyController extends GetxController {
}

extension GetxControllerContext on GetxController {
  static final _permanentExpando = Expando<bool>();

  void _setGetxControllerContext() {
    // 设置响应式更新机制的逻辑
    // 这里可以集成RxNotifier或其他响应式库
  }

  bool get permanent => _permanentExpando[this] ?? false;
  set permanent(bool value) => _permanentExpando[this] = value;
}

class _Lazy<T> {
  final InstanceBuilderCallback<T> builder;
  final bool fenix;
  final String? tag;

  _Lazy({
    required this.builder,
    this.fenix = false,
    this.tag,
  });
}

// GetX内部的依赖管理容器（简化版原理）
class GetInstance {
  // 全局单例容器
  static final Map<String, _InstanceBuilderFactory> _singl = {};

  // 延迟加载容器
  static final Map<String, _Lazy> _lazySingl = {};

  // 实例缓存
  static final Map<Type, Object> _instances = {};

  static Map<Type, Object> instances = _instances;

  // 标签映射（用于相同类型的多实例管理）
  static final Map<String, Type> _tags = {};
}

// Controller工厂类
class _InstanceBuilderFactory<T> {
  final InstanceBuilderCallback<T> builderFunc;
  final bool permanent;
  final bool isSingleton;
  final String? tag;

  _InstanceBuilderFactory({
    required this.builderFunc,
    this.permanent = false,
    this.isSingleton = true,
    this.tag,
  });
}

