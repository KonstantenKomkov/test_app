import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_app/classes.dart';

Future<List<User>> loadUsers() async {
  var uri = Uri.http('jsonplaceholder.typicode.com', '/users');
  http.Response response = await http.get(uri);

  if (response.statusCode == 200) {
    List<dynamic> listOfUsers = jsonDecode(response.body);
    return listOfUsers.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Error ${response.reasonPhrase}');
  }
}
