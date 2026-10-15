import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

class ApiService{
  final http.Client client;

  ApiService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Post>> fetchPosts() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    final response = await client.get(url);

    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body);
      return data.map((item)=>Post.fromJson(item)).toList();
    }else{
      throw Exception('Failed to load posts');
    }
  }

  Future<Post> createPost(String title, String body) async{
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');

    final response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'body': body}),
    );

    if(response.statusCode == 201){
      final data = json.decode(response.body);
      return Post.fromJson(data);
    }else{
      throw Exception('Failed to create post');
    }
  }

  void dispose() {
    client.close();
  }
}
