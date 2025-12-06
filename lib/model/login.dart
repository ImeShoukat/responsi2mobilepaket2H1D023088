class Login {
  int? code;
  bool? status;
  String? token;
  int? userId;
  String? userEmail;
  String? nama;

  Login({this.code, this.status, this.token, this.userId, this.userEmail, this.nama});
  factory Login.fromJson(Map<String, dynamic> json) {
    if (json['code'] == 200) {
      return Login(
        code: json['code'],
        status: json['status'],
        token: json['token'],
        userId: int.tryParse(json['data']['user']['id'].toString()),
        userEmail: json['data']['user']['email'],
        nama: json['data']['user']['nama'],
      );
    } else {
      return Login(code: json['code'], status: json['status']);
    }
  }
}