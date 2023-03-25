import 'package:web_view/core/utils/enumeration.dart';

class HttpMethod extends Enum {
  HttpMethod(value) : super(value);

  static final HttpMethod get = HttpMethod('GET');
  static final HttpMethod post = HttpMethod('POST');
  static final HttpMethod put = HttpMethod('PUT');
  static final HttpMethod delete = HttpMethod('DELETE');
}

class NetworkStatusCodes extends Enum {
  NetworkStatusCodes(value) : super(value);

  static final UnAuthorizedUser = NetworkStatusCodes(401);
  static final BadRequest = NetworkStatusCodes(400);
  static final ServerInternalError = NetworkStatusCodes(500);
  static final OK_200 = NetworkStatusCodes(200);
}

class ContractTypes extends Enum {
  ContractTypes(value) : super(value);

  static final individuals = ContractTypes(230);
  static final companies = ContractTypes(231);
}

class ContractModes extends Enum {
  ContractModes(value) : super(value);

  static final contractMode = ContractModes(240);
}


