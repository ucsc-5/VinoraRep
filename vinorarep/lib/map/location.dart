import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:targets/requests/google_map_requests.dart';
class GetUserLocation extends StatefulWidget {
  final String companyId;
  final String retailerId;
  final String orderId;
  GetUserLocation({Key key, @required this.companyId,@required this.retailerId,@required this.orderId}): super(key: key);
  @override
  _GetUserLocationState createState() => _GetUserLocationState();
  
}

class _GetUserLocationState extends State<GetUserLocation> {
  int index=0;
  @override
  void initState() {
    Firestore.instance
        .collection('retailers')
        .document(widget.retailerId)
        .get()
        .then((DocumentSnapshot ds) {
          setState(() {
            index=ds['orderState'];
          });
      
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Map(companyId:widget.companyId,retailerId: widget.retailerId,orderId: widget.orderId,),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index ,
        onTap: (x){
          if(x==0){

          }else{
            final DocumentReference postRef = Firestore.instance.document('retailers/${widget.retailerId}');
            Firestore.instance.runTransaction((Transaction tx) async {
              DocumentSnapshot postSnapshot = await tx.get(postRef);
              if (postSnapshot.exists) {
                await tx.update(postRef, <String, dynamic>{'orderState': x});
                setState(() {
                  index=x;
                });
              }
            });
          }
        },
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle,
            ),
            title: Text("Pending"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle,
            ),
            title: Text("Accept"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle,
            ),
            title: Text("On the Way"),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.check_circle,
            ),
            title: Text("Delivered"),
          ),
        ],
      ),
      
            );
            
          }
        
          
}
class Map extends StatefulWidget {
  final String companyId;
  final String retailerId;
  final String orderId;
  Map({Key key, @required this.companyId,@required this.retailerId,@required this.orderId}): super(key: key);
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController mapController;
  GoogleMapsServices _googleMapsServices=GoogleMapsServices();
  TextEditingController locationController=TextEditingController();
  TextEditingController destinationController=TextEditingController();
  static LatLng _initialPosition;
  LatLng _lastPosition=_initialPosition;
  final Set<Marker> _markers={};
  final Set<Polyline> _polyLines={};
  double distance=0;
  String destinationPoint=null;
  LatLng preLocation;
  LatLng destination;
  double speed=0;
  String userId;
  @override
  void initState() {
    
    super.initState();
    getCurrentUserId();
    _getUserLocation();
    
        
    
            }
            @override
  void didChangeDependencies() {
    
    super.didChangeDependencies();
  }
         
        @override
      void setState(fn) {
        if(_initialPosition!=null&&preLocation!=null){
          _markers.remove(preLocation.toString()); 
        _markers.add(Marker(
            markerId: MarkerId(_initialPosition.toString()),
            position: _initialPosition,
            
            icon: BitmapDescriptor.defaultMarker));
        }
        super.setState(fn);
      }
          @override
          Widget build(BuildContext context) {
    
            return  _initialPosition==null?Container(
              alignment: Alignment.center,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ): Stack(
                children: <Widget>[
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _initialPosition,
                      zoom: 10.0,
                      
                      
                    ),
                    
                    
                    onMapCreated: onCreated,
                    myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    compassEnabled: true,
                    markers: _markers,
                    onCameraMove: _onCameraMove,
                    polylines: _polyLines,
                    
    
                    ),
           
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Align(alignment: Alignment.bottomCenter,child: Text("Distance : "+distance.toStringAsFixed(3)+" km "+"Speed :"+speed.toStringAsFixed(3)+" km/s",
                        style:TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,),),
                      ),
                      
      
                                          // Positioned(
                                          //   top:40,
                                          //   right: 10,
                                          //   child: FloatingActionButton(
                                          //     onPressed: _onAddMarkerPressed,
                                          //     tooltip: "add marker",
                                          //     backgroundColor: black,
                                          //     child: Icon(Icons.add_location,color: Colors.white,),
                                          //                                         ),
                                              
                                          //                                       )
                                                                              ],
                                                                            );
                                                                        }
                                                                      
                                                                        void onCreated(GoogleMapController controller) {
                                                                          setState(() {
                                                                           mapController=controller; 
                                                                          });
                                                            }
                                                          
                                                            void _onCameraMove(CameraPosition position) {
                                                              setState(() {
                                                                _lastPosition=position.target;
                                                              });
                                              
                                                }
                                              
                                                void _onAddMarkerPressed() {
                                                  setState(() {
                                                   _markers.add(Marker(markerId: MarkerId(_lastPosition.toString()),position: _lastPosition,infoWindow: InfoWindow(
                                                     title: "remember here",
                                                     snippet: "good place",
        
                                                   ),
                                                   icon: BitmapDescriptor.defaultMarker));
                                                  });
        
          }
          void _addMarker(LatLng location, String address) {
        _markers.add(Marker(
            markerId: MarkerId(_lastPosition.toString()),
            position: location,
            infoWindow: InfoWindow(title: address, snippet: "go here"),
            icon: BitmapDescriptor.defaultMarker));
        
      }
    
    
          List<LatLng> convertToLatLng(List points){
            List<LatLng> result=<LatLng>[];
            for(int i=0;i<points.length;i++){
              if(i%2!=0){
                result.add(LatLng(points[i-1],points[i]));
    
              }
            }
            return result;
          }
           List decodePoly(String poly) {
            var list = poly.codeUnits;
            var lList = new List();
            int index = 0;
            int len = poly.length;
            int c = 0;
        // repeating until all attributes are decoded
            do {
              var shift = 0;
              int result = 0;
        
              // for decoding value of one attribute
              do {
                c = list[index] - 63;
                result |= (c & 0x1F) << (shift * 5);
                index++;
                shift++;
              } while (c >= 32);
              /* if value is negetive then bitwise not the value */
              if (result & 1 == 1) {
                result = ~result;
              }
              var result1 = (result >> 1) * 0.00001;
              lList.add(result1);
            } while (index < len);
        
        /*adding to previous value as done in encoding */
            for (var i = 2; i < lList.length; i++) lList[i] += lList[i - 2];
        
            
        
            return lList;
          }
        
          void _getUserLocation() async {
            
            Firestore.instance
            .collection('retailers')
            .document(widget.retailerId)
            .snapshots().listen((data) async{
              
               
              setState(() {
                _initialPosition=LatLng(data.data['coord'].latitude,data.data['coord'].longitude);
                getDestination();

              });
            });
         
          }
          void getCurrentUserId() async {
                                      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                                      FirebaseUser user = await _firebaseAuth.currentUser();
                                      setState(() {
                                        userId=user.uid;
                                        var location=new Location();
                                        location.onLocationChanged().listen((LocationData currentLocation) async{
                                   
                                    speed=(currentLocation.speed)/1000;
                                    final DocumentReference postRef = Firestore.instance.document('retailers/${widget.retailerId}');
                                    Firestore.instance.runTransaction((Transaction tx) async {
                                      DocumentSnapshot postSnapshot = await tx.get(postRef);
                                      if (postSnapshot.exists) {
                                        await tx.update(postRef, <String, dynamic>{'coord': new GeoPoint(currentLocation.latitude,currentLocation.longitude)});
                                      }
                                    });
                                   
                                    
         
         
    });
                                        
                                     
                                      });
                                      
                                    }
    
          void sendRequest(LatLng intendedLocation) async {
        
        LatLng destination = LatLng(intendedLocation.latitude, intendedLocation.longitude);
        _addMarker(destination, "Your Location");
        String route = await _googleMapsServices.getRouteCoordinates(
            _initialPosition, destination);
        _createRoute(route);
        setState(() {
         getDistance(_initialPosition.latitude, _initialPosition.longitude, intendedLocation.latitude, intendedLocation.longitude) ;
        });
        
        
      }
    
      void _createRoute(String encodedPoly){
        setState(() {
          _polyLines.clear();
          _polyLines.add(Polyline(polylineId: PolylineId(_initialPosition.toString()),
          width: 3,
          points: convertToLatLng(decodePoly(encodedPoly)),
          color: Colors.black),
          
          );
        });
      }
        
        getDistance(a,b,c,d) async{
            double distance1 = await (Geolocator().distanceBetween(a, b, c, d))/1000;
            setState(() {
             distance=distance1; 
             //Toast.show("get Distance called${distance1.toString()}", context, duration: 1, gravity:  Toast.CENTER);
            });
            
        
      }
    
      void getDestination() {
        
        Firestore.instance
        .collection('retailers')
        .document(widget.retailerId)
        .snapshots().listen((data) async{
          setState(() {
            destination=LatLng(data.data['iniCoord'].latitude,data.data['iniCoord'].longitude);
            sendRequest(destination);
          });
          
        });
      }
  
}