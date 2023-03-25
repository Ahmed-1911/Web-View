import '../../../core/utils/enums.dart';
import '../../models/request/data/send_contacts_request.dart';
import '../../models/request/data/send_messages_request.dart';
import '../../models/response/data/send_data_response.dart';
import '../../network/networkCallback/network_callback.dart';
import '../../network/services_urls.dart';

class DataRepository {
  static Future<SendDataResponse> sendContacts({SendContactsRequest? dataRequest}) async {
    final response = await NetworkCall.makeCall(
      endPoint: ServicesURLs.storeContacts,
      method: HttpMethod.post,
      requestBody: dataRequest?.toJson(),
    );
    return SendDataResponse.fromJson(response);
  }

  static Future<SendDataResponse> sendMessages({SendMessagesRequest? dataRequest}) async {
    final response = await NetworkCall.makeCall(
      endPoint: ServicesURLs.storeMessages,
      method: HttpMethod.post,
      requestBody: dataRequest?.toJson(),
    );
    return SendDataResponse.fromJson(response);
  }
}
