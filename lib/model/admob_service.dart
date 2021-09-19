
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';



class AdmobService{
  AdmobBanner banner;
  AdmobBanner rectangle;
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;
 // StreamController _streamController = StreamController();
 // Sink get _input => _streamController.sink;
 // Stream get output =>_streamController.stream;

  admob() {
    bannerSize = AdmobBannerSize.BANNER;

    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );

    rewardAd = AdmobReward(
        adUnitId: getRewardBasedVideoAdUnitId(),
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          if (event == AdmobAdEvent.closed) rewardAd.load();
        });

    interstitialAd.load();
    rewardAd.load();





    banner= AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: AdmobBannerSize.BANNER,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
    );
    rectangle= AdmobBanner(
      adUnitId: getBannerAdUnitId(),
      adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {},
    );
   // input.add( rewardAd.isLoaded != null?
  //  rewardAd:interstitialAd);
    //input.add(rectangle);
   // input.add(banner);

  }







  void dispose() {
    interstitialAd.dispose();
    rewardAd.dispose();
  }
}

String getAppId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-1005929281486446~7980929547';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544~3347511713'; // teste
    // 'ca-app-pub-1005929281486446~7980929547';
  }
  return null;
}

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/6300978111';
    //'ca-app-pub-1005929281486446/9090012999';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/6300978111'; //teste
    //'ca-app-pub-1005929281486446/9090012999';
  }
  return null;
}

String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-1005929281486446/5150767980';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/1033173712'; //teste
    // 'ca-app-pub-1005929281486446/5150767980';
  }
  return null;
}

String getRewardBasedVideoAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-1005929281486446/8515297929';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/5224354917'; //teste
    // 'ca-app-pub-1005929281486446/8515297929';
  }
  return null;
}
