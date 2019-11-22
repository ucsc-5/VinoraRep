import 'package:flutter/material.dart';
import 'package:targets/theme.dart';
import 'auth.dart';
import 'auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'companies/RoyalVintage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class HomePage extends StatefulWidget {
  
  final VoidCallback onSignedOut;
  
  HomePage({Key key, this.onSignedOut}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String id="null",name="Loding..",email="Loding..",firstLetter="L";
  String url="https://www.stickpng.com/assets/images/585e4bf3cb11b227491c339a.png";
  Future<void> signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }
  Future<String> currentUser() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    FirebaseUser user = await _firebaseAuth.currentUser();
    Firestore.instance
        .collection('salesRepresentatives')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot ds) {
          setState(() {
            url=ds['salesRefImagePath'];
          });
      // use ds as a snapshot
    });
    
      return user != null ? user.uid : null;
  }
  
  Future<String> getUserId() async{
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    
    FirebaseUser user = await _firebaseAuth.currentUser();
    id=user.uid;
    Firestore.instance
        .collection('salesRepresentatives')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot ds) {
          setState(() {
            setState(() {
        name=ds['fullName'];
        email=ds['email'];
        firstLetter=name.substring(0,1).toUpperCase();
      });
          });
      // use ds as a snapshot
    });
    
    
    return user != null ? user.uid : null;
  }
  
  @override
  void initState() {
   
    super.initState();
    currentUser();
    getUserId();
  }
    showAlertDialog(BuildContext context) {

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("No"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Yes"),
    onPressed:  () {
      signOut(context);
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("VinoraRep"),
    content: Text("Are you sure want to Exit ?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
              appBar: AppBar(
                title: Text('VinoraRep'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: () => showAlertDialog(context),
                    color: Colors.red,
                  )
                ],
              ),
              body:StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('companies').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new 
          Center(
            child: Text('Error: ${snapshot.error}'),
          )
          ;
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new Padding(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: Column(
                  children: <Widget>[
                    ListTile(
                  contentPadding:EdgeInsets.only(top: 10,bottom: 10,left: 10),
                  onTap: (){
                    document['state']=='1'?Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(name:document['companyName'],address:document['address'],contactNumber:document['contactNumber'],imagePath:document['imagePath'],companyId: document['companyId'],retailerId: document['retailerId'],),
      ),
    ):"";
                  },
                  leading: CircleAvatar(
                    radius: 30,
                                backgroundImage: NetworkImage(
                                   document['imagePath'] ),
                                backgroundColor:
                                    Colors.transparent,
                              ),
                  title: new Padding(
                    padding: EdgeInsets.only(left:10),
                    child:Text(document['companyName'],style: AppTheme.headline,) 
                  ) ,
                  subtitle: new Padding(
                    padding: EdgeInsets.only(left:10),
                    child:Text(document['address'],style: AppTheme.title,) ,
                  ) ,
                ),
                new Divider()
                  ],
                ),
                );
              }).toList(),
            );
        }
      },
    ),    
                    drawer: Drawer(child: ListView(
                                            children: <Widget>[
                                              UserAccountsDrawerHeader(
                                            accountName: Text(name),
                                            accountEmail: Text(email),
                                            currentAccountPicture: Container(
                      alignment: Alignment.center,
                        width: 150.0,
                        height: 150.0, 
                        decoration: BoxDecoration(
                            color: Colors.red,
                            image: DecorationImage(
                              alignment: Alignment.center,
                                image: NetworkImage(
                                  
                                    url),
                                fit: BoxFit.cover),
                            borderRadius: BorderRadius.all(Radius.circular(85.0)),
                            boxShadow: [
                              BoxShadow(blurRadius: 7.0, color: Colors.black)
                            ])),
                                            ),
                                            ListTile(
                                              title: Text("My Profile"),
                                              onTap: (){
                                    
                                              },
                                            ),
                                            ListTile(
                                              title: Text("My Profile"),
                                              onTap: (){
                                    
                                              },
                                            ),
                                            ListTile(
                                              title: Text("My Profile"),
                                              onTap: (){
                                    
                                              },
                                            ),
                                            ListTile(
                                              title: Text("My Profile"),
                                              onTap: (){
                                    
                                              },
                                            ),
                                            ListTile(
                                              title: Text("Exit"),
                                              onTap: (){
                                    
                                              },
                                            ),
                                            ],
                                          ),
                                            ),
                                            
                                          
                                            
                                        );
  }
}