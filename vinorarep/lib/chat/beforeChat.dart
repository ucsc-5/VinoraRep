import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:targets/chat/chat.dart';
import 'package:targets/theme.dart';
class BChat extends StatefulWidget {
  String companyId;
  String retailerId;
  BChat({Key key, @required this.companyId,@required this.retailerId})
      : super(key: key);
  @override
  _BChatState createState() => _BChatState();
}

class _BChatState extends State<BChat> {
  String id;
  @override
  void initState() {
    id=widget.retailerId;
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Members"),
      ),
      body: Padding(padding: EdgeInsets.all(10),
      child: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('retailers').orderBy('chatTime',descending: true).where('chatState',isEqualTo:1).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new Column(
                  children: <Widget>[
                    
                    ListTile(
                  title: new Text(document['shopName'],style: AppTheme.headline,),
                  leading: CircleAvatar(  
                    radius: 30,
                                backgroundImage: NetworkImage(
                                   document['url'] ),
                                backgroundColor:
                                    Colors.transparent,
                              ),
                  onTap: (){
                    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Chat(retailerId: document.documentID,companyId: widget.companyId,id:id),
      ),
    );
                  },           
                              
                ),
                new Divider()
                  ],
                );
              }).toList(),
            );
        }
      },
    ),
    ),
    );
  }
}