import 'package:flutter/material.dart';
import 'package:wallpaperworld/views/screens/category.dart';

class CatBlock extends StatelessWidget {
  String categoryName;
  String categoryImgSrc;
  CatBlock(
      {required this.categoryImgSrc, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryScreen(
                    catImgUrl: categoryImgSrc, catName: categoryName)));
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 7),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                categoryImgSrc,
                  height: 50, width: 100, fit: BoxFit.cover),
            ),
            Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12)),
            ),
            Positioned(
                left: 30,
                top: 15,
                child: Text(
                  categoryName,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ))
          ],
        ),
      ),
    );
  }
}
