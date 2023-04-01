import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test/screens/home.dart';
import 'package:test/screens/widgets/button.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _nameController;
  late String _name = '';
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _getNameFromDatabase();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _getNameFromDatabase() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final box = await Hive.openBox('user_data');
    setState(() {
      _name = box.get('name', defaultValue: '') as String;
      _nameController.text = _name;
      _isSubscribed = box.get('isSubscribed', defaultValue: false) as bool;
    });
  }

  Future<void> _updateNameInDatabase(String newName) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final box = await Hive.openBox('user_data');
    await box.put('name', newName);
  }

  Future<void> _updateSubscriptionInDatabase(bool isSubscribed) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final box = await Hive.openBox('user_data');
    await box.put('isSubscribed', isSubscribed);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _appBar(),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter your name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              CheckboxListTile(
                title: Text('Sort Tasks by Start Time'),
                value: _isSubscribed,
                activeColor: Colors.black,
                onChanged: (value) {
                  _updateSubscriptionInDatabase(value ?? false);
                  setState(() {
                    _isSubscribed = value ?? false;
                  });
                },
              ),
              SizedBox(height: 20),
              Center(
                child: MyButton(
                    label: "Save",
                    onTap: () {
                      final name = _nameController.text;
                      _updateNameInDatabase(name);
                      setState(() {
                        _name = name;
                      });
                      Navigator.pushNamed(context, '/home');
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _appBar() {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed('/'),
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Settings",
                  style: HeadingStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
