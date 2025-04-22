import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_ar/isolate/photo_model.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({super.key});

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  late Future<List<Photo>> photos;

  @override
  void initState() {
    super.initState();
    photos = fetchPhotos(http.Client());
  }

  Future<List<Photo>> fetchPhotos(http.Client client) async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/photos'),
    );

    return parsePhotos(response.body);
  }

  // A function that converts a response body into a List<Photo>.
  List<Photo> parsePhotos(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isolate')),
      body: FutureBuilder<List<Photo>>(
        future: photos,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error:'));
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder:
                  (context, index) =>
                      ListTile(title: Text(snapshot.data![index].title)),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
