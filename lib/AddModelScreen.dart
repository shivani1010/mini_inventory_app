import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mini_inventory_app/ImageUploadModel.dart';
import 'Manufacturer.dart';
import 'Services.dart';
import 'dart:io';
import 'ViewModelsScreen.dart';

class _AddModelData {
  String modelName = '';
  String modelColor = '';
  String manufactureYear = '';
  String regNumber = '';
  String note = '';
}

class AddModelScreen extends StatefulWidget {
  //
  AddModelScreen() : super();

  final String title = 'Add Inventory';

  @override
  AddModelScreenState createState() => AddModelScreenState();
}

class AddModelScreenState extends State<AddModelScreen> {
  List<Manufacturer> _manufacturers;
  GlobalKey<ScaffoldState> _scaffoldKey;
  String _titleProgress;
  List<DropdownMenuItem<Manufacturer>> _dropdownMenuItems;
  Manufacturer _selectedCompany;
  _AddModelData _data = new _AddModelData();

  List<Object> images = List<Object>();
  Future<File> _imageFile;

  @override
  void initState() {
    super.initState();
    _manufacturers = [];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey(); // key to get the context to show a SnackBar
    _getManufacturers();
    setState(() {
      images.add("Add Image");
      images.add("Add Image");
    });
  }

  List<DropdownMenuItem<Manufacturer>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Manufacturer>> items = List();
    for (Manufacturer company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.manufacturerName),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Manufacturer selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

  _getManufacturers() {
    _showProgress('Loading Manufacturer...');
    Services.getManufacturers().then((manufacturers) {
      setState(() {
        _manufacturers = manufacturers;
        _dropdownMenuItems = buildDropdownMenuItems(_manufacturers);
        _selectedCompany = _dropdownMenuItems[0].value;
      });
      _showProgress(widget.title); // Reset the title...
      print("Length ${manufacturers.length}");
    });
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }



  // Now lets add an Inventory
  _addModels() {
    _showProgress('Adding Model...');
    Services.addModel(_data.modelName, _data.modelColor, _data.manufactureYear,
            _selectedCompany.manufacturerId, _data.regNumber, _data.note)
        .then((result) {
      if ('Error in adding model' != result) {
        //_uploadImages(result);
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewModelScreen()),
        );
      }
    });
  }

  _uploadImages(String modelId) {
    _showProgress('Adding Model...');
    Services.uploadModelImages(images, modelId).then((result) {});
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String _modelNameValidate(String value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    if (value.isEmpty) {
      print('Empty Fields');
      return "Field cannot be blank";
    }

    return null;
  }

  String _modelColorValidate(String value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    if (value.isEmpty) {
      print('Empty Fields');
      return "Field cannot be blank";
    }

    return null;
  }

  String _manufacturerYearValidate(String value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    if (value.isEmpty) {
      print('Empty Fields');
      return "Field cannot be blank";
    }

    return null;
  }

  String _noteValidate(String value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    if (value.isEmpty) {
      print('Empty Fields');
      return "Field cannot be blank";
    }

    return null;
  }

  String _regNumberValidate(String value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    if (value.isEmpty) {
      print('Empty Fields');
      return "Field cannot be blank";
    }

    return null;
  }

  void submit() {
    // First validate form.
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save(); // Save our form now.
      _addModels();
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Container(
          padding: new EdgeInsets.all(20.0),
          child: new Form(
            key: this._formKey,
            child: new ListView(
              children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                    child: new TextFormField(
                        keyboardType: TextInputType
                            .text, // Use email input type for emails.
                        decoration: new InputDecoration(
                            hintText: 'Enter Model Name',
                            labelText: 'Model Name'),
                        validator: this._modelNameValidate,
                        onSaved: (String value) {
                          this._data.modelName = value;
                        }),
                  ),
                  Expanded(
                    child: new DropdownButton(
                      value: _selectedCompany,
                      items: _dropdownMenuItems,
                      onChanged: onChangeDropdownItem,
                    ),
                  ),
                ]),
                new TextFormField(
                    keyboardType:
                        TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'Enter Color', labelText: 'Color'),
                    validator: this._modelColorValidate,
                    onSaved: (String value) {
                      this._data.modelColor = value;
                    }),
                new TextFormField(
                    keyboardType: TextInputType
                        .number, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'Enter Manufacturer Year',
                        labelText: 'Manufacturer Year'),
                    validator: this._manufacturerYearValidate,
                    onSaved: (String value) {
                      this._data.manufactureYear = value;
                    }),
                new TextFormField(
                    keyboardType:
                        TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'Enter Registration Number',
                        labelText: 'Registration Number'),
                    validator: this._regNumberValidate,
                    onSaved: (String value) {
                      this._data.regNumber = value;
                    }),
                new TextFormField(
                    keyboardType:
                        TextInputType.text, // Use email input type for emails.
                    decoration: new InputDecoration(
                        hintText: 'Enter Note', labelText: 'Note'),
                    validator: this._noteValidate,
                    onSaved: (String value) {
                      this._data.note = value;
                    }),
                Row(children: <Widget>[
                  Expanded(
                    child: buildGridView(),
                  ),
                ]),
                new Container(
                  width: screenSize.width,
                  child: new RaisedButton(
                    child: new Text(
                      'Submit',
                      style: new TextStyle(color: Colors.white),
                    ),
                    onPressed: this.submit,
                    color: Colors.blue,
                  ),
                  margin: new EdgeInsets.only(top: 20.0),
                )
              ],
            ),
          )),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(images.length, (index) {
        if (images[index] is ImageUploadModel) {
          ImageUploadModel uploadModel = images[index];
          return Card(
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: <Widget>[
                Image.file(
                  uploadModel.imageFile,
                  width: 300,
                  height: 300,
                ),
                Positioned(
                  right: 5,
                  top: 5,
                  child: InkWell(
                    child: Icon(
                      Icons.remove_circle,
                      size: 20,
                      color: Colors.red,
                    ),
                    onTap: () {
                      setState(() {
                        images.replaceRange(index, index + 1, ['Add Image']);
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Card(
            child: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _onAddImageClick(index);
              },
            ),
          );
        }
      }),
    );
  }

  Future _onAddImageClick(int index) async {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
      getFileImage(index);
    });
  }

  void getFileImage(int index) async {
//    var dir = await path_provider.getTemporaryDirectory();

    _imageFile.then((file) async {
      setState(() {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = file;
        imageUpload.imageUrl = '';
        images.replaceRange(index, index + 1, [imageUpload]);
      });
    });
  }
}
