import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_class/utilitis/user_data_model.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

typedef UserDataModelValue = UserDataModel Function(UserDataModel);

class SelectCR extends StatefulWidget {
  UserDataModelValue? callBackValue;
  SelectCR(this.callBackValue);

  @override
  _SelectCRState createState() => _SelectCRState();
}

class _SelectCRState extends State<SelectCR> {
  SearchBarController _searchBarController = SearchBarController();
  final dbref = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return FirestoreSearchScaffold(
      showSearchIcon: false,
      clearSearchButtonColor: Colors.white,
      scaffoldBody: Container(),
      firestoreCollectionName: 'student',
      searchBy: 'email',
      dataListFromSnapshot: UserDataModel().dataListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<UserDataModel> dataList = snapshot.data;

          return ListView.builder(
              itemCount: dataList.length != 0 ? dataList.length : 0,
              itemBuilder: (context, index) {
                final UserDataModel data = dataList[index];

                return InkWell(
                  onTap: () {
                    widget.callBackValue!(data);
                    Navigator.pop(context, data);
                  },
                  child: UserListView(
                    name: data.name,
                    email: data.email,
                    imageUrl: data.imageUrl,
                  ),
                );
              });
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class UserListView extends StatelessWidget {
  final name, imageUrl, email;

  const UserListView({Key? key, this.name, this.imageUrl, this.email})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CachedNetworkImage(
        fit: BoxFit.cover,
        height: 96,
        width: 96,
        imageUrl: imageUrl,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      title: Text(name),
      subtitle: Text(email),
    );
  }
}
