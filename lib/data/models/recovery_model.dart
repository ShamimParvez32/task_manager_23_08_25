class RecoveryModel {
  String? email;
  String? otp;
  String? password;


  RecoveryModel({this.email, this.otp, this.password,});

  RecoveryModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    otp = json['OTP'];
    password = json['password'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map <String,dynamic> ();
    data['email'] = this.email;
    data['OTP'] = this.otp;
    data['password'] = this.password;
    return data;
  }
}