class BaseResponse {
  late bool _status;
  late int _code;
  late String _message;

  bool get status => _status;

  set status(bool value) => _status = value;

  get code => _code;

  set code(value) => _code = value;

  get message => _message;

  set message(value) => _message = value;

  BaseResponse.fromJson(Map<String, dynamic> json) {
    _status = json['status'] ?? false;
    _code = json['code'] ?? 400;
    _message = json['message'] ?? 'not found';
  }
}
