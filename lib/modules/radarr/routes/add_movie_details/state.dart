import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/radarr.dart';

class RadarrAddMovieDetailsState extends ChangeNotifier {
  final bool isDiscovery;
  final RadarrMovie movie;
  bool canExecuteAction = false;

  RadarrAddMovieDetailsState({
    required this.movie,
    required this.isDiscovery,
  });

  bool _monitored = true;
  bool get monitored => _monitored;
  set monitored(bool monitored) {
    _monitored = monitored;
    RadarrDatabaseValue.ADD_MOVIE_DEFAULT_MONITORED_STATE.put(_monitored);
    notifyListeners();
  }

  late RadarrAvailability _availability;
  RadarrAvailability get availability => _availability;
  set availability(RadarrAvailability availability) {
    _availability = availability;
    RadarrDatabaseValue.ADD_MOVIE_DEFAULT_MINIMUM_AVAILABILITY_ID
        .put(_availability.value);
    notifyListeners();
  }

  void initializeAvailability() {
    const _db = RadarrDatabaseValue.ADD_MOVIE_DEFAULT_MINIMUM_AVAILABILITY_ID;
    RadarrAvailability? _ra = RadarrAvailability.TBA.from(_db.data);

    if (_ra == RadarrAvailability.TBA || _ra == RadarrAvailability.PREDB) {
      _availability = RadarrAvailability.ANNOUNCED;
    } else {
      _availability = RadarrAvailability.values.firstWhere(
        (avail) => avail == _ra,
        orElse: () => RadarrAvailability.ANNOUNCED,
      );
    }
  }

  late RadarrRootFolder _rootFolder;
  RadarrRootFolder get rootFolder => _rootFolder;
  set rootFolder(RadarrRootFolder rootFolder) {
    _rootFolder = rootFolder;
    RadarrDatabaseValue.ADD_MOVIE_DEFAULT_ROOT_FOLDER_ID.put(_rootFolder.id);
    notifyListeners();
  }

  void initializeRootFolder(List<RadarrRootFolder>? rootFolders) {
    _rootFolder = (rootFolders ?? []).firstWhere(
      (element) =>
          element.id ==
          RadarrDatabaseValue.ADD_MOVIE_DEFAULT_ROOT_FOLDER_ID.data,
      orElse: () => (rootFolders?.length ?? 0) != 0
          ? rootFolders![0]
          : RadarrRootFolder(id: -1, freeSpace: 0, path: LunaUI.TEXT_EMDASH),
    );
  }

  late RadarrQualityProfile _qualityProfile;
  RadarrQualityProfile get qualityProfile => _qualityProfile;
  set qualityProfile(RadarrQualityProfile qualityProfile) {
    _qualityProfile = qualityProfile;
    RadarrDatabaseValue.ADD_MOVIE_DEFAULT_QUALITY_PROFILE_ID
        .put(_qualityProfile.id);
    notifyListeners();
  }

  void initializeQualityProfile(List<RadarrQualityProfile>? qualityProfiles) {
    _qualityProfile = (qualityProfiles ?? []).firstWhere(
      (element) =>
          element.id ==
          RadarrDatabaseValue.ADD_MOVIE_DEFAULT_QUALITY_PROFILE_ID.data,
      orElse: () => (qualityProfiles?.length ?? 0) != 0
          ? qualityProfiles![0]
          : RadarrQualityProfile(id: -1, name: LunaUI.TEXT_EMDASH),
    );
  }

  List<RadarrTag> _tags = [];
  List<RadarrTag> get tags => _tags;
  set tags(List<RadarrTag> tags) {
    _tags = tags;
    RadarrDatabaseValue.ADD_MOVIE_DEFAULT_TAGS
        .put(tags.map<int?>((tag) => tag.id).toList());
    notifyListeners();
  }

  void initializeTags(List<RadarrTag>? tags) {
    _tags = (tags ?? [])
        .where((tag) =>
            ((RadarrDatabaseValue.ADD_MOVIE_DEFAULT_TAGS.data as List?) ?? [])
                .contains(tag.id))
        .toList();
  }

  LunaLoadingState _state = LunaLoadingState.INACTIVE;
  LunaLoadingState get state => _state;
  set state(LunaLoadingState state) {
    _state = state;
    notifyListeners();
  }
}
