import 'package:flutter/material.dart';
import 'package:healthy_me/Screens/factsScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const baseurl = "https://healthy-me-sever.herokuapp.com";

class BMIScreen extends StatefulWidget {
  @override
  _BMIScreenState createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();

  bool isButtonDiasbled = false;
  bool fetchingData = false;
  Widget loadingWidget() {
    if (fetchingData == false) {
      return SizedBox(
        height: 0,
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Loading',
            style: TextStyle(
              fontSize: 15.0,
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          SpinKitWave(
            color: Colors.tealAccent,
            size: 15.0,
          ),
        ],
      );
    }
  }

  String bmi = "Your BMI";
  String bmiStatus = "Your BMI status";
  String bmiImage = "overweight.png";

  void calculateBMI() {
    int height = int.parse(myController1.text);
    int weight = int.parse(myController2.text);
    double BMI = weight / ((height / 100) * (height / 100));
    bmi = BMI.toStringAsFixed(1);
    // bmi = BMI.toString();
    if (BMI < 18.5) {
      bmiStatus = "You are under weight!";
      bmiImage = "underweight.png";
    } else if (BMI >= 18.5 && BMI < 25) {
      bmiStatus = "Your BMI is normal";
      bmiImage = "normalweight.png";
    } else {
      bmiStatus = "You are over weight";
      bmiImage = "overweight.png";
    }
  }

  @override
  void dispose() {
    myController1.dispose();
    myController2.dispose();
    super.dispose();
  }

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
                TextField(
                  controller: myController1,
                  textAlign: TextAlign.center,
                  decoration:
                      InputDecoration(labelText: 'Enter your Height in cms'),
                ),
                SizedBox(
                  height: 40.0,
                ),
                TextField(
                    controller: myController2,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Enter your Weight in kgs',
                    )),
                SizedBox(height: 10.0),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      calculateBMI();
                    });
                  },
                  child: Text('Calculate'),
                  color: Colors.teal[300],
                ),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(height: 10.0),
                Text(
                  '$bmi',
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
                Text(
                  '$bmiStatus',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    // color: Colors.yellowAccent,
                  ),
                ),
                Image(
                    image: AssetImage(
                      'assets/$bmiImage',
                    ),
                    width: 150.0,
                    height: 150.0),
                SizedBox(
                  height: 10.0,
                ),
                OutlineButton(
                  highlightedBorderColor: Colors.tealAccent,
                  onPressed: isButtonDiasbled
                      ? null
                      : () async {
                          var url = '$baseurl/api/weightLoss/BMI';
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
                                        "Please check your internet connection. If it still doesn't works then there's probably a problem with the server"),
                              ),
                            );
                          }
                        },
                  child: Text(
                    'What is BMI? How is this helpful?',
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent,
                    ),
                  ),
                ),
                loadingWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
