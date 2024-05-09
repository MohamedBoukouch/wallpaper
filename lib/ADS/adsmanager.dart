import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class AdsManger{
  static bool _testmode=false;

  static final BannerAdListener bannerAdListener=BannerAdListener(
    onAdLoaded: (ad)=>debugPrint('Ad loaded...'),
    onAdFailedToLoad: (ad,error){
      ad.dispose();
      debugPrint('Ad failed to load: $error');
    },
    onAdOpened: (ad)=>debugPrint('Ad Opened'),
    onAdClosed: (ad)=>debugPrint('Ad Closed'),
  );

  static String get appIde{
    if(Platform.isAndroid){
      return "ca-app-pub-7473108175433680~8107767641";
    }else if(Platform.isIOS){
      return "----";
    }else{
      throw new UnsupportedError("Unsuportted platforme");
    }
  }

  //Banner
    static String? get bannerAdUnit{

      
      if(Platform.isAndroid){
        return "ca-app-pub-3940256099942544/9214589741";
      }else if(Platform.isIOS){
        return "----";
      }else{
        return null;
      }
  }

    //interstitial
    static String? get interstitialAdUnit{
      
      if(Platform.isAndroid){
        return "ca-app-pub-3940256099942544/1033173712";
      }else if(Platform.isIOS){
        return "----";
      }else{
        return null;
      }
  }
}