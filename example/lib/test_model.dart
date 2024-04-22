
import 'package:ks_select_dropdown/models/ks_dropdown_model.dart';

///
/// [TestModel] extends [KSDropDownModel]
/// in case your [Model] has different field name like this example
/// the [TestModel] description = [KSDropDownModel] name, etc
///
class TestModel extends KSDropDownModel {

  String? description;
  String? descriptionEn;

  TestModel({
    id,
    this.description,
    this.descriptionEn
  }) : super(
    id: id,
    name: description,
    nameEn: descriptionEn,
  );

}