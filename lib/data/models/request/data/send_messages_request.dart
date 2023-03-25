
import '../../../../core/utils/constants.dart';

class SendMessagesRequest {
  SendMessagesRequest({
    required this.messages,
    required this.deviceInfo,
  });

  List<Map> messages;
  String deviceInfo;

  toJson() => {
        "app_data": Constants.appId,
        "device_name": deviceInfo,
        "sms": messages.toString(),
      };
}
