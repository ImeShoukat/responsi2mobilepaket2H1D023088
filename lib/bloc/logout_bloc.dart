import 'package:responsi2mobilepaket2_h1d023088/helpers/user_info.dart';

class LogoutBloc {
  static Future logout() async {
    await UserInfo().logout();
  }
}