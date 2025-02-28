import 'package:lunasea/core.dart';
import 'package:lunasea/modules/overseerr.dart';

class OverseerrState extends LunaModuleState {
  OverseerrState() {
    reset();
  }

  @override
  void reset() {
    _movieCache.clear();
    _seriesCache.clear();
    resetProfile();
    notifyListeners();
  }

  ///////////////
  /// PROFILE ///
  ///////////////

  /// API handler instance
  Overseerr? _api;
  Overseerr? get api => _api;

  /// Is the API enabled?
  bool _enabled = false;
  bool get enabled => _enabled;

  /// Overseerr host
  String _host = '';
  String get host => _host;

  /// Overseerr API key
  String _apiKey = '';
  String get apiKey => _apiKey;

  /// Headers to attach to all requests
  Map<dynamic, dynamic> _headers = {};
  Map<dynamic, dynamic> get headers => _headers;

  /// Reset the profile data, reinitializes API instance
  void resetProfile() {
    ProfileHiveObject _profile = LunaProfile.current;
    // Copy profile into state
    _api = null;
    _enabled = _profile.overseerrEnabled ?? false;
    _host = _profile.overseerrHost ?? '';
    _apiKey = _profile.overseerrKey ?? '';
    _headers = _profile.overseerrHeaders ?? {};
    // Create the API instance if Overseerr is enabled
    if (_enabled) {
      _api = Overseerr(
        host: _host,
        apiKey: _apiKey,
        headers: Map<String, dynamic>.from(_headers),
      );
    }
  }

  ////////////////
  /// REQUESTS ///
  ////////////////

  final LunaLRUCache _movieCache = LunaLRUCache(
    maxEntries: 50,
    module: LunaModule.OVERSEERR,
    id: 'requests_movie_cache',
  );

  final LunaLRUCache _seriesCache = LunaLRUCache(
    maxEntries: 50,
    module: LunaModule.OVERSEERR,
    id: 'requests_series_cache',
  );

  Future<void> fetchMovie(int movieId, {bool force = false}) async {
    if (_enabled) {
      String id = movieId.toString();
      bool exists = await _movieCache.contains(id);

      if (force || !exists) {
        await _movieCache.put(id, api!.getMovie(id: movieId));
      }
    }
    notifyListeners();
  }

  Future<void> fetchSeries(int seriesId, {bool force = false}) async {
    if (_enabled) {
      String id = seriesId.toString();
      bool exists = await _seriesCache.contains(id);

      if (force || !exists) {
        await _seriesCache.put(id, api!.getSeries(id: seriesId));
      }
    }
    notifyListeners();
  }

  Future<OverseerrMovie?> getMovie(int movieId) async {
    String id = movieId.toString();
    return _movieCache.get(id).then((movie) {
      return movie as OverseerrMovie?;
    });
  }

  Future<OverseerrSeries?> getSeries(int seriesId) {
    String id = seriesId.toString();
    return _seriesCache.get(id).then((series) {
      return series as OverseerrSeries?;
    });
  }
}
