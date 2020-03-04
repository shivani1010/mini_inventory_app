import 'package:flutter/material.dart';
import 'AddModelScreen.dart';
import 'ViewManufacturerScreen.dart';
import 'ViewModelsScreen.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mini Car Inventory System"),
        elevation: .1,
        backgroundColor: Color.fromRGBO(49, 87, 110, 1.0),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(3.0),
          children: <Widget>[
            makeDashboardItem("Add and View Manufacturer", Icons.business),
            makeDashboardItem("Add Inventory", Icons.directions_car),
            makeDashboardItem("View Inventory", Icons.directions_car)
          ],
        ),
      ),
    );
  }

  Card makeDashboardItem(String title, IconData icon) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
          child: new InkWell(
            onTap: () {
              if ("Add and View Manufacturer".contains(title)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewManufacturerScreen()),
                );
              } else if ("Add Inventory".contains(title)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddModelScreen()),
                );
              } else if ("View Inventory".contains(title)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewModelScreen()),
                );
              } else {
                print("Invalid");
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 50.0),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.black,
                )),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(
                    title,
                    style: new TextStyle(fontSize: 18.0, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
