import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:targets/components/show_more_button.dart';
import 'package:targets/components/upper_bar.dart';
import 'package:targets/map/location.dart';
import 'package:targets/theme.dart';



class HomePage extends StatefulWidget{
  final String name;
  final String address;
  final String contactNumber;
  final String imagePath;
  final String companyId;
  final String retailerId;
  HomePage({Key key,  @required this.name,@required this.address,@required this.contactNumber,@required this.imagePath,@required this.companyId,@required this.retailerId}):super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  

  bool isExpanded=false;
  String userId;
  String retailerId;
  @override
  void initState() {
    getUserId();
    
            super.initState();
          }
          @override
          Widget build(BuildContext context){
            
                return Scaffold(
                  body: 
                  Container(
                        width: double.maxFinite,
                        height: double.maxFinite,
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            Image.network(
                                widget.imagePath),
                            Positioned(
                              top: 155,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0))),
                                child: Column(
                                  children: <Widget>[
                                    UpperBar( isExpanded: isExpanded,name:widget.name,address:widget.address,contactNumber:widget.contactNumber),
                                ShowMoreButton(
                                    isExpanded: isExpanded,
                                    callback: () {
                                      setState(() {
                                        isExpanded = !isExpanded;
                                      });
                                    }),
                                    Container(
                                      height:300,
                                      child:StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('orders').where("companyId", isEqualTo: widget.companyId).where("salesRepId",isEqualTo: userId).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                  
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting: return new
                  Center(
                    child: Text('Loading...'),
                  ) ;
                  
                  default:
                    return new ListView(
                      children: snapshot.data.documents.map((DocumentSnapshot document) {
                        
                                              
                                            return new Column(
                                              children: <Widget>[
                                                Divider(),
                                                ListTile(
                                              onTap: (){
                                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GetUserLocation(companyId: widget.companyId,retailerId: document['retailerId'],orderId: document.documentID,),
                                  ),
                                );
                                              },
                                              leading: CircleAvatar(
                                                child: Icon(Icons.add_shopping_cart),
                                              ),
                                              title: new Text(document['shopName'],style: AppTheme.headline),
                                              subtitle: Text("Rs : "+document['total'].toString(),style: AppTheme.title,),
                                              trailing: document['state']==0?Text("Pending...",style: TextStyle(color: Colors.yellowAccent,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),):Text("Accepted",style: TextStyle(color: Colors.green,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
                                            ),
                                            Divider(),
                                              ],
                                            );
                                          }).toList(),
                                        );
                                    }
                                  },
                                ),
                                                        )
                                                  
                                                  ],
                                                ),
                                                
                                              ),
                                            ),
                                          ],
                                        ))
                                  
                                );
                              }
                            
                              void getUserId() async{
                                final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                                 FirebaseUser user = await _firebaseAuth.currentUser();
                                  setState(() {
                                    userId=user.uid;
                                    
                                  });
                              }
                        
                   
    
      void getRetailerId() {
        Firestore.instance
        .collection('orders')
        .document('document-name')
        .get()
        .then((DocumentSnapshot ds) {
      // use ds as a snapshot
    });
      }

    

}