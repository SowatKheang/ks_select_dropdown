
///
/// [KSDropDownModel]
///
class KSDropDownModel {

  int? id;
  String? uuid;
  String? name; // name in local language
  String? nameEn; // nameEN in English

  KSDropDownModel({
    this.id,
    this.uuid,
    this.name,
    this.nameEn
  });

  factory KSDropDownModel.fromJson(Map<String, dynamic> json) => KSDropDownModel(
    id: json["id"],
    uuid: json["uuid"],
    name: json["name"],
    nameEn: json["nameEn"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uuid": uuid,
    "name": name,
    "nameEn": nameEn,
  };

  @override
  bool operator == (Object other) {
    return other is KSDropDownModel && id == other.id && name == other.name; 
  }

  @override
  int get hashCode => id.hashCode;

}
