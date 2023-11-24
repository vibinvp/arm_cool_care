
class loginModal{

  String success;
  String message;
  String key;
  String user_id;
  String name;
  String email;
  String username;
  String address;
  String city;
  String pp;
  String wallet;
  String gst;
  String prime;
  String sex;
  String dlocationName;
  String dlocation;
  String pincode;

  @override
  String toString() {
    return 'loginModal{success: $success, message: $message, key: $key, user_id: $user_id, name: $name, email: $email, username: $username, address: $address, city: $city, pp: $pp, wallet: $wallet, gst: $gst, prime: $prime, pincode: $pincode, sex: $sex, dlocationName: $dlocationName, dlocation: $dlocation}';
  }




  loginModal(
      this.success,
      this.message,
      this.key,
      this.user_id,
      this.name,
      this.email,
      this.username,
      this.address,
      this.city,
      this.pp,
      this.wallet,
      this.gst,
      this.prime,
      this.pincode,
      this.sex,
      this.dlocationName,
      this.dlocation);



  factory loginModal.fromJson(dynamic json) {
    return loginModal(json['success'] as String, json['message'] as String, json['key'] as String, json['user_id'] as String, json['name'] as String,
        json['email'] as String, json['username'] as String, json['address'] as String, json['city'] as String, json['pp'] as String,
        json['wallet'] as String, json['gst'] as String,json['prime'] as String,json['pincode'] as String,
        json['sex'] as String,json['dlocation'] as String, json['dlocation'] as String);
  }


}