import 'package:flutter/material.dart';
import 'package:healthy_me/Screens/factsScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

const baseurl = "https://shrouded-cove-63929.herokuapp.com";

class TracMacrosScreen extends StatefulWidget {
  final List<String> foodList;

  TracMacrosScreen({Key key, @required this.foodList}) : super(key: key);

  @override
  _TracMacrosScreenState createState() => _TracMacrosScreenState();
}

class _TracMacrosScreenState extends State<TracMacrosScreen> {
  String dropdownValue = "Almonds";

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

  String description = "No item selected";
  String calories = '0';
  String protein = '0';
  String carbs = '0';
  String fiber = '0';
  String fat = '0';

  var dataMap = {
    "Carbs": 0.0,
    "Fat": 0.0,
    "Protein": 0.0,
    "Fiber": 0.0,
  };

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
                  'Select food from the list',
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
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
                  onChanged: isButtonDiasbled
                      ? null
                      : (String newValue) async {
                          try {
                            setState(() {
                              dropdownValue = newValue;
                              fetchingData = true;
                              isButtonDiasbled = true;
                            });
                            var url = '$baseurl/api/foodMacros/$dropdownValue';
                            var response = await http.get(url);
                            setState(() {
                              fetchingData = false;
                              isButtonDiasbled = false;
                            });
                            print('Response status: ${response.statusCode}');
                            if (response.statusCode == 200) {
                              var foodMacros = json.decode(response.body);
                              setState(() {
                                description = foodMacros["description"];
                                protein = foodMacros["protein"].toString();
                                dataMap['Protein'] =
                                    foodMacros["protein"].toDouble();
                                calories = foodMacros['calories'].toString();

                                carbs = foodMacros['carbs'].toString();
                                dataMap['Carbs'] =
                                    foodMacros["carbs"].toDouble();
                                fiber = foodMacros['fiber'].toString();
                                dataMap['Fiber'] =
                                    foodMacros["fiber"].toDouble();
                                fat = foodMacros['fat'].toString();
                                dataMap['Fat'] = foodMacros["fat"].toDouble();
                              });
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
                  items: widget.foodList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(
                  height: 20.0,
                ),
                loadingWidget(),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  '$description',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Nutritional Value per 100g',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    // color: Colors.yellowAccent,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Calories',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      '$calories',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        // color: Colors.yellowAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Protein',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      '$protein',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        // color: Colors.yellowAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Fats',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      '$fat',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        // color: Colors.yellowAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Carbohydrates',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      '$carbs',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        // color: Colors.yellowAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      'Fiber',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent,
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      '$fiber',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        // color: Colors.yellowAccent,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: PieChart(
                    dataMap: dataMap,
                    animationDuration: Duration(milliseconds: 2000),
                    chartLegendSpacing: 32.0,
                    chartRadius: MediaQuery.of(context).size.width / 3.7,
                    showChartValuesInPercentage: true,
                    showChartValues: true,
                    showChartValuesOutside: true,
                    chartValueBackgroundColor: Colors.grey[200],
                    showLegends: true,
                    legendPosition: LegendPosition.right,
                    decimalPlaces: 1,
                    showChartValueLabel: true,
                    initialAngle: 0,
                    chartValueStyle: defaultChartValueStyle.copyWith(
                      color: Colors.blueGrey[900].withOpacity(0.9),
                    ),
                    chartType: ChartType.disc,
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
