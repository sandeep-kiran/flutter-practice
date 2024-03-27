import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:first_app/users/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum ApiResponseStatus {
  success,
  failure,
  socket,
  timeout,
  error,
}

class ApiClient {
  final ApiResponseStatus responseStatus;
  final String mesage;
  final String? token;
  final dynamic data;

  ApiClient({
    required this.responseStatus,
    required this.mesage,
    this.token,
    this.data,
  });
}

class ApiCall {
  static Future<ApiClient> post({
    required String apiUrl,
    required Map<dynamic, dynamic> body,
    bool requiredToken = true,
    bool printLog = true,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String bearerToken = sharedPreferences.getString('token') ?? "";
    final url = Uri.parse("$baseUrl$apiUrl");

    Map<String, String>? headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': requiredToken ? 'Bearer $bearerToken' : 'null',
    };

    if (printLog) {
      debugPrint("URL == $url");
      debugPrint("BODY == $body");
      debugPrint("HEADERS == $headers");
    }

    try {
      http.Response response = await http
          .post(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      if (printLog) {
        debugPrint("Status Code == ${response.statusCode}");
        debugPrint(
            "Message == ${jsonDecode(response.body)["practice"]["message"]}");
      }
      dynamic responseData = jsonDecode(response.body)["practice"];
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiClient(
            responseStatus: ApiResponseStatus.success,
            mesage: responseData["message"],
            token: responseData["token"],
            data: responseData);
      } else {
        return ApiClient(
            responseStatus: ApiResponseStatus.failure,
            mesage: responseData["message"],
            data: responseData);
      }
    } on SocketException catch (e) {
      if (printLog) {
        debugPrint("SocketException == $e");
      }
      return ApiClient(
          responseStatus: ApiResponseStatus.socket,
          mesage: "Check your internet");
    } on TimeoutException catch (e) {
      if (printLog) {
        debugPrint("Timeout Exception == $e");
      }
      return ApiClient(
          responseStatus: ApiResponseStatus.socket,
          mesage: "Your Internet Seems Slow");
    } catch (e) {
      if (printLog) {
        debugPrint("SocketException == $e");
      }
      return ApiClient(
          responseStatus: ApiResponseStatus.socket,
          mesage: "Something Went Wrong!");
    }
  }

  static Future<ApiClient> patch({
    required String apiUrl,
    required Map<dynamic, dynamic> body,
    bool requiredToken = true,
    bool printLog = true,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String bearerToken = sharedPreferences.getString('token') ?? "";
    final url = Uri.parse("$baseUrl$apiUrl");

    Map<String, String>? headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': requiredToken ? 'Bearer $bearerToken' : 'null',
    };

    if (printLog) {
      debugPrint("URL == $url");
      debugPrint("BODY == $body");
      debugPrint("HEADERS == $headers");
    }

    try {
      http.Response response = await http
          .patch(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      if (printLog) {
        debugPrint("Status Code == ${response.statusCode}");
        debugPrint(
            "Message == ${jsonDecode(response.body)["practice"]["message"]}");
      }
      dynamic responseData = jsonDecode(response.body)["practice"];
      if (response.statusCode == 200) {
        return ApiClient(
            responseStatus: ApiResponseStatus.success,
            mesage: responseData["message"],
            data: responseData);
      } else {
        return ApiClient(
            responseStatus: ApiResponseStatus.failure,
            mesage: responseData["message"],
            data: responseData);
      }
    } on SocketException catch (e) {
      if (printLog) {
        debugPrint("SocketException == $e");
      }
      return ApiClient(
          responseStatus: ApiResponseStatus.socket,
          mesage: "Check your internet");
    } on TimeoutException catch (e) {
      if (printLog) {
        debugPrint("Timeout Exception == $e");
      }
      return ApiClient(
          responseStatus: ApiResponseStatus.socket,
          mesage: "Your Internet Seems Slow");
    } catch (e) {
      if (printLog) {
        debugPrint("SocketException == $e");
      }
      return ApiClient(
          responseStatus: ApiResponseStatus.socket,
          mesage: "Something Went Wrong!");
    }
  }

  static Future<ApiClient> get({
    required String apiUrl,
    bool requiredToken = true,
    bool printLog = true,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String bearerToken = sharedPreferences.getString('token') ?? "";
    final url = Uri.parse("$baseUrl$apiUrl");

    Map<String, String>? headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': requiredToken ? 'Bearer $bearerToken' : 'null',
    };

    if (printLog) {
      debugPrint("URL == $url");
      debugPrint("HEADERS == $headers");
    }

    try {
      http.Response response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 15));
      if (printLog) {
        debugPrint("Status Code == ${response.statusCode}");
        debugPrint(
            "Message == ${jsonDecode(response.body)["practice"]["message"]}");
      }
      dynamic responseData = jsonDecode(response.body)["practice"];
      if (response.statusCode == 200) {
        return ApiClient(
            responseStatus: ApiResponseStatus.success,
            mesage: responseData["message"],
            data: responseData);
      } else {
        return ApiClient(
            responseStatus: ApiResponseStatus.failure,
            mesage: responseData["message"],
            data: responseData);
      }
    } on SocketException catch (e) {
      if (printLog) {
        debugPrint("SocketException == $e");
      }
      return ApiClient(
          responseStatus: ApiResponseStatus.socket,
          mesage: "Check your internet");
    } on TimeoutException catch (e) {
      if (printLog) {
        debugPrint("Timeout Exception == $e");
      }
      return ApiClient(
          responseStatus: ApiResponseStatus.socket,
          mesage: "Your Internet Seems Slow");
    } catch (e) {
      if (printLog) {
        debugPrint("SocketException == $e");
      }
      return ApiClient(
          responseStatus: ApiResponseStatus.socket,
          mesage: "Something Went Wrong!");
    }
  }

  static Future<ApiClient> put({
    required String apiUrl,
    required Map<dynamic, dynamic> body,
    bool requiredToken = true,
    bool printLog = true,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String bearerToken = sharedPreferences.getString('token') ?? "";
    final url = Uri.parse("$baseUrl$apiUrl");

    Map<String, String>? headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': requiredToken ? 'Bearer $bearerToken' : 'null',
    };

    if (printLog) {
      debugPrint("URL == $url");
      debugPrint("BODY == $body");
      debugPrint("HEADERS == $headers");
    }

    try {
      http.Response response = await http
          .put(url, headers: headers, body: jsonEncode(body))
          .timeout(const Duration(seconds: 15));
      if (printLog) {
        debugPrint("Status Code == ${response.statusCode}");
        debugPrint(
            "Message == ${jsonDecode(response.body)["practice"]["message"]}");
      }
      dynamic responseData = jsonDecode(response.body)["practice"];
      if (response.statusCode == 200) {
        return ApiClient(
            responseStatus: ApiResponseStatus.success,
            mesage: responseData["message"],
            data: responseData);
      } else {
        return ApiClient(
            responseStatus: ApiResponseStatus.failure,
            mesage: responseData["message"],
            data: responseData);
      }
    } on SocketException catch (e) {
      if (printLog) {
        debugPrint("SocketException == $e");
      }
      return ApiClient(
          responseStatus: ApiResponseStatus.socket,
          mesage: "Check your internet");
    } on TimeoutException catch (e) {
      if (printLog) {
        debugPrint("Timeout Exception == $e");
      }
      return ApiClient(
          responseStatus: ApiResponseStatus.socket,
          mesage: "Your Internet Seems Slow");
    } catch (e) {
      if (printLog) {
        debugPrint("SocketException == $e");
      }
      return ApiClient(
          responseStatus: ApiResponseStatus.socket,
          mesage: "Something Went Wrong!");
    }
  }
}
