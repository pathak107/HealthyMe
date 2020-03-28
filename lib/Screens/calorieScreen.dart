import 'package:flutter/material.dart';
import 'package:healthy_me/Screens/factsScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';

const baseurl="https://shrouded-cove-63929.herokuapp.com";

enum Gender { Male, Female }

var activityLevel ={'Little to no Exercise':1.2, 'Light Exercise':1.375, 'Moderate Exercise':1.55, 'Heavy Exercise':1.725,'Very intense Exercise':1.9};

class CalorieScreen extends StatefulWidget {
  @override
  _CalorieScreenState createState() => _CalorieScreenState();
}

class _CalorieScreenState extends State<CalorieScreen> {
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  final ageController = TextEditingController();

  bool isButtonDiabled=false;
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
          SizedBox(width: 5.0,),
          SpinKitWave(
            color: Colors.tealAccent,
            size: 15.0,
          ),
        ],
      );
    }
  }


  Gender gender = Gender.Male;
  String dropdownValue = 'Little to no Exercise';
  String MaintainBMR = " 0 Calories";
  String MildLossBMR = " 0 Calories";
  String ExtremeLossBMR = " 0 Calories";

  void CalculateCalorie(){
    double bmr = 0;
    double A = double.parse(ageController.text);
    double W = double.parse(weightController.text);
    double H = double.parse(heightController.text);

    if(gender == Gender.Male) bmr = (13.397*W + 4.799*H - 5.677*A + 88.362)* activityLevel[dropdownValue];
    else bmr = (9.247*W + 3.098*H - 4.330*A + 447.593)* activityLevel[dropdownValue];

    MaintainBMR = bmr.toStringAsFixed(0);
    MildLossBMR =(bmr-500).toStringAsFixed(0);
    ExtremeLossBMR = (bmr-1000).toStringAsFixed(0);
    print(bmr);
  }




@override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    ageController.dispose();
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: heightController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(labelText: 'Height in cms'),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: TextField(
                        controller: weightController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(labelText: 'Weight in kgs'),
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: TextField(
                        controller: ageController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(labelText: 'Age(15-80)'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ListTile(
                        title: Text('Male'),
                        leading: Radio(
                          value: Gender.Male,
                          groupValue: gender,
                          onChanged: (Gender value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListTile(
                        title: Text('Female'),
                        leading: Radio(
                          value: Gender.Female,
                          groupValue: gender,
                          onChanged: (Gender value) {
                            setState(() {
                              gender = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 15,
                  elevation: 16,
                 
                  underline: Container(
                  
                    height: 2,
                    color: Colors.tealAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['Little to no Exercise', 'Light Exercise', 'Moderate Exercise', 'Heavy Exercise','Very intense Exercise']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

                RaisedButton(
                  onPressed: () {
                    setState(() {
                      CalculateCalorie();
                    });
                  },
                  child: Text('Calculate'),
                  color: Colors.teal[300],
                ),

                SizedBox(height: 20.0,),
                
                Text(
                  'Maintainence Calorie',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
                Text(
                  '$MaintainBMR',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    // color: Colors.yellowAccent,
                  ),
                ),
                SizedBox(height: 30.0,),
                Text(
                  'Mild weight loss',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
                Text(
                  '$MildLossBMR',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    // color: Colors.yellowAccent,
                  ),
                ),
                SizedBox(height: 30.0,),
                Text(
                  'Extreme weight loss',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
                Text(
                  '$ExtremeLossBMR',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    // color: Colors.yellowAccent,
                  ),
                ),
                SizedBox(height: 30.0,),
                OutlineButton(
                  highlightedBorderColor: Colors.tealAccent,
                  onPressed: isButtonDiabled ? null: () async{
                    var url = '$baseurl/api/weightLoss/Calorie%20Counting';
                    try {
                      setState(() {
                        isButtonDiabled = true;
                        fetchingData = true;
                      });
                      var response = await http.get(url);
                      setState(() {
                        isButtonDiabled=false;
                        fetchingData = false;
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
                    
                    'How weight loss occurs? How the counter works?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent,
                      // color: Colors.tealAccent,
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
