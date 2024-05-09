import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List<QueryDocumentSnapshot> data = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("wallpaperworld").get();
        data.addAll(querySnapshot.docs) ;
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, i) {
            if (data.isEmpty) {
              return Center(
                child: CircularProgressIndicator(color: Colors.black,),
              );
            }
            return Text(
              '${data[i]['app_id']}',
            );
          },
        ),
      ),
    );
  }
}
