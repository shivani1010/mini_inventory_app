import 'package:flutter/material.dart';
import 'Manufacturer.dart';
import 'Services.dart';

class ViewManufacturerScreen extends StatefulWidget {

  ViewManufacturerScreen() : super();
  final String title = 'Add and View Manufacturers';

  @override
  ViewManufacturerScreenState createState() => ViewManufacturerScreenState();
}

class ViewManufacturerScreenState extends State<ViewManufacturerScreen> {
  List<Manufacturer> _manufacturers;

  GlobalKey<ScaffoldState> _scaffoldKey;
  // controller for the Manufacturer Name TextField we are going to create.
  TextEditingController _manufacturerNameController;

  String _titleProgress;

  @override
  void initState() {
    super.initState();
    _manufacturers = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _manufacturerNameController = TextEditingController();

    _getManufacturers();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }



  // Now lets add an manufacturer
  _addManufacturer() {
    if (_manufacturerNameController.text.isEmpty) {
      print('Empty Fields');
      return;
    }
    _showProgress('Adding Manufacturer...');
    Services.addManufacturer(_manufacturerNameController.text).then((result) {
      if ('Manufacturer added successfully' == result) {
        _getManufacturers(); // Refresh the List after adding each employee...
        _clearValues();
      }
    });
  }

  _getManufacturers() {
    _showProgress('Loading Manufacturer...');
    Services.getManufacturers().then((manufacturers) {
      setState(() {
        _manufacturers = manufacturers;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${manufacturers.length}");
    });
  }

  // Method to clear TextField values
  _clearValues() {
    _manufacturerNameController.text = '';
  }

  _showValues(Manufacturer manufacturer) {
    _manufacturerNameController.text = manufacturer.manufacturerName;
  }

  // Let's create a DataTable and show the manufacture list in it.
  SingleChildScrollView _dataBody() {
    // Both Vertical and Horizontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('MANUFACTURER_ID'),
            ),
            DataColumn(
              label: Text('MANUFACTURER NAME'),
            )
          ],
          rows: _manufacturers
              .map(
                (manufacturer) => DataRow(cells: [
                  DataCell(
                    Text(manufacturer.manufacturerId),
                  ),
                  DataCell(
                    Text(
                      manufacturer.manufacturerName,
                    ),
                  )
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), // we show the progress in the title...
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _manufacturerNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Manufacturer Name',
                ),
              ),
            ),

            // Add an save button and a Cancel Button

            Row(
              children: <Widget>[
                OutlineButton(
                  child: Text('SAVE'),
                  onPressed: () {
                    _addManufacturer();
                  },
                ),
                OutlineButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    setState(() {});
                    _clearValues();
                  },
                ),
              ],
            ),
            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
    );
  }
}
