import 'package:flutter/material.dart';
import '../theme.dart';

class OrdedrUpperBar extends StatelessWidget {
  
   final String name;
  final String description;
  final int unitPrice;
  final double countity;
  const OrdedrUpperBar({Key key, @required this.name,@required this.description,@required this.unitPrice,@required this.countity})
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
       Divider(),
         Padding(
                padding: EdgeInsets.only(left: 20, right: 10),
                child: Column(
                  children: <Widget>[
                    
                    Row(
                      children: <Widget>[
                        Text("Price - Rs :", style: AppTheme.subHeadline),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(unitPrice.toString(), style: AppTheme.subHeadline),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                       Text("Available - Kg :", style: AppTheme.subHeadline),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(countity.toString(), style: AppTheme.subHeadline),
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(description,
                              style: AppTheme.subtitle),
                        )
                      ],
                    )

                  ],
                ))
            
      ],
    );
  }
}
