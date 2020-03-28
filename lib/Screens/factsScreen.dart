import 'package:flutter/material.dart';

class FactsScreen extends StatelessWidget {
  final String title;
  final String description;
  const FactsScreen({Key key, @required this.title, this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$title',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      '$description',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontSize: 20.0,
                        letterSpacing: 1.0,
                        // fontWeight: FontWeight.bold,
                        // color: Colors.yellowAccent,
                        
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
