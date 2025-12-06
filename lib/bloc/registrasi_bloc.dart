import 'dart:convert';
import 'package:responsi2mobilepaket2_h1d023088/helpers/api.dart';
import 'package:responsi2mobilepaket2_h1d023088/helpers/api_url.dart';
import 'package:responsi2mobilepaket2_h1d023088/model/registrasi.dart';

class RegistrasiBloc {
  static Future<Registrasi> registrasi({
    String? nama,
    String? email,
    String? password,
  }) async {
    String apiUrl = ApiUrl.registrasi;
    var body = {"nama": nama, "email": email, "password": password};
    print(body);
    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    print(jsonObj);
    return Registrasi.fromJson(jsonObj);
  }
}