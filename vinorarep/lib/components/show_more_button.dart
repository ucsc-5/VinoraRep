import 'package:flutter/material.dart';
import 'package:targets/theme.dart';


class ShowMoreButton extends StatelessWidget {
  final Function callback;
  final bool isExpanded;
  const ShowMoreButton(
      {Key key, @required this.isExpanded, @required this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only( left: 20, right: 20),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Divider(),
          SizedBox.fromSize(
             // button width and height
            child: ClipOval(
              child: Material(
                color: AppTheme.white, // button color
                child: InkWell(
                  onTap: () {
                    callback();
                  }, // button pressed
                  child: isExpanded
                      ? Icon(
                          Icons.keyboard_arrow_up,
                          size: 20,
                          color: AppTheme.nearlyDarkBlue,
                        )
                      : Icon(Icons.keyboard_arrow_down,
                          size: 20, color: AppTheme.nearlyDarkBlue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
