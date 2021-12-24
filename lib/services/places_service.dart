import 'package:http/http.dart' as http;
import 'package:walk_with_dog/constants/constants.dart';
import 'dart:convert' as convert;

import 'package:walk_with_dog/models/place_search.dart';

class PlacesService {


  Future<List<PlaceSearch>> getAutocomplete(String search) async {
    var url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=(cities)&key=$myGoogleApiKey';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;

    return jsonResults.map((place) => PlaceSearch.fromJson(place)).toList();
  }
}