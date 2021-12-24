import 'package:flutter/material.dart';
import 'package:walk_with_dog/models/place_search.dart';
import 'package:walk_with_dog/services/places_service.dart';

class ApplicationBloc with ChangeNotifier {
  final placesService = PlacesService();

  List<PlaceSearch>? searchResults;

  searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners(); 
  }
}