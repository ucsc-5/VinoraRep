import 'package:flutter/material.dart';
import '../theme.dart';

class UpperBar extends StatelessWidget {
  final bool isExpanded;
   final String name;
  final String address;
  final String contactNumber;
  const UpperBar({Key key,  @required this.isExpanded, @required this.name,@required this.address,@required this.contactNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(children: <Widget>[
                Text(name, style: AppTheme.headline)
              ]),
              
            ],
          ),
        ),
       
        isExpanded
            ? Padding(
                padding: EdgeInsets.only(left: 20, right: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_on, size: 20),
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, top: 10.0, bottom: 10),
                            child:
                                Text(address, style: AppTheme.subtitle))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.phone, size: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(contactNumber, style: AppTheme.subtitle),
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("kfdkf",
                              style: AppTheme.subtitle),
                        )
                      ],
                    )
                  ],
                ))
            : Container(height: 10)
      ],
    );
  }
}
