import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _nameController;
  late String _name = '';

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
    });
  }

  Future<void> _updateNameInDatabase(String newName) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    final box = await Hive.openBox('user_data');
    await box.put('name', newName);
  }

  Future<void> _showSaveDialog(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
    String newName = _name;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Changes'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              onChanged: (value) {
                newName = value;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _updateNameInDatabase(newName);
                  setState(() {
                    _name = newName;
                  });
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: Theme.of(context).textTheme.headline6,
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _name,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showSaveDialog(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
