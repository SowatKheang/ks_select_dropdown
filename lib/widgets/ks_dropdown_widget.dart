
import 'package:flutter/material.dart';
import 'package:fluttericon/elusive_icons.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:fluttericon/iconic_icons.dart';
import 'package:fluttericon/octicons_icons.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../helpers/ks_dropdown_device_helper.dart';
import '../ks_select_dropdown.dart';

///
/// [KSSelectDropDownWidget]
///
class KSSelectDropDownWidget<T extends KSDropDownModel> extends StatefulWidget {

  /// [items] dropdown contents
  final List<T> items;

  /// [selectedItems] the value after selection
  final List<T> selectedItems;

  /// [getSelectedItem] method to select dropdown value
  final Function(List<T>) getSelectedItem;

  /// [displayContentItem] you can display dropdown item based on your localize method
  /// by default, it displays name attribute of this class [KSDropDownModel]
  final Function(T)? displayContentItem;

  /// [ksDropDownEnum] to set up single or multiple choice
  /// by default, it displays single choice
  /// to set up multiple choice, you may set [KSDropDownEnum.multiple]
  final KSDropDownEnum? ksDropDownEnum;

  /// [ksDropDownContentModeEnum] to set up dropdown content to either list view or wrap view
  /// by default, it displays list view
  /// to set up wrap view, you may set [KSDropDownContentModeEnum.wrap]
  final KSDropDownContentModeEnum? ksDropDownContentModeEnum;

  final String? label;
  final String? dropdownTitle;
  final double? dropdownHeight;
  final bool? showSearch;

  const KSSelectDropDownWidget(
    {
      Key? key, 
      required this.items,
      required this.selectedItems,
      required this.getSelectedItem,
      this.label,
      this.dropdownTitle = '',
      this.displayContentItem,
      this.ksDropDownEnum = KSDropDownEnum.single,
      this.ksDropDownContentModeEnum = KSDropDownContentModeEnum.list,
      this.showSearch = false,
      this.dropdownHeight,
    }) : super(key: key);

  @override
  State<KSSelectDropDownWidget<T>> createState() => _KSSelectDropDownWidgetState<T>();
}

class _KSSelectDropDownWidgetState<T extends KSDropDownModel> extends State<KSSelectDropDownWidget<T>> {

  List<T> _selectedItems = [];

  List<T> _items = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) { 
      setState(() {
        _selectedItems = widget.selectedItems;
        _items = widget.items;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  ///
  void _showBottomSheet() {
    _items = widget.items;
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      builder: (context) {
        return _dropdownBottonSheet(context);
      }
    );
  }

  ///
  void _selectAll() {
    setState(() {
      if (_selectedItems.length == widget.items.length) {
        _selectedItems.clear();
      } else {
        _selectedItems.clear();
        _selectedItems.addAll(widget.items);
      }
      widget.getSelectedItem(_selectedItems);
      if (!KSDropDownHelper.isMultiSelect(widget.ksDropDownEnum)) {
        Navigator.pop(context);
      }
    });
  }

  ///
  void _selectItem(T item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        if (KSDropDownHelper.isMultiSelect(widget.ksDropDownEnum)) {
          _selectedItems.add(item);
        } else {
          _selectedItems = [item];
        }
      }
      widget.getSelectedItem(_selectedItems);
      if (!KSDropDownHelper.isMultiSelect(widget.ksDropDownEnum)) {
        Navigator.pop(context);
      }
    });
  }

  ///
  String getDisplayName({required BuildContext context, String? name, String? nameEn}) {
    String str = name ?? nameEn ?? '';
    // String strEn = nameEn ?? name ?? '';
    // TODO: return localize item
    return str;
    // return I18NTranslations.of(context).textLocale(str, strEn);
  }
  
  @override
  Widget build(BuildContext context) {

    return ResponsiveSizer(
      builder: (context, orientaion, screenType) {
        KSDropDownDeviceHelper.getInstance().setScreenType(screenType);
        KSDropDownDeviceHelper.getInstance().setOrientation(orientaion);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => _showBottomSheet(),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _selectedItems.isEmpty ? Text(widget.label!) : _selectContent(),
                    const SizedBox(width: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Octicons.triangle_down, 
                        color: KSDropDownColorHelper.blue800,
                        size: 24.px,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // TODO add validation
            // Visibility(
            //   visible: !widget.isValidate!,
            //   child: Padding(
            //     padding: const EdgeInsets.only(top: 8, left: 8),
            //     child: Text(I18NTranslations.of(context).text(widget.validateText ?? ''), style: const TextStyle(color: ColorHelper.RED)),
            //   )
            // ),
          ],
        );
      },
    );
  } 

  ///
  /// Show Selected Conetent
  ///
  Widget _selectContent() {
    if (!KSDropDownHelper.isMultiSelect(widget.ksDropDownEnum)) {
      return Text(
        widget.displayContentItem != null ? widget.displayContentItem!(_selectedItems[0]) : getDisplayName(context: context, name: _selectedItems[0].name, nameEn: _selectedItems[0].nameEn),
        style: const TextStyle(letterSpacing: .8)
      );
    }

    _selectedItems.sort((a, b) => a.id!.compareTo(b.id!));

    return Flexible(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _selectedItems.map((selectedItem) => Material(
          color: const Color.fromARGB(255, 242, 213, 185),
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedItems.remove(selectedItem);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 8),
                  Text(
                    widget.displayContentItem != null ? widget.displayContentItem!(selectedItem) : getDisplayName(context: context, name: selectedItem.name, nameEn: selectedItem.nameEn),
                    style: const TextStyle(
                      color: KSDropDownColorHelper.black, 
                      letterSpacing: .8
                    )
                  ),
                  const SizedBox(width: 14),
                  const Icon(Entypo.cancel, color: KSDropDownColorHelper.black),
                  const SizedBox(width: 2),
                ],
              ),
            ),
          ),
        )).toList()
      ),
    );
  }

  ///
  /// Serach Field
  ///
  Widget _searchField(stateSetter) {
    if (!widget.showSearch!) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                enabled: true,
                fillColor: KSDropDownColorHelper.white,
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: KSDropDownColorHelper.grey350),
                  borderRadius: BorderRadius.all(Radius.circular(99))
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: KSDropDownColorHelper.grey350),
                  borderRadius: BorderRadius.all(Radius.circular(99))
                ),
                hintText: 'Search here ...',
                prefixIcon: const Icon(FontAwesome5.search_location, color: KSDropDownColorHelper.red),
                suffixIcon: Visibility(
                  visible: _searchController.text != '',
                  child: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      stateSetter(() {
                        _items = widget.items;
                      });
                    }, 
                    icon: const Icon(Icons.clear, color: KSDropDownColorHelper.grey400)
                  ),
                )
              ),
              onChanged: (text) {
                _searchController..text = text..selection = TextSelection.collapsed(offset: text.length);
                stateSetter(() {
                  if (text.isNotEmpty) {
                    _items = _items.where((element) {
                      String name ='';
                      String nameEn = '';
                      if (element.name != null) {
                        name = element.name!;
                      }
                      if (element.nameEn != null) {
                        nameEn = element.nameEn!;
                      }
                      return (name.trim().toLowerCase().contains(text.trim().toLowerCase())) || (nameEn.trim().toLowerCase().contains(text.trim().toLowerCase()));
                    }).toList();
                  } else {
                    _items = widget.items;
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }

  ///
  /// DropDown Content
  ///
  Widget _dropdownBottonSheet(BuildContext context) => StatefulBuilder(
    builder: (context, stateSetter) => ResponsiveSizer(
      builder: (context, orientaion, screenType) {
        KSDropDownDeviceHelper.getInstance().setScreenType(screenType);
        KSDropDownDeviceHelper.getInstance().setOrientation(orientaion);

        return SizedBox(
          height: 90.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100.w,
                padding: EdgeInsets.all(16.sp),
                alignment: Alignment.centerRight,
                decoration: const BoxDecoration(
                  color: KSDropDownColorHelper.blue700,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        KSDropDownHelper.isMultiSelect(widget.ksDropDownEnum)
                        ? InkWell(
                          onTap: () {
                            _selectAll();
                            stateSetter(() {});
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(_selectedItems.length == widget.items.length ? Icons.check_box : Icons.check_box_outline_blank,
                                  color: KSDropDownColorHelper.white,
                                  size: 32,
                                ),
                              ),
                              Text('${widget.dropdownTitle}', style: const TextStyle(fontSize: 18, color: KSDropDownColorHelper.white, fontWeight: FontWeight.w500))
                            ],
                          ),
                        )
                        : Text('${widget.dropdownTitle}', style: const TextStyle(fontSize: 18, color: KSDropDownColorHelper.white, fontWeight: FontWeight.w500))
                      ],
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Iconic.cancel_circle, size: 32, color: KSDropDownColorHelper.darkRed),
                    ),
                  ],
                ),
              ),
              _searchField(stateSetter),
              Expanded(
                child: KSDropDownHelper.isWrap(widget.ksDropDownContentModeEnum) ? _dropdownContenWrapMode(stateSetter) : _dropdownContentListViewMode(stateSetter)
              ),
            ],
          ),
        );
      },
    ),
  );


  ///
  ///
  ///
  Widget _dropdownContentListViewMode(stateSetter) {
    return Container(
      width: 100.w,
      color: KSDropDownColorHelper.grey100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _items.map((item) {
            return InkWell(
              onTap: () {
                _selectItem(item);
                stateSetter(() {});
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: _selectedItems.contains(item) ? KSDropDownColorHelper.lightBlue100 : KSDropDownColorHelper.white,
                  border: Border.all(
                    color: _selectedItems.contains(item) ? KSDropDownColorHelper.blue800 : KSDropDownColorHelper.grey300,
                  ),
                  borderRadius: BorderRadius.circular(8.px),
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          _selectedItems.contains(item) 
                          ? KSDropDownHelper.isMultiSelect(widget.ksDropDownEnum) ? Elusive.check : Elusive.ok_circled
                          : KSDropDownHelper.isMultiSelect(widget.ksDropDownEnum) ? FontAwesome.check_empty : FontAwesome.circle_empty,
                          color: _selectedItems.contains(item) ? KSDropDownColorHelper.blue800 : KSDropDownColorHelper.black,
                          size: 20.px,
                        ),
                      ),
                      const WidgetSpan(child: SizedBox(width: 12)),
                      TextSpan(
                        text: widget.displayContentItem != null ? widget.displayContentItem!(item) : getDisplayName(context: context, name: item.name, nameEn: item.nameEn), 
                        style: TextStyle(
                          fontSize: 18.px,
                          color: _selectedItems.contains(item) ? KSDropDownColorHelper.blue800 : KSDropDownColorHelper.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  ///
  ///
  ///
  Widget _dropdownContenWrapMode(stateSetter) {
    return Container(
      width: 100.w,
      color: KSDropDownColorHelper.grey100,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          spacing: 8.px,
          runSpacing: 8.px,
          children: _items.map((item) {
            return InkWell(
              onTap: () {
                _selectItem(item);
                stateSetter(() {});
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 32.px, vertical: 16.px),
                decoration: BoxDecoration(
                  color: _selectedItems.contains(item) ? KSDropDownColorHelper.lightBlue100 : KSDropDownColorHelper.white,
                  border: Border.all(
                    color: _selectedItems.contains(item) ? KSDropDownColorHelper.blue800 : KSDropDownColorHelper.grey300,
                  ),
                  borderRadius: BorderRadius.circular(8.px),
                ),
                child: Text(
                  widget.displayContentItem != null ? widget.displayContentItem!(item) : getDisplayName(context: context, name: item.name, nameEn: item.nameEn), 
                  style: TextStyle(
                    color: _selectedItems.contains(item) ? KSDropDownColorHelper.blue800 : KSDropDownColorHelper.black,
                    fontSize: 16.px
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

}