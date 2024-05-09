import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:wallpaperworld/ADS/adsmanager.dart';
import 'package:wallpaperworld/views/screens/FullScreen.dart';
import 'package:wallpaperworld/controller/apiOper.dart';
import 'package:wallpaperworld/model/categoryModel.dart';
import 'package:wallpaperworld/model/photosModel.dart';
import 'package:wallpaperworld/views/screens/FullScreen.dart';
import 'package:wallpaperworld/views/widgets/CustomAppBar.dart';
import 'package:wallpaperworld/views/widgets/SearchBar.dart';
import 'package:wallpaperworld/views/widgets/catBlock.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<PhotosModel> trendingWallList;
  late List<CategoryModel> CatModList;
  bool isLoading = true;
  BannerAd? _banner;

  void _createBannerAd() {
    _banner = BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdsManger.bannerAdUnit!,
        listener: AdsManger.bannerAdListener,
        request: const AdRequest())..load();
  }
  @override
  void initState() {
    super.initState();
    GetCatDetails();
    GetTrendingWallpapers();
    _createBannerAd();
  }
  
  GetCatDetails() async {
    CatModList = await ApiOperations.getCategoriesList();
    print("GETTTING CAT MOD LIST");
    print(CatModList);
    setState(() {
      CatModList = CatModList;
    });
  }

  GetTrendingWallpapers() async {
    trendingWallList = await ApiOperations.getTrendingWallpapers();

    setState(() {
      isLoading = false;
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: CustomAppBar(
          word1: "Wallpaper",
          word2: "world",
        ),
      ),
      body:  isLoading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Searchbar()),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: CatModList.length,
                    itemBuilder: ((context, index) => CatBlock(
                          categoryImgSrc: CatModList[index].catImgUrl,
                          categoryName: CatModList[index].catName,
                        ))),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 700,
              child: RefreshIndicator(
                onRefresh: () async {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
                child: GridView.builder(
                    physics: BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisExtent: 400,
                        crossAxisCount: 2,
                        crossAxisSpacing: 13,
                        mainAxisSpacing: 10),
                    itemCount: trendingWallList.length,
                    itemBuilder: ((context, index) => GridTile(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FullScreen(
                                          imageurl:
                                              trendingWallList[index].imgSrc)));
                            },
                            child: Hero(
                              tag: trendingWallList[index].imgSrc,
                              child: Container(
                                height: 800,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.amberAccent,
                                    borderRadius: BorderRadius.circular(20)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    trendingWallList[index].imgSrc,
                                      height: 800,
                                      width: 50,
                                      fit: BoxFit.cover,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ))),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: _banner == null
            ? Container()
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _banner!),
              ),
    );
  }
}
