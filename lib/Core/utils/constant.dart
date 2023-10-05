class APIInfo {
  String getBaseUrl() => "https://askme-backend-ei6l.onrender.com";

  String subBaseUrl() => "/api";

  String apiVersion() => "/v1";

  Map<String, String> defaultHeader = {'content-type': 'application/json'};
}
