import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class TestPermissionNativeIntegrationTest extends StatefulWidget {
  const TestPermissionNativeIntegrationTest({ Key? key }) : super(key: key);

  @override
  State<TestPermissionNativeIntegrationTest> createState() => _TestPermissionNativeIntegrationTestState();
}

class _TestPermissionNativeIntegrationTestState extends State<TestPermissionNativeIntegrationTest> {

  String _value = "null";
  late Permission _permission;

  @override
  void initState() {
    
    
    super.initState();
    getPermission();
  }

  void _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Material Dialog'),
            content: Text('Hey! I am Coflutter!'),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close')),
              TextButton(
                onPressed: () {
                  print('HelloWorld!');
                  Navigator.pop(context);
                },
                child: Text('HelloWorld!'),
              )
            ],
          );
        });
  }

  Future<void> getPermission() async {

    _permission = Permission.locationWhenInUse;

    final  isGranted = await _permission.status.isGranted;

    print('PERMISSION LOCATION WHEN IN USE');
    print(isGranted);

    if(isGranted){
      _value = 'Status granted';
    } else {
       if (await Permission.locationWhenInUse.request().isGranted) {
              print('permission');
              _value = 'Status granted';
              } else {

      _value = 'Status denied';
              }

    }

    setState(() {});

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () async {
    
          }, child: Text('Permission')),
          SizedBox(height: 30,),
          // IconData(123),
          Icon(Icons.access_alarm),
          Text(_value),

          ElevatedButton(onPressed: _showMaterialDialog, child: Text('Dialog')),
        ],
      ),
    );
  }
}