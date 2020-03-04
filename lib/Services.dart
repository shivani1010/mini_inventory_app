import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart'
    as http; // add the http plugin in pubspec.yaml file.
import 'package:http/http.dart';
import 'ModelData.dart';
import 'Manufacturer.dart';

class Services {
  // add your local ip or server url
  static const ROOT =
      'http://192.168.1.100/mini_inventory_management/mini_inventory_apis/public/';

  static const _ADD_MANUFACTURERE = ROOT + 'add_manufacturer';
  static const _ADD_MODEL = ROOT + 'add_model';
  static const _VIEW_MANUFACTURER = ROOT + 'manufacturer_lists';
  static const _VIEW_MODELS = ROOT + 'model_lists';
  static const _DELETE_MODEL = ROOT + 'delete_model';

  // Method to add Manufacturer.
  static Future<String> addManufacturer(String manufacturerName) async {
    try {
      // add the parameters to pass to the request.
      var map = Map<String, dynamic>();
      map['manufacturer_name'] = manufacturerName;
      final response = await http.post(_ADD_MANUFACTURERE, body: map);
      print('Add manufacturer Response: ${response.body}');
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (200 == response.statusCode) {
        return responseData['message'];
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }

  // Method to add Inventory.
  static Future<String> addModel(
      String modelName,
      String modelColor,
      String modelManufacturerYear,
      String manufacturerId,
      String registrationNumber,
      String note) async {
    try {
      // add the parameters to pass to the request.
      var map = Map<String, dynamic>();
      map['model_name'] = modelName;
      map['model_color'] = modelColor;
      map['model_manufacturer_year'] = modelManufacturerYear;
      map['manufacturer_id'] = manufacturerId;
      map['note'] = note;
      map['registration_number'] = registrationNumber;
      final response = await http.post(_ADD_MODEL, body: map);
      print('Add Model Response: ${response.body}');
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (200 == response.statusCode) {
        String msg = responseData['message'];
        if (msg.contains("Model added successfully")) {
          return responseData['model_id'];
        } else {
          return responseData['message'];
        }
      } else {
        return "error";
      }
    } catch (e) {
      return "error";
    }
  }
// fetch Inventory from Database
  static Future<List<ModelData>> getModels() async {
    try {
      final response = await http.get(_VIEW_MODELS);
      print('get models Response: ${response.body}');
      if (200 == response.statusCode) {
        List<ModelData> list = parseResponse(response.body);
        return list;
      } else {
        return List<ModelData>();
      }
    } catch (e) {
      print(e.toString());
      return List<ModelData>(); // return an empty list on exception/error
    }
  }
//parse json response
  static List<ModelData> parseResponse(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<ModelData>((json) => ModelData.fromJson(json)).toList();
  }

  //fetch manufacturer from db
  static Future<List<Manufacturer>> getManufacturers() async {
    try {
      final response = await http.get(_VIEW_MANUFACTURER);
      print('get manufacturer Response: ${response.body}');
      if (200 == response.statusCode) {
        List<Manufacturer> list = parseResponseManufacturer(response.body);
        return list;
      } else {
        return List<Manufacturer>();
      }
    } catch (e) {
      print(e.toString());
      return List<Manufacturer>(); // return an empty list on exception/error
    }
  }

  //parse manufacturer response
  static List<Manufacturer> parseResponseManufacturer(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<Manufacturer>((json) => Manufacturer.fromJson(json))
        .toList();
  }

  //upload model images
  static Future<String> uploadModelImages(List images, String modelId) async {
    var uri = Uri.parse("");
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.headers[''] = '';
    request.fields['model_id'] = modelId;

    //multipartFile = new http.MultipartFile("imagefile", stream, length, filename: basename(imageFile.path));
    List<MultipartFile> newList = new List<MultipartFile>();
    for (int i = 0; i < images.length; i++) {
      File imageFile = File(images[i].toString());
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var multipartFile = new http.MultipartFile("modelimages", stream, length,
          filename: imageFile.path);
      newList.add(multipartFile);
    }
    request.files.addAll(newList);
    var response = await request.send();
    if (response.statusCode == 200) {
      return "Image Uploaded";
    } else {
      return "Upload Failed";
    }

  }

  // Method to Delete an Inventory...
  static Future<String> deleteModel(String modelId) async {
    try {
      var map = Map<String, dynamic>();
      map['model_id'] = modelId;
      final response = await http.post(_DELETE_MODEL, body: map);
      print('delete Model Response: ${response.body}');
      Map<String, dynamic> responseData = jsonDecode(response.body);
      if (200 == response.statusCode) {
        return responseData['message'];
      } else {
        return "error";
      }
    } catch (e) {
      return "error"; // returning just an "error" string to keep this simple...
    }
  }
}
