import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:targets/login_page.dart';


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  ProgressDialog pr;
  var imageUrl="https://www.stickpng.com/assets/images/585e4bf3cb11b227491c339a.png";
  File newProfilePic;
  
  String name="Name Loading ...";
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
     newProfilePic=image; 
     uploadImage();
    });
    
  }
  
  uploadImage() async{
    
    setState(() {
     isLoading=true; 
    });
    if(newProfilePic!=null){
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      FirebaseUser user = await _firebaseAuth.currentUser();
    final StorageReference firebaseStorageRef=FirebaseStorage.instance.ref().child(
      'profilepics/${DateTime.now()}/${user.uid}.jpg'
    );
    
    StorageUploadTask task=firebaseStorageRef.putFile(newProfilePic);
    StorageTaskSnapshot storageTaskSnapshot = await task.onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
                    
                    
                      final DocumentReference postRef = Firestore.instance.document('salesRepresentatives/${user.uid}');
Firestore.instance.runTransaction((Transaction tx) async {
  DocumentSnapshot postSnapshot = await tx.get(postRef);
  if (postSnapshot.exists) {
    await tx.update(postRef, <String, dynamic>{'salesRefImagePath': downloadUrl});
  }
});
Firestore.instance
        .collection('salesRepresentatives')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot ds) {
          setState(() {
            isLoading=false;
          imageUrl=ds['salesRefImagePath'];
          });
      // use ds as a snapshot
    });
        
      
    
    
    }
  
  }
  @override
  void initState() {
    
        currentUser();
        super.initState();
        
      }
      Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser().then((onValue){
      Firestore.instance
        .collection('salesRepresentatives')
        .document(onValue.uid)
        .get()
        .then((DocumentSnapshot ds) {
          setState(() {
            
            name=ds.data['fullName'];
            imageUrl=ds.data['salesRefImagePath'];
          });
      // use ds as a snapshot
    });
    });
    
   
      return user != null ? user.uid : null;
  }
  bool isLoading = false;
      @override
      Widget build(BuildContext context) {
        return new Scaffold(
            body: new Stack(
              
          children: <Widget>[
            ClipPath(
              child: Container(color: Colors.deepPurple.withOpacity(0.8)),
              clipper: getClipper(),
            ),
            Positioned(
                left: MediaQuery.of(context).size.width/12,
                top: MediaQuery.of(context).size.height / 4,
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                        width: 150.0,
                        height: 150.0, 
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                              alignment: Alignment.center,
                                image: NetworkImage(
                                  
                                    imageUrl),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(Radius.circular(75.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ])),
                    SizedBox(height: 20.0),
                    getLoader(),
                    SizedBox(height: 20.0),
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                        margin: new EdgeInsets.symmetric(horizontal: 5.0),
                          
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                              editName(context);
                            },
                            child: Center(
                              child: Text(
                                'Edit Name',
                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
                        
                        Container(
                          margin: new EdgeInsets.symmetric(horizontal: 5.0),
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                getImage();
                              });
                              
                            },
                            child: Center(
                              child: Text(
                                'Edit Photo',
                                style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        )),
                        
                    Container(
                      margin: new EdgeInsets.symmetric(horizontal: 5.0),
                        height: 30.0,
                        width: 95.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.redAccent,
                          color: Colors.red,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () {
                              logOut();
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              'Log out',
                                                              style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                                                            ),
                                                          ),
                                                        ),
                                                      ))
                                                    ],
                                                  ),
                                                  
                                                  
                                                  
                                                ],
                                              ))
                                        ],
                                      ));
                                    }
                                    Future<bool> editName(BuildContext context) async {
                                      return showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Change Your Name', style: TextStyle(fontSize: 16.0)),
                                              content: Container(
                                                height: 80.0,
                                                width: 80.0,
                                                child: Column(
                                                  children: <Widget>[
                                                    TextField(
                                                      decoration: InputDecoration(
                                                          labelText: 'New Name',
                                                          labelStyle: TextStyle(
                                                              fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.bold)),
                                                      onChanged: (value) {
                                                        name=value;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text('Exit'),
                                                  textColor: Colors.blue,
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text('Update'),
                                                  textColor: Colors.blue,
                                                  onPressed: () {
                                                  
                                                    setState(() {
                                                      isLoading=true;
                                                      updateName(name);
                                                    });                     
                                                                          
                                                    Navigator.of(context).pop(); 
                                                                     
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      }
                                                    
                                                      Future<bool> updateName(String name) async{
                                                        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                                                      FirebaseUser user = await _firebaseAuth.currentUser();
                                                        
                                                        final DocumentReference postRef = Firestore.instance.document('salesRepresentatives/${user.uid}');
Firestore.instance.runTransaction((Transaction tx) async {
  DocumentSnapshot postSnapshot = await tx.get(postRef);
  if (postSnapshot.exists) {
    await tx.update(postRef, <String, dynamic>{'fullName': name});
  }
});
                                                              setState(() {
                                                               isLoading=false; 
                                                              });
                                                              return true;
                                                        
                                                      }
                                    getLoader() {
                                  return isLoading
                                      ? Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            CircularProgressIndicator(),
                                          ],
                                        )
                                      : Container();
                                }
                              
                                void logOut() {
                                  _firebaseAuth.signOut();
                                  Navigator.push(context, MaterialPageRoute(builder:(context){
                              return (LoginPage());
                      }));
                                }
         
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 300, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}