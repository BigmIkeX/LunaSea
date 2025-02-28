import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class LunaProfile {
  /// Returns a list of the profiles, sorted by their lowercase key/display name.
  List<String> profilesList() => Database.profiles.box.keys
      .map<String>((profile) => profile as String)
      .toList()
    ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

  /// Safely change profiles.
  ///
  /// Does this safely by:
  /// - Ensures that the passed in profile isn't already enabled
  /// - Ensures that the profile exists
  Future<bool> safelyChangeProfiles(
    String profile, {
    bool showSnackbar = true,
    bool popToFirst = false,
  }) async {
    if (LunaDatabaseValue.ENABLED_PROFILE.data == profile) return true;
    if (Database.profiles.box.containsKey(profile)) {
      LunaDatabaseValue.ENABLED_PROFILE.put(profile);
      LunaState.reset(LunaState.navigatorKey.currentContext!);
      if (showSnackbar)
        showLunaSuccessSnackBar(
          title: 'Changed Profile',
          message: profile,
        );
      if (popToFirst) LunaState.navigatorKey.currentState!.lunaPopToFirst();
      return true;
    } else {
      LunaLogger().warning('LunaProfile', 'changeProfile',
          'Attempted to change profile to unknown profile: $profile');
      return false;
    }
  }

  /// Rename a profile.
  ///
  /// Shows a dialog with a list of profiles, on selection:
  /// - Shows a input bar for a new name
  /// - Updates the profile's key (which is also the display name)
  Future<bool> renameProfile({bool showSnackbar = true}) async {
    List<String?> profiles = profilesList();
    Tuple2<bool, String?> selectedProfile = await SettingsDialogs()
        .renameProfile(LunaState.navigatorKey.currentContext!, profiles);
    if (selectedProfile.item1) {
      Tuple2<bool, String> newProfile = await SettingsDialogs()
          .renameProfileSelected(
              LunaState.navigatorKey.currentContext!, profiles);
      if (newProfile.item1) {
        ProfileHiveObject oldProfileObject =
            Database.profiles.box.get(selectedProfile.item2)!;
        Database.profiles.box.put(newProfile.item2,
            ProfileHiveObject.fromProfileHiveObject(oldProfileObject));
        if (LunaDatabaseValue.ENABLED_PROFILE.data == selectedProfile.item2)
          LunaProfile()
              .safelyChangeProfiles(newProfile.item2, showSnackbar: false);
        oldProfileObject.delete();
        if (showSnackbar)
          showLunaSuccessSnackBar(
              title: 'Renamed Profile',
              message:
                  '"${selectedProfile.item2}" has been renamed to "${newProfile.item2}"');
      }
      return true;
    }
    return false;
  }

  /// Delete a profile.
  ///
  /// Show a dialog with a list of profiles, on selection:
  /// - Validate that the profile is not currently enabled
  Future<bool> deleteProfile({bool showSnackbar = true}) async {
    List<String?> profiles = profilesList();
    profiles.remove(LunaDatabaseValue.ENABLED_PROFILE.data);
    if (profiles.isNotEmpty) {
      Tuple2<bool, String?> selectedProfile = await SettingsDialogs()
          .deleteProfile(LunaState.navigatorKey.currentContext!, profiles);
      if (selectedProfile.item1) {
        if (selectedProfile.item2 != LunaDatabaseValue.ENABLED_PROFILE.data) {
          Database.profiles.box.delete(selectedProfile.item2);
          if (showSnackbar)
            showLunaSuccessSnackBar(
                title: 'Deleted Profile',
                message: '"${selectedProfile.item2}" has been deleted');
          return true;
        }
        if (showSnackbar)
          showLunaErrorSnackBar(
              title: 'Unable to Delete Profile',
              message: 'Cannot delete the enabled profile');
      }
    } else {
      showLunaInfoSnackBar(
          title: 'No Profiles to Delete',
          message: 'No additional profiles have been added');
    }
    return false;
  }

  Future<bool> addProfile({bool showSnackbar = true}) async {
    List<String?> profiles = profilesList();
    Tuple2<bool, String> result = await SettingsDialogs()
        .addProfile(LunaState.navigatorKey.currentContext!, profiles);
    if (result.item1) {
      Database.profiles.box.put(result.item2, ProfileHiveObject.empty());
      safelyChangeProfiles(result.item2);
      if (showSnackbar)
        showLunaSuccessSnackBar(
          title: 'Profile Added',
          message: result.item2,
        );
    }
    return false;
  }

  static ProfileHiveObject get current {
    LunaDatabaseValue _db = LunaDatabaseValue.ENABLED_PROFILE;
    String _name = Database.lunasea.box.get(_db.key) ?? 'default';
    return Database.profiles.box.get(_name) ?? ProfileHiveObject.empty();
  }
}
