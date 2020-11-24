import 'dart:io';

class AdMobService {

  String getAdModAppID() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3484633495754874~1007479313';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3484633495754874~4267426848';
    }
    return null;
  }

  String getBannerAdId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-3484633495754874/1393851496';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3484633495754874/9264602654';
    }
    return null;
  }

}