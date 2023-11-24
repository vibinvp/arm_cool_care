class CancleandRefund {
  String status;
  String message;
  String key;

  CancleandRefund(this.status, this.message, this.key);

  factory CancleandRefund.fromJson(dynamic json) {
    return CancleandRefund(json['status'] as String, json['message'] as String, json['key'] as String);
  }

  @override
  String toString() {
    return '{ $status, $message, $key }';
  }

}
class CancleandRefund1 {
  bool status;
  String message;
  String key;

  CancleandRefund1(this.status, this.message, this.key);

  factory CancleandRefund1.fromJson(dynamic json) {
    return CancleandRefund1(json['status'] as bool, json['message'] as String, json['key'] as String);
  }

  @override
  String toString() {
    return '{ $status, $message, $key }';
  }

}