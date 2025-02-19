import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_explorer_app/classes/pokemon.dart'; 

class ApiService {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://pokeapi.co/api/v2/',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );

  /// Fetch a random Pokémon
  static Future<String?> fetchRandomPokemon(BuildContext context, int maxPokemon) async {
    final randomId = (DateTime.now().millisecondsSinceEpoch % maxPokemon) + 1;
    final response = await _safeRequest(context, 'pokemon/$randomId');

    if (response != null) {
      return response.data['sprites']['front_default'];
    }
    return null;
  }

    /// Fetch Pokémon list by type with description
  static Future<List<Pokemon>> fetchPokemonByType(
    BuildContext context,
    String type,
    int offset,
    int limit,
  ) async {
    final response = await _safeRequest(context, 'type/${type.toLowerCase()}');

    if (response != null) {
      List<dynamic> pokemonEntries = response.data['pokemon'];
      List<Pokemon> newPokemon = [];

      for (var entry in pokemonEntries.skip(offset).take(limit)) {
        int id = int.parse(entry['pokemon']['url'].split('/').reversed.elementAt(1));
        String description = await fetchPokemonDescription(context, id);

        newPokemon.add(Pokemon(
          id: id,
          name: entry['pokemon']['name'],
          spriteUrl: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png",
          types: [type],
          description: description,
          hp: (50 + id % 50).toInt(),
          attack: (50 + id % 50).toInt(),
          defense: (50 + id % 50).toInt(),
        ));
      }
      return newPokemon;
    }
    return [];
  }

  /// Fetch Pokémon description
  static Future<String> fetchPokemonDescription(BuildContext context, int pokemonId) async {
    final response = await _safeRequest(context, 'pokemon-species/$pokemonId');

    if (response != null) {
      for (var entry in response.data['flavor_text_entries']) {
        if (entry['language']['name'] == 'en') {
          return entry['flavor_text']
              .replaceAll("\n", " ")
              .replaceAll("\f", " ");
        }
      }
    }
    return "Team Rocket Stole this Pokémon's Data. Our Ranger Team is working on it.";
  }

  /// Fetch full Pokémon details (stats, sprite, description)
  static Future<Pokemon?> fetchPokemonData(BuildContext context, String name) async {
    final response = await _safeRequest(context, 'pokemon/$name');

    if (response != null) {
      final speciesResponse = await _safeRequest(context, response.data['species']['url']);

      String description = "No description available.";
      if (speciesResponse != null) {
        for (var entry in speciesResponse.data['flavor_text_entries']) {
          if (entry['language']['name'] == 'en') {
            description = entry['flavor_text']
                .replaceAll('\n', ' ')
                .replaceAll('\f', ' ');
            break;
          }
        }
      }

      return Pokemon(
        id: response.data['id'],
        name: response.data['name'],
        spriteUrl: response.data['sprites']['front_default'],
        types: List<String>.from(response.data['types'].map((t) => t['type']['name'])),
        description: description,
        hp: response.data['stats'][0]['base_stat'],
        attack: response.data['stats'][1]['base_stat'],
        defense: response.data['stats'][2]['base_stat'],
      );
    }
    return null;
  }

  /// Fetch all Pokémon names & IDs belonging to a selected type
  static Future<List<Map<String, dynamic>>> fetchAllPokemonNamesOfType(BuildContext context, String type) async {
    final response = await _safeRequest(context, 'type/${type.toLowerCase()}');

    if (response != null) {
      final pokemonList = response.data['pokemon'] as List<dynamic>;

      return pokemonList.map((entry) {
        final pokemonData = entry['pokemon'];
        final urlParts = pokemonData['url'].split('/');
        final id = int.tryParse(urlParts[urlParts.length - 2]) ?? 0;

        return {
          'name': pokemonData['name'],
          'id': id,
        };
      }).toList();
    }
    return [];
  }


  /// Unified function to handle all requests safely
  static Future<Response?> _safeRequest(BuildContext context, String endpoint) async {
    try {
      final response = await _dio.get(endpoint);
      return response;
    } on DioException catch (e) {
      _handleDioError(context, e);
      return null; // Return null so the caller knows the request failed
    }
  }

  /// Centralized error handling
  static void _handleDioError(BuildContext context, DioException e) {
    if (!context.mounted) return;

    String message;
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = "Request timed out. Please check your connection.";
        break;
      case DioExceptionType.badResponse:
        message = "Server error: ${e.response?.statusCode}";
        break;
      case DioExceptionType.connectionError:
        message = "No internet connection.";
        break;
      case DioExceptionType.cancel:
        message = "Request was canceled.";
        break;
      default:
        message = "An unknown error occurred.";
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
