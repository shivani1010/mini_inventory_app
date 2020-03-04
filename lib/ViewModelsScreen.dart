import 'package:flutter/material.dart';
import 'ModelData.dart';
import 'Services.dart';

class ViewModelScreen extends StatefulWidget {
  ViewModelScreen() : super();

  final String title = 'Inventory Lists';

  @override
  ViewModelScreenState createState() => ViewModelScreenState();
}

class ViewModelScreenState extends State<ViewModelScreen> {
  List<ModelData> _models;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;

  @override
  void initState() {
    super.initState();
    _models = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getModels();
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _getModels() {
    _showProgress('Loading Models...');
    Services.getModels().then((models) {
      setState(() {
        _models = models;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${models.length}");
    });
  }

  _deleteModel(ModelData modelData) {
    _showProgress('Deleting Model...');
    Services.deleteModel(modelData.modelId).then((result) {
      if ('Model sold successfully' == result) {
        _getModels(); // Refresh after delete...
      }
    });
  }

  // Let's create a DataTable and show the model list in it.
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
              label: Text('SR.No'),
            ),
            DataColumn(
              label: Text('MANUFACTURER NAME'),
            ),
            DataColumn(
              label: Text('MODEL NAME'),
            ),
          ],
          rows: _models
              .map(
                (model) => DataRow(cells: [
                  DataCell(
                    Text(model.modelId),
                    // Add tap in the row to display details
                    onTap: () {
                      showAlertDialog(context, model);
                    },
                  ),
                  DataCell(
                    Text(
                      model.manufacturerName.toUpperCase(),
                    ),
                    onTap: () {
                      showAlertDialog(context, model);
                    },
                  ),
                  DataCell(
                    Text(
                      model.modelName.toUpperCase() +
                          "( " +
                          model.count.toString() +
                          " )",
                    ),
                    onTap: () {
                      showAlertDialog(context, model);
                    },
                  ),
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

            Expanded(
              child: _dataBody(),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, ModelData model) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Sold"),
      onPressed: () {
        Navigator.pop(context);
        _deleteModel(model);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Model Details"),
      content: Text("Model Name : " +
          model.modelName +
          "\nColor : " +
          model.modelColor +
          "\nManufacturer : " +
          model.manufacturerName +
          "\nManufacturer Year : " +
          model.modelManufacturerYear +
          "\nRegistration Number : " +
          model.modelColor),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
