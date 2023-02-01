import 'dart:io';

import 'package:fimber/fimber.dart';

enum Configs {
  local,
  dev,
  prod,
  staging,
}

abstract class AppConfig {
  AppConfig._(
      {required this.apiHostName,
      required this.isProductionEnvironment,
      required this.googleServerClientId,
      required this.googleIosClientId,
      required this.chargebeeSite,
      required this.publishableApiKey,
      required this.iosSdkKey,
      required this.androidSdkKey,
      required this.beaconId});

  final appVersion = "1.1.3";
  final appStoreLink = "https://apps.apple.com/app/id1664770729";
  final googlePlayLink =
      "https://play.google.com/store/apps/details?id=com.writesonic.chatsonic";

  final String apiHostName;
  final bool isProductionEnvironment;
  final String googleServerClientId;
  final String googleIosClientId;
  final String beaconId;

  // Chargebee settings
  final String chargebeeSite;
  final String publishableApiKey;
  final String iosSdkKey;
  final String androidSdkKey;

  String get api => 'https://$apiHostName';

  String get storeLink {
    if (Platform.isIOS) {
      return appStoreLink;
    } else {
      return googlePlayLink;
    }
  }

  static AppConfig get init => _getForFlavor;

  static AppConfig get _getForFlavor {
    Configs flavor = Configs.values.firstWhere(
      (e) =>
          e.toString() ==
          "Configs.${const String.fromEnvironment('envFlavour', defaultValue: 'prod')}",
    );

    switch (flavor) {
      case Configs.dev:
        Fimber.plantTree(DebugTree());
        Fimber.e('debug mode');
        return DevConfig();
      case Configs.prod:
        Fimber.e('release mode');
        return ProdConfig();
      default:
        throw UnimplementedError();
    }
  }
}

class DevConfig extends AppConfig {
  DevConfig()
      : super._(
            apiHostName: 'dev-backend.writesonic.com/v1',
            googleServerClientId:
                '607060294923-e1jemntogfohofi6arr64renu2tr6vlt.apps.googleusercontent.com',
            googleIosClientId:
                '607060294923-mpkt1a91afr61npl6l257pki0tl2ogqq.apps.googleusercontent.com',
            isProductionEnvironment: false,
            chargebeeSite: 'writesonic-test',
            publishableApiKey: 'test_LBKcuDSHSEY6s71suHD68H173cudPKp04f',
            iosSdkKey: 'cb-mlfxtjhmszdyfcu4in6by53zre',
            androidSdkKey: 'cb-efyws2nur5g25esokmdcworo3m',
            beaconId: "b1f88f16-86a2-497e-9ab6-c220ad1b8e07");
}

class ProdConfig extends AppConfig {
  ProdConfig()
      : super._(
            apiHostName: 'api.writesonic.com/v1',
            googleServerClientId:
                '573920139328-97cbi78hn2fao489inc9tjhi503mb48m.apps.googleusercontent.com',
            googleIosClientId:
                '573920139328-hl943env3s8hsoickvkhk7ba7n9l06nn.apps.googleusercontent.com',
            isProductionEnvironment: true,
            chargebeeSite: 'writesonic',
            publishableApiKey: 'live_urWCXcd7cuVZe3nDQF8XWFmK6Grf6qZx7R',
            iosSdkKey: 'cb-iiixzuponjhk7hhps42zbfsire',
            androidSdkKey: 'cb-6nam2yc2lze3rjprenqvxxxawi',
            beaconId: "b1f88f16-86a2-497e-9ab6-c220ad1b8e07");
}
