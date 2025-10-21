import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CacheInterceptor extends Interceptor {
  final Map<String, String> etagMap = {}; // 缓存 ETag
  final Map<String, String> lastModifiedMap = {}; // 缓存 Last-Modified

  Future<String> _getCacheFilePath(String url) async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/${url.hashCode}.cache';
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 在请求头中带上 ETag 或 Last-Modified
    final etag = etagMap[options.uri.toString()];
    final lastModified = lastModifiedMap[options.uri.toString()];

    if (etag != null) {
      options.headers['If-None-Match'] = etag;
    }
    if (lastModified != null) {
      options.headers['If-Modified-Since'] = lastModified;
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final url = response.requestOptions.uri.toString();

    if (response.statusCode == 200) {
      // 缓存 ETag & Last-Modified
      if (response.headers['etag']?.isNotEmpty == true) {
        etagMap[url] = response.headers['etag']!.first;
      }
      if (response.headers['last-modified']?.isNotEmpty == true) {
        lastModifiedMap[url] = response.headers['last-modified']!.first;
      }

      // 写入缓存文件
      final filePath = await _getCacheFilePath(url);
      final file = File(filePath);
      await file.writeAsString(jsonEncode(response.data));
      handler.next(response);
      /// 304默认走到onError,需要把它转到onResponse，dio.options.validateStatus 里也要加上304(见定义处)
    } else if (response.statusCode == 304) {
      // 读取本地缓存
      final filePath = await _getCacheFilePath(url);
      final file = File(filePath);
      if (await file.exists()) {
        final cachedData = jsonDecode(await file.readAsString());
        handler.resolve(Response(
          requestOptions: response.requestOptions,
          data: cachedData,
          statusCode: 200, // 转为 200，方便后续逻辑处理
        ));
      } else {
        handler.next(response);
      }
    } else {
      super.onResponse(response, handler);
    }
  }
}
