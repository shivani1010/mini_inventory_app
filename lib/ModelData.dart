class ModelData {
  String modelId;
  String modelName;
  String modelColor;
  String modelManufacturerYear;
  String manufacturerId;
  String count;
  String manufacturerName;

  ModelData({this.modelId,this.modelColor,this.manufacturerId,this.manufacturerName,this.modelManufacturerYear,this.modelName,this.count});

  factory ModelData.fromJson(Map<String,dynamic> json){
    return ModelData(
      modelId: json['model_id'] as String,
      modelName: json['model_name'] as String,
      modelColor: json['model_color'] as String ,
      modelManufacturerYear:json['model_manufacturer_year'] as String,
      manufacturerId: json['manufacturer_id'] as String,
      manufacturerName: json['manufacturer_name'] as String,
      count: json['count'] as String,
    );
  }
}