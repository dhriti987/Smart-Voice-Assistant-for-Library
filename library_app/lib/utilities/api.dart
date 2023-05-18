import 'package:dio/dio.dart';

var apiOptions = BaseOptions(
  baseUrl: 'http://192.168.183.226:5000/',
  connectTimeout: const Duration(seconds: 5),
);
Dio api = Dio(apiOptions);

Dio imageApi = Dio(BaseOptions(
    responseType: ResponseType.bytes,
    headers: Map.from({
      'Accept': '*/*',
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/111.0.0.0 Safari/537.36'
    })));
