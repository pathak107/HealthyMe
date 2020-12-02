import 'package:flutter/material.dart';
import 'package:healthy_me/Screens/factsScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const baseurl = "https://healthy-me-sever.herokuapp.com";

class DietPlanScreen extends StatefulWidget {
  final List<String> titles;
  const DietPlanScreen({Key key, @required this.titles}) : super(key: key);

  @override
  _DietPlanScreenState createState() => _DietPlanScreenState();
}

class _DietPlanScreenState extends State<DietPlanScreen> {
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
                  'Weight Loss Concepts',
                  textAlign: TextAlign.center,
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
                  child: ListView.builder(
                      itemCount: widget.titles.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return new MyCard(title: widget.titles[Index]);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyCard extends StatefulWidget {
  final String title;
  MyCard({this.title});

  @override
  _MyCardState createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  bool isButtonDiasbled = false;
  bool fetchingData = false;
  Widget loadingWidget() {
    if (fetchingData == false) {
      return Text(
        widget.title,
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Row(
        children: <Widget>[
          Text(
            'Loading',
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          SpinKitWave(
            color: Colors.tealAccent,
            size: 20.0,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FlatButton(
        onPressed: isButtonDiasbled
            ? null
            : () async {
                var url = '$baseurl/api/weightLoss/${widget.title}';
                try {
                  setState(() {
                    fetchingData = true;
                    isButtonDiasbled = true;
                  });
                  var response = await http.get(url);
                  setState(() {
                    fetchingData = false;
                    isButtonDiasbled = false;
                  });
                  print('Response status: ${response.statusCode}');
                  if (response.statusCode == 200) {
                    var plan = json.decode(response.body);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FactsScreen(
                          title: plan['title'],
                          description: plan['description'],
                        ),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FactsScreen(
                            title: 'Network Error',
                            description:
                                "Please check your internet connection. If it still doesn't works then there's probably a problem with the server"),
                      ),
                    );
                  }
                } catch (e) {
                  print('Error $e');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FactsScreen(
                        title: 'Network Error',
                        description:
                            "Please check your internet connection. If it still doesn't works then there's probably a problem with the server",
                      ),
                    ),
                  );
                }
              },
        child: ListTile(
          title: loadingWidget(),
          leading: Image(
              image: AssetImage(
                'assets/dietplan.png',
              ),
              width: 30.0,
              height: 34),
        ),
      ),
    );
  }
}
