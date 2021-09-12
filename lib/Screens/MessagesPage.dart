import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import '../functions/database_function.dart';

class MessagesPage extends StatefulWidget {
  final classId;
  final GoogleSignInAccount? userInfo;

  const MessagesPage({Key? key, this.classId, this.userInfo}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {

  String message="";
  var myController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: Database().getMessageStrem(widget.classId),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Container();
                  }

                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      var msg=snapshot.data!.docs[index];

                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.grey.withOpacity(0.5),
                                    radius: 5,
                                  ),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(msg["name"],
                                  style: TextStyle(
                                    color: Colors.grey.withOpacity(0.5),
                                  ),
                                  ),
                                ],
                              ),
                              if(msg["type"]=="image")
                              MessageImage(
                                imageLink: msg["text"],
                              ),
                              if(msg["type"]=="text")
                              MessageText(
                                text:msg["text"] ,
                              ),
                            ],
                          ),
                        );


                    },


                      );
                }),
          ),
          Container(
              // color: Colors.black54,
              height: 100,
              child: Row(
                children: [
                  IconButton(onPressed: () async {
                    //@todo get photo and upload

                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 10);

                    if(image!=null){
                      Database().sendMessage((await Database().updateProfilePicture(image.path)), widget.userInfo!.displayName, "image", widget.classId);
                    }else{
                      return;
                    }


                  }, icon: Icon(Icons.photo)),
                  Expanded(
                    child: TextField(
                      onChanged: (value){
                        message=value;
                      },
                      controller: myController,
                      decoration: new InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                        border: const OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 0.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 60,
                      child: FlatButton(
                          onPressed: () async {
                            //@todo send message
                            if(message==""){
                              return;
                            }
                            Database().sendMessage(message, widget.userInfo!.displayName, "text", widget.classId);
                            myController.clear();
                            message="";

                          }, child: Icon(Icons.send))),
                ],
              )),
        ],
      ),
    );
  }
}

class MessageImage extends StatelessWidget {
  const MessageImage({Key? key, this.imageLink}) : super(key: key);
final imageLink;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CachedNetworkImage(
        imageUrl: imageLink??"http://via.placeholder.com/350x150",
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
        height: MediaQuery.of(context).size.width*0.8,
        width: double.infinity,
      ),
    );
  }
}

class MessageText extends StatelessWidget {
  const MessageText({Key? key ,this.text}) : super(key: key);
  final text;

  @override
  Widget build(BuildContext context) {
    return Container(

      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(text??"Dummy"),
      ),
    );
  }
}
