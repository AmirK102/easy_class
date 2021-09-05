import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';

class SelectCR extends StatefulWidget {
  const SelectCR({Key? key}) : super(key: key);

  @override
  _SelectCRState createState() => _SelectCRState();
}

class _SelectCRState extends State<SelectCR> {
  SearchBarController _searchBarController = SearchBarController();
  final dbref = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                height: 80,
                child: SearchBar(),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: dbref.collection("user").snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData)
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 100,
                                child: ListTile(
                                  leading: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    height: 96,
                                    width: 96,
                                    imageUrl: (snapshot.data!.docs[index].data()
                                        as dynamic)['photo'],
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  title: Text((snapshot.data!.docs[index].data()
                                      as dynamic)['name']),
                                  subtitle: Text((snapshot.data!.docs[index]
                                      .data() as dynamic)['email']),
                                ),
                              );
                            });
                      return Container();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
