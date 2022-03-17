import 'package:flutter/material.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/modules/settings.dart';

class SettingsAccountRestoreConfigurationTile extends StatefulWidget {
  const SettingsAccountRestoreConfigurationTile({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SettingsAccountRestoreConfigurationTile> {
  LunaLoadingState _loadingState = LunaLoadingState.INACTIVE;

  void updateState(LunaLoadingState state) {
    if (mounted) setState(() => _loadingState = state);
  }

  @override
  Widget build(BuildContext context) {
    return LunaBlock(
      title: 'settings.RestoreFromCloud'.tr(),
      body: [TextSpan(text: 'settings.RestoreFromCloudDescription'.tr())],
      trailing: LunaIconButton(
        icon: LunaIcons.CLOUD_DOWNLOAD,
        loadingState: _loadingState,
      ),
      onTap: () async => _restore(context),
    );
  }

  Future<void> _restore(BuildContext context) async {
    if (_loadingState == LunaLoadingState.ACTIVE) return;
    updateState(LunaLoadingState.ACTIVE);
    try {
      final docs = await LunaFirebaseFirestore().getBackupEntries();
      final result = await SettingsDialogs().getBackupFromCloud(context, docs);

      if (result.item1) {
        String? id = result.item2!.id;
        String? encrypted = await LunaFirebaseStorage().downloadBackup(id);
        if (encrypted != null) _decryptBackup(context, encrypted);
      }
    } catch (error, stack) {
      LunaLogger().error('Failed to restore cloud backup', error, stack);
      showLunaErrorSnackBar(
        title: 'settings.RestoreFromCloudFailure'.tr(),
        error: error,
      );
    }
    updateState(LunaLoadingState.INACTIVE);
  }

  Future<void> _decryptBackup(BuildContext context, String encrypted) async {
    Tuple2<bool, String> _key = await SettingsDialogs().decryptBackup(context);
    if (_key.item1) {
      String decrypted = LunaEncryption().decrypt(_key.item2, encrypted);
      if (decrypted != LunaEncryption.ENCRYPTION_FAILURE) {
        await LunaConfiguration().import(context, decrypted);
        showLunaSuccessSnackBar(
          title: 'settings.RestoreFromCloudSuccess'.tr(),
          message: 'settings.RestoreFromCloudSuccessMessage'.tr(),
        );
      } else {
        showLunaErrorSnackBar(
          title: 'settings.RestoreFromCloudFailure'.tr(),
          message: 'settings.IncorrectEncryptionKey'.tr(),
          showButton: true,
          buttonText: 'lunasea.Retry'.tr(),
          buttonOnPressed: () async => _decryptBackup(context, encrypted),
        );
      }
    }
  }
}
