import 'package:flutter/material.dart';
import 'package:shared_core/index.dart' as prefix0;
import 'package:services_package/api_service.dart';

import '../../../../../core/network/injection_container.dart';
import 'field_display_config.dart';

class GenericListEntityState<
  T extends prefix0.BaseResponse<D>,
  D,
  C extends prefix0.BaseRequest
>
    extends ChangeNotifier {
  C _request;
  T? _response;
  List<D> _fetchData;
  int _totalCount;
  bool _loading;
  String? _error;
  DateTime? _lastFetched;
  List<FieldDisplayConfig> _fields;
  Map<String, dynamic> _displayFields;

  GenericListEntityState({
    required C request,
    required T? response,

    required List<FieldDisplayConfig> fields,
    List<D> fetchData = const [],
    int totalCount = 0,
    bool loading = false,
    String? error,
    DateTime? lastFetched,
    Map<String, dynamic> displayFields = const {},
  }) : _request = request,
       _response = response,
       _fields = fields,
       _fetchData = fetchData,
       _totalCount = totalCount,
       _loading = loading,
       _error = error,
       _lastFetched = lastFetched,
       _displayFields = displayFields;

  // Getters
  C get request => _request;
  T? get response => _response;
  List<D> get fetchData => _fetchData;
  int get totalCount => _totalCount;
  bool get loading => _loading;
  String? get error => _error;
  DateTime? get lastFetched => _lastFetched;
  List<FieldDisplayConfig> get fields => _fields;
  Map<String, dynamic> get displayFields => _displayFields;

  // Setters with notifyListeners
  set request(C value) {
    if (_request != value) {
      _request = value;
      notifyListeners();
    }
  }

  set response(T? value) {
    if (_response != value) {
      _response = value;
      notifyListeners();
    }
  }

  set fetchData(List<D> value) {
    if (_fetchData != value) {
      _fetchData = value;
      notifyListeners();
    }
  }

  set totalCount(int value) {
    if (_totalCount != value) {
      _totalCount = value;
      notifyListeners();
    }
  }

  set loading(bool value) {
    if (_loading != value) {
      _loading = value;
      notifyListeners();
    }
  }

  set error(String? value) {
    if (_error != value) {
      _error = value;
      notifyListeners();
    }
  }

  set lastFetched(DateTime? value) {
    if (_lastFetched != value) {
      _lastFetched = value;
      notifyListeners();
    }
  }

  set fields(List<FieldDisplayConfig> value) {
    if (_fields != value) {
      _fields = value;
      notifyListeners();
    }
  }

  set displayFields(Map<String, dynamic> value) {
    if (_displayFields != value) {
      _displayFields = value;
      notifyListeners();
    }
  }

  // Helper method to add a display field
  void addDisplayField(String key, dynamic value) {
    _displayFields = {..._displayFields, key: value};
    notifyListeners();
  }

  // Helper method to remove a display field
  void removeDisplayField(String key) {
    _displayFields = Map.from(_displayFields)..remove(key);
    notifyListeners();
  }

  // Copy with method
  GenericListEntityState<T, D, C> copyWith({
    C? request,
    T? response,
    ApiService<T, D, C>? apiService,
    List<FieldDisplayConfig>? fields,
    List<D>? fetchData,
    int? totalCount,
    bool? loading,
    String? error,
    DateTime? lastFetched,
    Map<String, dynamic>? displayFields,
  }) {
    return GenericListEntityState<T, D, C>(
      request: request ?? _request,
      response: response ?? _response,
      fields: fields ?? _fields,
      fetchData: fetchData ?? _fetchData,
      totalCount: totalCount ?? _totalCount,
      loading: loading ?? _loading,
      error: error ?? _error,
      lastFetched: lastFetched ?? _lastFetched,
      displayFields: displayFields ?? _displayFields,
    );
  }

  // Fetch data method
  Future<void> fetchDataFromApi() async {
    try {
      loading = true;
      error = null;
      final service = await sl<ApiService<T, D, C>>();
      final newResponse = await service.get(_request, null);
      response = newResponse;
      fetchData = newResponse?.data ?? [];
      totalCount = newResponse?.totalCount ?? fetchData.length;
      lastFetched = DateTime.now();
    } catch (e) {
      error = e.toString();
      rethrow;
    } finally {
      loading = false;
    }
  }

  // Clear all data
  void clear() {
    fetchData = [];
    totalCount = 0;
    error = null;
    _displayFields.clear();
    notifyListeners();
  }

  // Update request and fetch
  Future<void> updateRequestAndFetch(C newRequest) async {
    request = newRequest;

    await fetchDataFromApi();
  }
}

class ErpStoreState<T extends prefix0.BaseResponse<D>, D, C extends prefix0.BaseRequest> {
  final Map<String, GenericListEntityState<T, D, C>> _entities;

  ErpStoreState({Map<String, GenericListEntityState<T, D, C>>? entities})
    : _entities = entities ?? {};

  // Get entity by key
  GenericListEntityState<T, D, C>? getEntity(String key) => _entities[key];

  // Add or update entity
  void putEntity(String key, GenericListEntityState<T, D, C> entity) {
    _entities[key] = entity;
  }

  // Remove entity
  void removeEntity(String key) {
    _entities.remove(key);
  }

  // Check if entity exists
  bool hasEntity(String key) => _entities.containsKey(key);

  // Get all entities
  Map<String, GenericListEntityState<T, D, C>> get entities =>
      Map.from(_entities);

  // Copy with method
  ErpStoreState<T, D, C> copyWith({
    Map<String, GenericListEntityState<T, D, C>>? entities,
  }) {
    return ErpStoreState<T, D, C>(entities: entities ?? _entities);
  }

  // Clear all entities
  void clear() {
    _entities.clear();
  }

  // Get request from first entity (if exists)
  C? getFirstRequest() {
    if (_entities.isEmpty) return null;
    return _entities.values.first.request;
  }
}
