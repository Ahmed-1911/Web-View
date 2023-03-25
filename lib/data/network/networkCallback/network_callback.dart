import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart';

import '../../../core/utils/enums.dart';
import '../client/api_client.dart';

class NetworkCall {
  static Future<Map<String, dynamic>> makeCall(
      {required String endPoint,
      required HttpMethod method,
      dynamic requestBody,
      Map<String, dynamic>? queryParams,
      bool isMultipart = false,
      List<MultipartFile>? multiPartValues}) async {
    try {
      late Response response;
      if (method == HttpMethod.get) {
        response = (await ApiClient.getRequest(endPoint, queryParams ?? {}));
      } else if (method == HttpMethod.post) {
        response = (await ApiClient.postRequest(endPoint, requestBody,
            isMultipart: isMultipart, multiPartValues: multiPartValues));
      } else if (method == HttpMethod.put) {
        response = (await ApiClient.putRequest(endPoint, requestBody,
            isMultipart: isMultipart, multiPartValues: multiPartValues));
      } else if (method == HttpMethod.delete) {
        response = (await ApiClient.deleteRequest(endPoint, queryParams ?? {}));
      }

      if (response.statusCode == NetworkStatusCodes.OK_200.value) {
        //Api logger
        log("Api Response: ${response.body}");
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else if (response.statusCode ==
              NetworkStatusCodes.ServerInternalError.value ||
          response.statusCode == NetworkStatusCodes.BadRequest.value) {
        //Api logger
        log("API Error: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}");
        return {
          "status": false,
          "code": response.statusCode,
          "message": 'internal server error'
        };
      } else if (response.statusCode ==
          NetworkStatusCodes.UnAuthorizedUser.value) {
        var result = jsonDecode(response.body) as Map<String, dynamic>;

        //Api logger
        log("API Error: ${response.statusCode} - ${response.reasonPhrase} - $result");
        return {
          "status": false,
          "code": response.statusCode,
          "message": result['message']
        };
      } else {
        //Api logger
        log("API Error: ${response.statusCode} - ${response.reasonPhrase} - ${response.body}");
        return {
          "status": false,
          "code": response.statusCode,
          "message": response.reasonPhrase
        };
      }
    } on SocketException catch (_) {
      return {
        "status": false,
        "code": 0,
        "message": 'no internet connection'
      };
    } on Exception catch (_) {
      return {"status": false, "code": 0, "message": _.toString()};
    }
  }
}
