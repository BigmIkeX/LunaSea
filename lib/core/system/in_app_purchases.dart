import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:lunasea/core.dart';
import 'package:lunasea/system/platform.dart';

extension ProductDetailsExtension on ProductDetails {
  IconData get icon {
    switch (this.id) {
      case LunaInAppPurchases.DONATION_01:
        return Icons.local_drink_rounded;
      case LunaInAppPurchases.DONATION_03:
        return Icons.local_cafe_rounded;
      case LunaInAppPurchases.DONATION_05:
        return Icons.local_bar_rounded;
      case LunaInAppPurchases.DONATION_10:
        return Icons.fastfood_rounded;
      default:
        return Icons.attach_money_rounded;
    }
  }

  String get name {
    switch (this.id) {
      case LunaInAppPurchases.DONATION_01:
        return 'lunasea.BuyMeASoda'.tr();
      case LunaInAppPurchases.DONATION_03:
        return 'lunasea.BuyMeACoffee'.tr();
      case LunaInAppPurchases.DONATION_05:
        return 'lunasea.BuyMeABeer'.tr();
      case LunaInAppPurchases.DONATION_10:
        return 'lunasea.BuyMeABurger'.tr();
      default:
        return 'lunasea.Unknown'.tr();
    }
  }
}

class LunaInAppPurchases {
  // Donation IAP IDs
  static const DONATION_01 = 'donation_01';
  static const DONATION_03 = 'donation_03';
  static const DONATION_05 = 'donation_05';
  static const DONATION_10 = 'donation_10';
  static const DONATION_IDS = [
    DONATION_01,
    DONATION_03,
    DONATION_05,
    DONATION_10
  ];

  static InAppPurchase get connection => InAppPurchase.instance;
  static StreamSubscription<List<PurchaseDetails>>? _purchaseStream;
  static List<ProductDetails> donationIAPs = [];
  static bool isAvailable = false;

  static bool get isSupported => LunaPlatform().isMobile;

  /// Callback function for [purchaseStream].
  static Future<void> _purchasedCallback(
      List<PurchaseDetails> purchases) async {
    for (var purchase in purchases) {
      /// Handle donations by always completing the purchase
      if (DONATION_IDS.contains(purchase.productID)) {
        if (purchase.pendingCompletePurchase)
          await connection.completePurchase(purchase);
      }
    }
  }

  /// Initialize the in-app purchases connection.
  ///
  /// - Enables pending purchase
  /// - Attach [InAppPurchaseConnection.instance.purchaseUpdateStream] listener for automatically completing IAP purchases
  /// - Fetch and store donation IAPs
  Future<void> initialize() async {
    if (isSupported) {
      isAvailable = await connection.isAvailable();
      if (isAvailable) {
        // Open listener
        _purchaseStream = connection.purchaseStream.listen(
          LunaInAppPurchases._purchasedCallback,
        );
        // Load donation IAPs
        ProductDetailsResponse donation =
            await connection.queryProductDetails(Set.from(DONATION_IDS));
        donationIAPs = donation.productDetails;
        donationIAPs.sort((a, b) => a.id.compareTo(b.id));
      }
    }
  }

  /// Deinitialize the in-app purchases connection.
  ///
  /// - Cleanly cancel/close the [InAppPurchaseConnection.instance.purchaseUpdateStream] listener.
  Future<void>? deinitialize() async => _purchaseStream?.cancel();
}
