import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:dash_chat/dash_chat.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';  
class Chat extends StatefulWidget {
  String id;
  String retailerId;
  String companyId;
  Chat({Key key, @required this.retailerId,@required this.companyId,@required this.id})
      : super(key: key);
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  ChatUser user = ChatUser();
  
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;
  void getUserId() async{
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        FirebaseUser user1 = await _firebaseAuth.currentUser();
        setState(() {
          user.uid=user1.uid;
          user.name=user1.email;
        });
       }
       void getAvatar() {
        Firestore.instance
        .collection('salesRepresentatives')
        .document(widget.id)
        .get()
        .then((DocumentSnapshot ds) {
          user.avatar=ds['salesRefImagePath'];
          user.name=ds['fullName'];
          
    });

      }
  @override
  void initState() {
    user.name = "Name Loading ..";
    user.uid = Uuid().v4().toString();
    getUserId();
    getAvatar();
    super.initState();
    }
    
    void onSend(ChatMessage message) {
    var documentReference = Firestore.instance
        .collection('message')
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        message.toJson(),
      );
    }).then((onValue){
          Firestore.instance.runTransaction((Transaction tx) async {
          DocumentSnapshot postSnapshot = await tx.get(documentReference);
          if (postSnapshot.exists) {
            await tx.update(documentReference, <String, dynamic>{'companyId': widget.companyId,'retailerId':widget.retailerId});
          }
        }).then((onValue){
          Firestore.instance
        .collection('retailers')
        .document(widget.retailerId)
        .get()
        .then((DocumentSnapshot ds) {
      Firestore.instance.runTransaction((Transaction tx) async {
          DocumentSnapshot postSnapshot = await tx.get(documentReference);
          if (postSnapshot.exists) {
            await tx.update(documentReference, ds.data);
          }
        });
        
    });
        });
        
    
        });
  }
  void uploadFile() async {
    File result = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 400,
      maxWidth: 400,
    );

    if (result != null) {
      String id = Uuid().v4().toString();

      final StorageReference storageRef =
          FirebaseStorage.instance.ref().child("chat_images/$id.jpg");

      StorageUploadTask uploadTask = storageRef.putFile(
        result,
        StorageMetadata(
          contentType: 'image/jpg',
        ),
      );
      StorageTaskSnapshot download = await uploadTask.onComplete;

      String url = await download.ref.getDownloadURL();

      ChatMessage message = ChatMessage(text: "", user: user, image: url);

      var documentReference = Firestore.instance
          .collection('message')
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          message.toJson(),
        );
      }).then((onValue){
          Firestore.instance.runTransaction((Transaction tx) async {
          DocumentSnapshot postSnapshot = await tx.get(documentReference);
          if (postSnapshot.exists) {
            await tx.update(documentReference, <String, dynamic>{'companyId': widget.companyId,'retailerId':widget.retailerId});
          }
        }).then((onValue){
          Firestore.instance
        .collection('retailers')
        .document(widget.retailerId)
        .get()
        .then((DocumentSnapshot ds) {
      Firestore.instance.runTransaction((Transaction tx) async {
          DocumentSnapshot postSnapshot = await tx.get(documentReference);
          if (postSnapshot.exists) {
            await tx.update(documentReference, ds.data);
          }
        });
        
    });
        });
        
    
        });
    }
  }
  
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Chat") ,
        ),
        body:  StreamBuilder(
        stream: Firestore.instance.collection('message').where('retailerId',isEqualTo:widget.retailerId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            );
          } else {
            List<DocumentSnapshot> items = snapshot.data.documents;
            var messages =
                items.map((i) => ChatMessage.fromJson(i.data)).toList();
            return DashChat(
              user: user,
              messages: messages,
              inputDecoration: InputDecoration(
                hintText: "Message here...",
                border: InputBorder.none,
              ),
              
              onSend: onSend,
              scrollToBottom: false,
              trailing: <Widget>[
                IconButton(
                  icon: Icon(Icons.photo),
                  onPressed: uploadFile,
                )
              ],
            );
          }
        },
      ),
      );
    }
  
    
}
