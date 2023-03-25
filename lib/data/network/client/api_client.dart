import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../services_urls.dart';

class ApiClient {
  static Map<String, String> headers() {
    var mHeaders = {
      HttpHeaders.acceptHeader: 'application/json',
    };
    mHeaders[HttpHeaders.contentLanguageHeader] = 'en';

    return mHeaders;
  }

  static Future<Response> getRequest(
      String endPoint, Map<String, dynamic> queryParams) async {
    //create url with (baseUrl + endPoint) and query Params if any
    String queryString = Uri(queryParameters: queryParams).query;
    String url = queryString.isEmpty
        ? ServicesURLs.developmentEnvironment + endPoint
        : '${ServicesURLs.developmentEnvironment}$endPoint?$queryString';
    //network logger
    log("$url\n${headers()}");

    //GET network request call
    final response = await http.get(
      Uri.parse(url),
      headers: headers(),
    );

    return response;
  }

  static Future<http.Response> postRequest(String endPoint, dynamic requestBody,
      {bool isMultipart = false,
      List<http.MultipartFile>? multiPartValues}) async {
    //create url of (baseUrl + endPoint)
    String url = ServicesURLs.developmentEnvironment + endPoint;
    //network logger
    log("$url\n${headers()}");
    if (requestBody != null) log(requestBody.toString());
    //POST network request call

    http.Response response;
    if (!isMultipart) {
      response = await http.post(Uri.parse(url),
          headers: headers(), body: requestBody);
    } else {
      log("*****MultiPartRequest*****");
      var uri = Uri.parse(url);
      Map<String, dynamic> p = requestBody;
      Map<String, String> convertedMap = {};
      p.forEach((key, value) {
        convertedMap[key] = value;
      });

      var request = http.MultipartRequest('POST', uri)
        ..headers.addAll(headers())
        ..fields.addAll(convertedMap)
        ..files.addAll(multiPartValues ?? []);

      response = await http.Response.fromStream(await request.send());
    }

    return response;
  }

  static Future<http.Response> putRequest(String endPoint, dynamic requestBody,
      {bool isMultipart = false,
      List<http.MultipartFile>? multiPartValues}) async {
    //create url of (baseUrl + endPoint)
    String url = ServicesURLs.developmentEnvironment + endPoint;
    //network logger
    log("$url\n${headers()}");
    if (requestBody != null) log(requestBody.toString());
    //POST network request call

    http.Response response;
    if (!isMultipart) {
      response =
          await http.put(Uri.parse(url), headers: headers(), body: requestBody);
    } else {
      log("****MultiPart*****");
      var uri = Uri.parse(url);
      Map<String, dynamic> p = requestBody;
      Map<String, String> convertedMap = {};
      p.forEach((key, value) {
        convertedMap[key] = value;
      });

      var request = http.MultipartRequest('PUT', uri)
        ..headers.addAll(headers())
        ..fields.addAll(convertedMap)
        ..files.addAll(multiPartValues ?? []);

      response = await http.Response.fromStream(await request.send());
    }

    return response;
  }

  static Future<Response> deleteRequest(
      String endPoint, Map<String, dynamic> queryParams) async {
    //create url with (baseUrl + endPoint) and query Params if any
    String queryString = Uri(queryParameters: queryParams).query;
    String url = queryString.isEmpty
        ? ServicesURLs.developmentEnvironment + endPoint
        : '${ServicesURLs.developmentEnvironment}$endPoint?$queryString';
    //network logger
    log("$url\n${headers()}");

    //GET network request call
    final response = await http.delete(
      Uri.parse(url),
      headers: headers(),
    );
    return response;
  }
}
