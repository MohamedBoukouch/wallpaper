import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaperworld/ADS/adsmanager.dart';

class FullScreen extends StatefulWidget {
  String imageurl;
  FullScreen({Key? key,required this.imageurl}) : super(key: key);

  @override
  State<FullScreen> createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {

  bool _isLoadingInterstitial = false;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;






  void _createInterstitialAd() {
    _isLoadingInterstitial = true;
    InterstitialAd.load(
      adUnitId: AdsManger.interstitialAdUnit!,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _interstitialAd = ad;
            _isLoadingInterstitial = false;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          setState(() {
            _isLoadingInterstitial = false;
          });
        },
      ),
    );
  }
    void _showInterstitial() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    } else {
      print("Interstitial Ad is null");
    }
  }
  
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createInterstitialAd();
    
  }

  
  void _showCallOptions(dynamic context) {
    final size = MediaQuery.of(context).size;
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 220,
        width: size.width, // Adjust height as needed
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Prevent exceeding screen height
          children: [
            InkWell(
              onTap: () async {
               
              int location=WallpaperManager.LOCK_SCREEN;
              var file= await DefaultCacheManager().getSingleFile(widget.imageurl);
              bool result = await WallpaperManager.setWallpaperFromFile(file.path, location); 
              },
              child: const ListTile(
                leading: Icon(Icons.lock,size: 20,),
                title: Text("Lock Screen",style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
            InkWell(
              onTap: () async {

               
              int location=WallpaperManager.HOME_SCREEN;
              var file= await DefaultCacheManager().getSingleFile(widget.imageurl);
              bool result = await WallpaperManager.setWallpaperFromFile(file.path, location);
              if (result) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Wallpaper set successfully!'),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Failed to set wallpaper. Please try again.'),
                ),
              );
            } 
              },
              child: const ListTile(
                leading: Icon(Icons.home,size: 20,),
                title: Text("Home Screen",style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
            InkWell(
              onTap: () async {
               
              int location=WallpaperManager.BOTH_SCREEN;
              var file= await DefaultCacheManager().getSingleFile(widget.imageurl);
              bool result = await WallpaperManager.setWallpaperFromFile(file.path, location); 
              },
              child: const ListTile(
                leading: Icon(Icons.photo_library,size: 20,),
                title: Text("Both",style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            )
          ],
        ),
      ),
    );
  }


  
@override
Widget build(BuildContext context) {
  return Scaffold(
    floatingActionButton: Container(
      padding: EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () async {
              // _showInterstitial;
              _showInterstitial();
              try {
                final tempDir = await getTemporaryDirectory();
                final filePath = '${tempDir.path}/myfile.jpg';

                final dio = Dio();
                final response = await dio.download(widget.imageurl, filePath,
                    onReceiveProgress: (received, total) {
                  if (total != null) {
                    print((received / total * 100).toStringAsFixed(2) + "%");
                  }
                });

                if (response.statusCode == 200) {
                  await GallerySaver.saveImage(filePath, albumName: "Messi Wallpaper");

                  // Show success snackbar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Downloaded to Gallery"),
                      backgroundColor: Color.fromARGB(255, 29, 241, 36),
                    ),
                  );
                } else {
                  // Handle download error (optional)
                  print("Download failed with status code: ${response.statusCode}");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Download failed"), backgroundColor: Colors.red,),
                  );
                }
              } catch (error) {
                // Handle any other errors during download or saving
                print("Error downloading image: $error");
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Error downloading image")),
                );
              }
            },
            child: Icon(Icons.save_alt_rounded, size: 30, color: Colors.white,),
          ),
          SizedBox(width: 30,),
          InkWell(
            onTap: () {
              _showCallOptions(context);
              _showInterstitial();
            },
            child: Icon(Icons.phone_android_rounded, size: 30, color: Colors.white,),
          )
        ],
      ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    body: _isLoadingInterstitial
        ? Center(child: CircularProgressIndicator()) // Show loading indicator
        : Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.imageurl),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
}
