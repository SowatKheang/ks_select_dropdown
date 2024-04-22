
import 'package:flutter/material.dart';
import 'package:ks_select_dropdown/ks_select_dropdown.dart';
import 'test_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KS Select DropDown Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'KS Select DropDown Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<TestModel> _dropdownItems = [];

  List<TestModel> _selectedItems = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) { 
      _dropdownItems.addAll(
        List.generate(10, (index) => TestModel(id: index+1, description: 'Item ${index+1}', descriptionEn: 'Item ${index+1}'))
      );
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            ///
            ///*  [Single Select Dropdown]
            ///
            const Text('Single Select Dropdown'),
            const SizedBox(height: 8),
            KSSelectDropDownWidget(
              items: _dropdownItems, ///* DropDown List
              selectedItems: _selectedItems, ///* DropDown Selected Items
              // displayContentItem: (item) => yourLocalizeMethod(item), /// Based on your localize method
              getSelectedItem: (selectedItems) {
                setState(() {
                  /// get your selected items here
                  _selectedItems = selectedItems;
                });
              }, 
              label: 'Choose option ...',
              dropdownTitle: 'Single Select Option',
              // ksDropDownContentModeEnum: KSDropDownContentModeEnum.wrap, ///* Default: KSDropDownContentModeEnum.list
              // showSearch: true, ///* Default: showSearch = false
            ),

            const SizedBox(height: 8),

            ///
            ///*  [Multi Select Dropdown]
            ///
            const Text('Multi Select Dropdown'),
            const SizedBox(height: 8),
            KSSelectDropDownWidget(
              items: _dropdownItems, ///* DropDown List
              selectedItems: _selectedItems, ///* DropDown Selected Items
              // displayContentItem: (item) => yourLocalizeMethod(item), /// Based on your localize method
              getSelectedItem: (selectedItems) {
                setState(() {
                  /// get your selected items here
                  _selectedItems = selectedItems;
                });
              }, 
              label: 'Choose option ...',
              dropdownTitle: 'Multi Select Option',
              ksDropDownEnum: KSDropDownEnum.multiple,
              // ksDropDownContentModeEnum: KSDropDownContentModeEnum.wrap, ///* Default: KSDropDownContentModeEnum.list
              // showSearch: true, ///* Default: showSearch = false
            )
          ],
        ),
      ),
    );
  }

}
