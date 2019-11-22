import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:targets/auth_provider.dart';
import 'package:targets/chat/beforeChat.dart';
import 'package:targets/chat/chat.dart';
import '../pages/home_page.dart';
import '../pages/profile_page.dart';
import '../auth.dart';
class MainScreen extends StatefulWidget { 
  final String name;
  final String address;
  final String contactNumber;
  final String imagePath;
  final String companyId;
  final String retailerId;
   MainScreen({Key key,  @required this.name,@required this.address,@required this.contactNumber,@required this.imagePath,@required this.companyId,@required this.retailerId}): super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();

}
class _MainScreenState extends State<MainScreen> {
  String id;
  int currentTab = 0;
  HomePage homePage;
  Profile profilePage;

  List<Widget> pages;
  Widget currentPage;

  @override
  void initState() {
    
    homePage = HomePage(name:widget.name,address:widget.address,contactNumber:widget.contactNumber,imagePath:widget.imagePath,companyId:widget.companyId,retailerId: widget.retailerId,);
    
    profilePage = Profile();
    pages = [homePage, profilePage];

    currentPage = homePage;
    
    super.initState();
    getUserId();
        
    
      }
    
      @override
      Widget build(BuildContext context) {
        final BaseAuth auth = AuthProvider.of(context).auth;
        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        
        return Scaffold(
          
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: false,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentTab,
            onTap: (index) {
              setState(() {
                currentTab = index;
                currentPage = pages[index];
              });
            },
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                title: Text("Assignning Orders"),
              ),
              
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                title: Text("Profile"),
              ),
            ],
          ),
          body: currentPage,
          
          floatingActionButton: FloatingActionButton (
                              
                                        child: Icon(Icons.chat),
                                        onPressed: (){
                                          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BChat(companyId:widget.companyId,retailerId:id)
          ),
        );
                                        },
                                      ),
        );
      }
    
      void getUserId() async{
        final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
        FirebaseUser user1 = await _firebaseAuth.currentUser();
        setState(() {
          id=user1.uid;
          
          
        });
      }
}
