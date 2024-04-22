
import '../enum/ks_dropdown_enum.dart';

///
/// [KSDropDownHelper]
///
class KSDropDownHelper {

  static bool isMultiSelect(KSDropDownEnum? ksDropDownEnum) {
    return ksDropDownEnum != null && ksDropDownEnum == KSDropDownEnum.multiple;
  }

  static bool isWrap(KSDropDownContentModeEnum? ksDropDownContentModeEnum) {
    return ksDropDownContentModeEnum != null && ksDropDownContentModeEnum == KSDropDownContentModeEnum.wrap;
  }
}