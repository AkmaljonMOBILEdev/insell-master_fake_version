import 'dart:convert';
import 'dart:io';
import 'package:easy_sell/services/storage_services.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

// http services added

class HttpServices {
  static const String _baseUrl = "http://92.51.38.14/api/v1";
  static Storage storage = Storage();
  static Map<String, String> header = {'Content-Type': 'application/json', 'Authorization': ''};
  static Dio dio = Dio();
  static File errorFile = File('error.txt');

  static void writeErrorFile(Object error) {
    String initialText = errorFile.readAsStringSync();
    if (initialText.isEmpty) {
      return;
    }
    DateTime now = DateTime.now();
    errorFile.writeAsStringSync('$initialText\n$error ---- ${now.toString()}\n');
  }

  // get request
  static Future<ResponseDto> get(String route) async {
    try {
      header['Authorization'] = await storage.read('token') ?? '';
      header['Content-Type'] = 'application/json';
      Uri uri = Uri.parse(_baseUrl + route);
      http.Response response = await http.get(uri, headers: header);
      if (response.statusCode != 200 || response.statusCode != 201) {
        writeErrorFile(response.body);
      }
      var result = ResponseDto(utf8.decode(response.bodyBytes), response.statusCode, response.headers);
      return result;
    } catch (e) {
      writeErrorFile(e);
      rethrow;
    }
  }

  // get with percentage of progress
  static Future<Response> getWithProgress(String route, Function(int, int) setProgressPercent, {CancelToken? cancelToken}) async {
    try {
      header['Authorization'] = await storage.read('token') ?? '';
      Uri uri = Uri.parse(_baseUrl + route);
      Response res = await dio.getUri(
        uri,
        onReceiveProgress: (count, total) {
          if (total == -1) {
            setProgressPercent(1, 1);
            return;
          }
          setProgressPercent(count, total);
        },
        options: Options(headers: header),
        cancelToken: cancelToken,
      );
      if (res.statusCode != 200 || res.statusCode != 201) {
        writeErrorFile(res.data);
      }
      return res;
    } on DioException catch (e) {
      writeErrorFile(e);
      rethrow;
    }
  }

  // post request
  static Future<http.Response> post(String route, dynamic body) async {
    try {
      header['Authorization'] = await storage.read('token') ?? '';
      Uri uri = Uri.parse(_baseUrl + route);
      http.Response response = await http.post(uri, body: jsonEncode(body), headers: header);
      if (response.statusCode != 200 || response.statusCode != 201) {
        writeErrorFile(response.body);
      }
      return response;
    } catch (e) {
      writeErrorFile(e);
      rethrow;
    }
  }

  // put request
  static Future<http.Response> put(String route, dynamic body) async {
    try {
      header['Authorization'] = await storage.read('token') ?? '';
      Uri uri = Uri.parse(_baseUrl + route);
      http.Response response = await http.put(uri, body: jsonEncode(body), headers: header);
      if (response.statusCode != 200 || response.statusCode != 201) {
        writeErrorFile(response.body);
      }
      return response;
    } catch (e) {
      writeErrorFile(e);
      rethrow;
    }
  }

  // delete request
  static Future<http.Response> delete(String route) async {
    header['Authorization'] = await storage.read('token') ?? '';
    Uri uri = Uri.parse(_baseUrl + route);
    http.Response response = await http.delete(uri, headers: header);
    return response;
  }

  // patch request
  static Future<http.Response> patch(String route, Map<String, dynamic> body) async {
    try {
      header['Authorization'] = await storage.read('token') ?? '';
      Uri uri = Uri.parse(_baseUrl + route);
      http.Response response = await http.patch(uri, body: jsonEncode(body), headers: header);
      if (response.statusCode != 200 || response.statusCode != 201) {
        writeErrorFile(response.body);
      }
      return response;
    } catch (e) {
      writeErrorFile(e);
      rethrow;
    }
  }
}

class ResponseDto {
  final String body;
  final int statusCode;
  final Map<String, String> headers;

  ResponseDto(this.body, this.statusCode, this.headers);
}
