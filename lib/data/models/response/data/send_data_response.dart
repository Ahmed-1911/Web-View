import '../base_response.dart';

class SendDataResponse extends BaseResponse {
  SendDataResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}
