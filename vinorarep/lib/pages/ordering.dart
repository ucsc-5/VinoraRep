import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:targets/companies/RoyalVintage.dart';
import 'package:targets/components/order_upper_bar.dart';

class Ordering extends StatefulWidget{
  final String name;
  final String description;
  final int unitPrice;
  final String imagePath;
  final String itemId;
  final double countity;
  final String companyId;
  final String address;
  final String companyName;
  final String companyContact;
  final String companyImage;
  final String brand;
  final String state;
  final String type;
  Ordering({Key key,  @required this.name,@required this.description,@required this.unitPrice,@required this.imagePath,@required this.itemId,@required this.countity,@required this.companyId,@required this.address,@required this.companyContact,@required this.companyName,@required this.companyImage,@required this.brand,@required this.state,@required this.type}):super(key: key);
  @override
  _OrderingState createState() => _OrderingState();
}

class _OrderingState extends State<Ordering>{
  String availabelCount;
  double subTotal=0;
  String _reqQuantity;
  final formKey=new GlobalKey<FormState>();
  @override
  void initState() {
    
    super.initState();
    availabelCount=widget.countity.toString();
  }
  @override
  Widget build(BuildContext context){
    
        return Scaffold(
          
          body: 
          Container(
                width: double.maxFinite,
                height: double.maxFinite,
                child: Stack(
                  children: <Widget>[
                    Container(
                      
                      decoration: BoxDecoration(
                        color: Colors.blueGrey
                      ),
                        
                       child:Image.network(
                      widget.imagePath,width: MediaQuery.of(context).size.width,height: 280,
                      fit: BoxFit.cover,
                    
                      
                    ),
                    ),
                   
                    Positioned(
                      top: 250,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0))),
                        child: Column(
                          children: <Widget>[
                            OrdedrUpperBar( name:widget.name,description:widget.description,unitPrice:widget.unitPrice,countity: double.parse(availabelCount)),
                            Form(
                              key: formKey,
                              child:Padding(
                                padding: const EdgeInsets.all( 15),
                                child:new TextFormField(
                                decoration: new InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Quantity',
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: Icon(Icons.add_shopping_cart) 
                                ),
                                validator: (value)=>value.isEmpty?"Quantity can't be Empty":null ,
                                
                                onSaved: (value)=>_reqQuantity=value,
                                keyboardType: TextInputType.number,
                              ),
                              
                              ) ,
                            ),
                            SizedBox(height: 30,),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 55,
                                
                                child:Padding(
                                  padding: EdgeInsets.only(left:20,right: 20),
                                  child: RaisedButton (    
                                           
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                child: new Text("Add to the Cart ",
                                style: new TextStyle(fontSize: 20.0,color: Colors.black,)),
                                color: Theme.of(context).accentColor,
                                elevation: 4.0,   
                                splashColor: Colors.green,
                                onPressed: validateAndSubmit,
                                                                              ),
                                )
                                
                                                              
                                                                              ),
                                                      ],
                                                    ),
                                                    
                                                  ),
                                                ),
                                                
                                              ],
                                            ))
                                      
                                    );
                                    
                                  }
                                
                                
                                  void validateAndSubmit() async {
                                    if(validateAndSave()){
                                                        
                                                        try{
                                                  if(widget.countity.toDouble()>=double.parse(_reqQuantity)&&widget.countity.toDouble()>=0&&double.parse(availabelCount)>=0 ){
                                                    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                                                    FirebaseUser user = await _firebaseAuth.currentUser();
                                                      
                                                final DocumentReference postRef = Firestore.instance.document('items/${widget.itemId}');
                                                Firestore.instance.runTransaction((Transaction tx) async {
                                                  DocumentSnapshot postSnapshot = await tx.get(postRef);
                                                  if (postSnapshot.exists&&postSnapshot.data['quantity']>=0) {
                                                    await tx.update(postRef, <String, dynamic>{'quantity': postSnapshot.data['quantity'] - double.parse(_reqQuantity)});
                                                    setState(() {
                                                      availabelCount= (postSnapshot.data['quantity'] - double.parse(_reqQuantity)).toString();
                                                      //subTotal=postSnapshot.data['subTotal'] +(widget.unitPrice* double.parse(_reqQuantity));
                                                    });
                                                    

                                                    Firestore.instance.collection('cart').document()
                                                .setData({ 'itemId': widget.itemId, 'quantity': double.parse(_reqQuantity),'companyId':widget.companyId,'retailerId':user.uid,'itemName':widget.name,'itemImagePath':widget.imagePath,'unitPrice':widget.unitPrice,'total':(widget.unitPrice* double.parse(_reqQuantity)),'description':widget.description,'state':widget.state,'type':widget.type,'brand':widget.brand});
                                                  }
                                                });
                                                Toast.show("Your Item is added to Cart", context, duration: 4, gravity:  Toast.BOTTOM,backgroundColor: Colors.green);
                                               /* Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MainScreen(name:widget.companyName,address:widget.address,contactNumber:widget.companyContact,imagePath:widget.companyImage,companyId:widget.companyId,),
                                                ),
                                              );*/
                                                          }else{
                                                             Toast.show("There is no Enough Countity in the Stock.", context, duration: 4, gravity:  Toast.BOTTOM,backgroundColor: Colors.red);
                                                          }
                                                        
                                                   
                                                    }catch(e){
                                                      
                                                      Toast.show("Fail\n"+e.toString(), context, duration: 4, gravity:  Toast.BOTTOM,backgroundColor: Colors.red);
                                                    }
                                                    
                                                      
                                                  }


  }
  bool validateAndSave() {
                                                final form =formKey.currentState;
                                                if(form.validate()){
                                                  form.save();
                                                  return true;
                                                }else{
                                                  return false;
                                                }
                                                                    
                                                  }
}