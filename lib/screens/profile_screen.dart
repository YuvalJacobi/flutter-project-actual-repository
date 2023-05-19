import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/provider/user_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String firstName = '';
  String lastName = '';
  int age = -1;
  double height = -1;
  double weight = -1;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    firstNameController.text = userProvider.myUser.first_name;
    lastNameController.text = userProvider.myUser.last_name;

    if (userProvider.myUser.age != -1)
      ageController.text = userProvider.myUser.age.toString();
    else
      ageController.text = '';

    if (userProvider.myUser.height != -1)
      heightController.text = userProvider.myUser.height.toString();
    else
      heightController.text = '';

    if (userProvider.myUser.weight != -1)
      weightController.text = userProvider.myUser.weight.toString();
    else
      weightController.text = '';
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  void saveProfile() {
    // Save the updated values
    Provider.of<UserProvider>(context, listen: false).myUser.first_name =
        firstNameController.text;
    Provider.of<UserProvider>(context, listen: false).myUser.last_name =
        lastNameController.text;
    Provider.of<UserProvider>(context, listen: false).myUser.age =
        int.tryParse(ageController.text) ?? -1;
    Provider.of<UserProvider>(context, listen: false).myUser.height =
        double.tryParse(heightController.text) ?? -1;
    Provider.of<UserProvider>(context, listen: false).myUser.weight =
        double.tryParse(weightController.text) ?? -1;

    Provider.of<UserProvider>(context, listen: false).setData();

    String uid =
        Provider.of<UserProvider>(context, listen: false).myUser.user_id;
    print('User ID: $uid');
    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Age: $age');
    print('Height: $height');
    print('Weight: $weight');
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context, listen: false)
        .fetchUserData()
        .then((value) => {
              firstName = Provider.of<UserProvider>(context, listen: false)
                  .myUser
                  .first_name,
              lastName = Provider.of<UserProvider>(context, listen: false)
                  .myUser
                  .last_name,
              age =
                  Provider.of<UserProvider>(context, listen: false).myUser.age,
              height = Provider.of<UserProvider>(context, listen: false)
                  .myUser
                  .height,
              weight = Provider.of<UserProvider>(context, listen: false)
                  .myUser
                  .weight,
            });

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => null,
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                    image: null,
                  ),
                  child: Icon(Icons.camera_alt, size: 64.0),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: heightController,
                decoration: InputDecoration(
                  labelText: 'Height (cm)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Weight (kg)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: saveProfile,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
