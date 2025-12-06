class ApiUrl {
  static const String baseUrl = 'http://localhost:8080';
  static const String registrasi = baseUrl + '/registrasi';
  static const String login = baseUrl + '/login';
  static const String listInventaris = baseUrl + '/inventaris';
  static const String createInventaris = baseUrl + '/inventaris';
  static String updateInventaris(int id) {
    return baseUrl + '/inventaris/' + id.toString();
  }

  static String showinventaris(int id) {
    return baseUrl + '/inventaris/' + id.toString();
  }

  static String deleteinventaris(int id) {
    return baseUrl + '/inventaris/' + id.toString();
  }
}