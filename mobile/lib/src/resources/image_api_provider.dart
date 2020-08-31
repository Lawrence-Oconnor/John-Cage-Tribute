import 'dart:convert';

import 'package:http/http.dart';

import 'package:jct/src/models/unsplash/unsplash_image_model.dart';

final String _randomPhoto = 'https://api.unsplash.com/photos/random';
final String accessKey = 'oyzT4DM1G2fLXm8_dBo6HLPKOE0Bob0SobRskz8-q94';

class ImageApiProvider {
  Client client = Client();

  Future<UnsplashImageModel> getPhoto() async {
    final response = await client.get(
        '$_randomPhoto?query=abstract&client_id=$accessKey&orientation=portrait');

    final parsedJson = jsonDecode(response.body);
    return UnsplashImageModel.fromJson(parsedJson);
  }
}
