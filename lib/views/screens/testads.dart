import 'package:easy_audience_network/constants.dart';
import 'package:easy_audience_network/easy_audience_network.dart' as easy_audience_network;
import 'package:facebook_audience_network/facebook_audience_network.dart' as facebook_audience_network;
import 'package:flutter/material.dart';

class TestAds extends StatefulWidget {
  const TestAds({Key? key}) : super(key: key);

  @override
  State<TestAds> createState() => _TestAdsState();
}

class _TestAdsState extends State<TestAds> {
  bool isInterstitialLoaded = false;
  late easy_audience_network.BannerAd bannerAd;

  @override
  void initState() {
    super.initState();
    facebook_audience_network.FacebookAudienceNetwork.init(
      testingId: "405bad44-286e-4f4d-a080-3b6217df7ff6", // optional
      // iOSAdvertiserTrackingEnabled: true // default false
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Ads'),
      ),
      body: Center(
        child: Container(
          child: ElevatedButton(
            onPressed: () {
              facebook_audience_network.FacebookInterstitialAd.showInterstitialAd();
            },
            child: Text("Test My Ads"),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: facebook_audience_network.FacebookBannerAd(
            placementId:
            "IMG_16_9_APP_LINK#1367132177416596_1367144794082001",
            bannerSize: facebook_audience_network.BannerSize.STANDARD,
            listener: (result, value) {
              switch (result) {
                case facebook_audience_network.BannerAdResult.ERROR:
                  print("Error: $value");
                  break;
                case facebook_audience_network.BannerAdResult.LOADED:
                  print("Loaded: $value");
                  break;
                case facebook_audience_network.BannerAdResult.CLICKED:
                  print("Clicked: $value");
                  break;
                case facebook_audience_network.BannerAdResult.LOGGING_IMPRESSION:
                  print("Logging Impression: $value");
                  break;
              }
            },
          ),
        ),
      ),
    );
  }
}
