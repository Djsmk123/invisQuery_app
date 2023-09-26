class APIInfo {
  String getBaseUrl() =>
      "https://askme-backend-ei6l.onrender.com"; //"http://192.168.0.110";

  String subBaseUrl() => "/api";

  String apiVersion() => "/v1";

  Map<String, String> defaultHeader = {'content-type': 'application/json'};
}
