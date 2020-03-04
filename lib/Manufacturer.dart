class Manufacturer {
  String manufacturerId;
  String manufacturerName;


  Manufacturer({this.manufacturerId,this.manufacturerName});

  factory Manufacturer.fromJson(Map<String,dynamic> json){
    return Manufacturer(
      manufacturerId: json['manufacturer_id'] as String,
      manufacturerName: json['manufacturer_name'] as String,

    );
  }
}