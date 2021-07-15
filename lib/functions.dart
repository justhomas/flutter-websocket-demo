import 'dart:convert';

import 'package:http/http.dart' as http;

Future<http.Response> deleteStudent(int id) async {
  final http.Response response = await http.delete(
    Uri.parse('http://15.206.73.108:8001/api/students/$id/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  return response;
}

Future<http.Response> createStudent(
    String name, String qualification, String percentage) {
  return http.post(
    Uri.parse('http://15.206.73.108:8001/api/students/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'name': name,
      'qualification': qualification,
      'percentage': percentage,
    }),
  );
}

Future<List> fetchStudent() async {
  final response =
      await http.get(Uri.parse('http://15.206.73.108:8001/api/students/'));
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}
