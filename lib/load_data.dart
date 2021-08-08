// Package imports:
import 'package:http/http.dart' as http;

Future<String> loadData(String path) async {
  var uri = Uri.http('jsonplaceholder.typicode.com', path);
  http.Response response = await http.get(uri);

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Error ${response.reasonPhrase}');
  }
}
