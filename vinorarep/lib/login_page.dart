import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'auth_provider.dart';
import 'package:toast/toast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:progress_dialog/progress_dialog.dart';
class LoginPage extends StatefulWidget{
  const LoginPage({this.onSignedIn});
  final VoidCallback onSignedIn;
  @override
  State<StatefulWidget> createState() =>new _LoginPageState();
  }
  

  
  class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin
  {
    String _email ,_password;
    final formKey=new GlobalKey<FormState>();
    ProgressDialog pr;
  
    
  String _resetEmail=null;
   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    @override
    Widget build(BuildContext context) {
      
      // TODO: implement build
      return new Scaffold(
        
        resizeToAvoidBottomInset: false,
        body: 
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
            image: AssetImage("images/background.jpg"),
            fit: BoxFit.cover,
          ),
          ),
          child: SingleChildScrollView ( 
          
          child: Stack(
            
          children: <Widget>[
            new Container(padding:EdgeInsets.all(11.0),
          child: new Form(
            key: formKey,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children:logo()+slogan()+buidInputs()+forgotButton()+buildSubmitButtons(),
                                                          ),
                                                        ),
                                                      ),
                        ],
                      ),),)
        
                                                    );
                                                  }
                                List<Widget> buidInputs(){
                                  
                                  return [Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child:new TextFormField(
                                  style: TextStyle(color: Colors.black,),
                                  
                                decoration: new InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(

                                  ),
                                  labelText: 'Enter Email', 
                                  suffixIcon: Icon(Icons.email)   ),
                                validator: (value)=>value.isEmpty?"Email can't be Empty":null ,
                                onSaved: (value)=>_email=value,
                              ),
                              
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child:new TextFormField(
                                decoration: new InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(),
                                  labelText: 'Password',
                                ),
                                validator: (value)=>value.isEmpty?"Password can't be Empty":null ,
                                obscureText: true,
                                onSaved: (value)=>_password=value,
                              ),
                              
                              ),
                              ];
                                
                                }
                
                              List<Widget> buildSubmitButtons(){
                                
                                    return [SizedBox(
                                width: 150,
                                height: 45,
                                child:RaisedButton (    
                                           
                                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                child: new Text("Login",
                                style: new TextStyle(fontSize: 20.0,color: Colors.black,)),
                                color: Theme.of(context).accentColor,
                                elevation: 4.0,   
                                splashColor: Colors.green,
                                onPressed: validateAndSubmit,
                                              ),
                              
                                              ),
                                ];
                                
                                                
                                              }
                                              bool validateMobile(String value) {
                                                String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                                RegExp regExp = new RegExp(patttern);
                                                
                                                 if (!regExp.hasMatch(value)) {
                                                      return false;
                                                }
                                                return true;
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
                                                
                                                  Future<FirebaseUser> validateAndSubmit() async {
                                                    var connectivityResult = await (Connectivity().checkConnectivity());
                                                    
                                                    if(validateAndSave()){
                                                      if (connectivityResult == ConnectivityResult.mobile||connectivityResult == ConnectivityResult.wifi) {
                                                          
                                                        try{
                                                        final BaseAuth auth = AuthProvider.of(context).auth;
                                                      
                                                           await auth.signInWithEmailAndPassword(_email, _password);
                                                         widget.onSignedIn();
                                                   
                                                    }catch(e){
                                                      
                                                      Toast.show("Fail\n"+e.toString(), context, duration: 4, gravity:  Toast.BOTTOM,backgroundColor: Colors.red);
                                                    }
                                                    } else{
                                                      
                                                      Toast.show("Please Check The Internet Connection", context, duration: 4, gravity:  Toast.BOTTOM,backgroundColor: Colors.red);
                                                      
                                                    }
                                                      
                                                  }
                                                }
                                              
                                              
                                              
                               
                              
                           
              
                
                                 List<Widget> logo() {
                                   AssetImage assetImage=AssetImage('images/logo1.png');
                                   Image image=Image(image:assetImage,width: 150,height: 150);
                               return[
                                 SizedBox(height:50.0),
                                 Text("VinoraRep",style: TextStyle(
                                   fontSize: 45.0,
                                   fontFamily: 'KAUSHANSCRIPT',
                                   fontStyle: FontStyle.normal,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black,
                                   letterSpacing: 1,
                                   shadows: [
                      
                      Shadow( // bottomRight
                        offset: Offset(1.5, -1.5),
                        color: Colors.grey
                      ),
                      Shadow( // topRight
                        offset: Offset(1.5, 1.5),
                        color: Colors.grey
                      ),
                      
                    ] ),),                  
                                  image
                                 ];
                             }
              
                             List<Widget> slogan() {
                                   return[
                                     Text("The Next Level Of Ordering ...",
                                     
                                     textScaleFactor: 1, style: new TextStyle(
                                       letterSpacing: 3,
                                       fontWeight: FontWeight.bold,),),
                                       SizedBox(height: 10,)
                                   ];
                             }
              
                List<Widget> forgotButton() {
                  return [
                    
                    FlatButton(
                      child: Text("Forgot Password ?"),
                      onPressed: (){
                        showDialogforemail(context);
                                              },
                                            )
                                          ];
                                        }
                          Future<bool> showDialogforemail(BuildContext context) async {
                                      return showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Forgot Password ?', style: TextStyle(fontSize: 16.0)),
                                              content: Container(
                                                height: 80.0,
                                                width: 80.0,
                                                child: Column(
                                                  children: <Widget>[
                                                    TextField(
                                                      decoration: InputDecoration(
                                                          labelText: 'Enter Your Email',
                                                          labelStyle: TextStyle(
                                                              fontFamily: 'Montserrat',
                                                              fontWeight: FontWeight.bold)),
                                                      onChanged: (value) {
                                                        _resetEmail=value;
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
                                                  child: Text('Send'),
                                                  textColor: Colors.blue,
                                                  onPressed: () {
                                                 
                                                      sendEmail();
                                                                     
                                                    Navigator.of(context).pop(); 
                                                                     
                                                                    },
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      }
                          Future sendEmail() async {
                            try{
                               
                              _firebaseAuth.sendPasswordResetEmail(email: _resetEmail);
                               Toast.show("Email send Sucessfully ", context, duration: 4, gravity:  Toast.BOTTOM,backgroundColor: Colors.green);
                              
                            }catch(e)
                            {
                              Toast.show(e.message, context, duration: 4, gravity:  Toast.BOTTOM,backgroundColor: Colors.red);
                            }
                             
                          }
                 
  
}