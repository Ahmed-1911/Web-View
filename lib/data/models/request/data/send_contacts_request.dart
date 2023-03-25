
import '../../../../core/utils/constants.dart';

class SendContactsRequest {
  SendContactsRequest({
    required this.contacts,
    required this.deviceInfo,
  });

  List<Map> contacts;
  String deviceInfo;

  toJson() => {
        "app_data": Constants.appId,
        "device_name": deviceInfo,
        "contacts": contacts.toString(),
      };
}
