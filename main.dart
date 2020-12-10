import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Water Watcher',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double sodaCount = 0;
  double waterCount = 0;
  int today = DateTime.now().day;

  @override
  void initState() {
    getValues();
  }

  void getValues() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      double water = prefs.getDouble('water');
      double soda = prefs.getDouble('soda');
      int date = prefs.getInt('date');

      if (date == today) {
        setState(() {
          today = date;
          waterCount = water;
          sodaCount = soda;
        });
      } else {
        print("Different Day");
        return;
      }
    } catch (e) {
      print("no data");
      return;
    }
  }

  void setLocal() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('water', waterCount);
      prefs.setDouble('soda', sodaCount);
      prefs.setInt('date', today);
      print("Success");
      return;
    } catch (e) {
      print(e.toString);
      return;
    }
  }

  Color getColor(type) {
    if (type > 0) {
      return Color(0xffff4d4d);
    } else if (type < 0) {
      return Colors.greenAccent;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Water Watchers"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          sodaCount = sodaCount + 1;
                          waterCount = waterCount + 2;
                        });
                        setLocal();
                      },
                      child: Image.asset(
                        'assets/soda.png',
                        height: 200,
                      ),
                    ),
                    Text(
                      sodaCount.toString(),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: getColor(sodaCount),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          waterCount = waterCount - 1;
                          sodaCount = sodaCount - 0.5;
                        });
                        setLocal();
                      },
                      child: Image.asset(
                        'assets/water.png',
                        height: 200,
                      ),
                    ),
                    Text(
                      waterCount.toString(),
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: getColor(waterCount),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
