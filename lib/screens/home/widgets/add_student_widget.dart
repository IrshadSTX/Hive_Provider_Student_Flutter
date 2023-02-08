import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:week_5/db/core/constants.dart';
import 'package:week_5/db/functions/db_functions.dart';

import 'package:week_5/db/model/data_model.dart';
import 'package:week_5/db/provider/provider.dart';

class AddStudentWidget extends StatelessWidget {
  AddStudentWidget({Key? key}) : super(key: key);

  final _nameController = TextEditingController();

  final _ageController = TextEditingController();

  final _mobileController = TextEditingController();

  final _schoolController = TextEditingController();

  bool imageAlert = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<ProviderData>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback(((timeStamp) {
      studentProvider.uphoto = null;
    }));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add Student Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  kHeight,
                  Consumer<ProviderData>(
                      builder: (context, value, Widget? child) {
                    log('rebuild image');
                    return Center(
                      child: value.uphoto == null
                          ? const CircleAvatar(
                              radius: 80,
                              backgroundImage:
                                  AssetImage('assets/images/d3.jpg'),
                            )
                          : CircleAvatar(
                              backgroundImage: FileImage(
                                File(
                                  value.uphoto!.path,
                                ),
                              ),
                              radius: 60,
                            ),
                    );
                  }),
                  kHeight,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black, elevation: 10),
                        onPressed: () {
                          studentProvider.getPhoto();
                        },
                        icon: const Icon(
                          Icons.image_outlined,
                        ),
                        label: const Text(
                          'Add Your Profile picture',
                        ),
                      ),
                    ],
                  ),
                  kHeight,
                  const Text(
                    'Enter Details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  kHeight,
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your name',
                      labelText: 'Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required Name';
                      } else {
                        return null;
                      }
                    },
                  ),
                  kHeight,
                  TextFormField(
                    controller: _ageController,
                    maxLength: 3,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your age',
                      labelText: 'Age',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required Age ';
                      } else if (value.length > 100) {
                        return 'Enter Correct Age';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _mobileController,
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Mobile No',
                      labelText: 'Mobile No',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter Phone Number';
                      } else if (value.length != 10) {
                        return 'Require valid Phone Number';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _schoolController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter school name',
                      labelText: 'School',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required School Name';
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate() &&
                              studentProvider.uphoto != null) {
                            onAddStudentButtonClicked(context);
                            Navigator.of(context).pop();
                          } else {
                            imageAlert = true;
                          }
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onAddStudentButtonClicked(ctx) async {
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final mobile = _mobileController.text.trim();
    final school = _schoolController.text.trim();
    if (name.isEmpty ||
        age.isEmpty ||
        mobile.isEmpty ||
        school.isEmpty ||
        Provider.of<ProviderData>(ctx, listen: false).uphoto!.path.isEmpty) {
      return;
    } else {
      Provider.of<ProviderData>(ctx, listen: false).getAllStudents();
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(20),
          content: Text("Student Added Successfully"),
        ),
      );
    }

    final student = StudentModel(
      name: name,
      age: age,
      mobile: mobile,
      school: school,
      photo: Provider.of<ProviderData>(ctx, listen: false).uphoto!.path,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    Provider.of<FunctionsDB>(ctx, listen: false).addStudent(student);
    Provider.of<FunctionsDB>(ctx, listen: false).getAllStudent();
  }
}
