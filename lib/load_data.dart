// Package imports:
import 'package:http/http.dart' as http;

Future<String> loadData(String path) async {
  final uri = Uri.http('jsonplaceholder.typicode.com', path);
  final http.Response response = await http.get(uri);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Error ${response.reasonPhrase}');
  }
}

Future<String> sendPost(String path, String json) async {
  final uri = Uri.http('jsonplaceholder.typicode.com', path);
  final http.Response response =
      await http.post(uri, headers: {'Accept': 'application/json'}, body: json);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Error ${response.reasonPhrase}');
  }
}
