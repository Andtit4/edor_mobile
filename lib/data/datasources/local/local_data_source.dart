import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/errors/exceptions.dart';

abstract class LocalDataSource {
  Future<Map<String, dynamic>> loadAssetJson(String assetPath);
  Future<void> saveToCache(String key, Map<String, dynamic> data);
  Future<Map<String, dynamic>?> getFromCache(String key);
  Future<void> clearCache();
}

class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<Map<String, dynamic>> loadAssetJson(String assetPath) async {
    try {
      final String jsonString = await rootBundle.loadString(assetPath);
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw CacheException(message: 'Erreur lors du chargement de $assetPath: $e');
    }
  }

  @override
  Future<void> saveToCache(String key, Map<String, dynamic> data) async {
    try {
      final String jsonString = json.encode(data);
      await sharedPreferences.setString(key, jsonString);
    } catch (e) {
      throw CacheException(message: 'Erreur lors de la sauvegarde en cache: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getFromCache(String key) async {
    try {
      final String? jsonString = sharedPreferences.getString(key);
      if (jsonString == null) return null;
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw CacheException(message: 'Erreur lors de la lecture du cache: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.clear();
    } catch (e) {
      throw CacheException(message: 'Erreur lors de la suppression du cache: $e');
    }
  }
}
