import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  final String? name;
  final String? email;
  final String? imageUrl;

  final String? id;

  UserDataModel({this.name, this.email, this.imageUrl, this.id});

  //Create a method to convert QuerySnapshot from Cloud Firestore to a list of objects of this DataModel
  //This function in essential to the working of FirestoreSearchScaffold

  List<UserDataModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> dataMap = snapshot.data() as dynamic;

      return UserDataModel(
          name: dataMap['name'],
          email: dataMap['email'],
          imageUrl: dataMap['photo'],
          id: dataMap['id']);
    }).toList();
  }
}
