import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:virtual_council/CustomTheme.dart';
import 'package:virtual_council/Lawyer/LawDashDesign.dart';
import 'package:virtual_council/utils/Regions.dart';
export 'package:virtual_council/Lawyer/LawCompleteProfile.dart';
import 'package:virtual_council/utils/lawyer.dart';
import 'package:virtual_council/utils/practicearea.dart';

class LawyerForm extends StatefulWidget {
  @override
  _LawyerFormState createState() => _LawyerFormState();
}

bool statusLoggedIn = true;

class _LawyerFormState extends State<LawyerForm> {
  @override
  void initState() {
    _date.text = ""; //set the initial value of text field
    _state.text = "Ashanti";
    _gender.text = "Male";
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController();
  TextEditingController _state = new TextEditingController();
  TextEditingController _date = new TextEditingController();
  TextEditingController _number = new TextEditingController();
  TextEditingController _gender = new TextEditingController();
  TextEditingController _chambers = new TextEditingController();
  String? uid;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  List<Area> _selectedItems = [];
  final _items =
      AreaData.areas.map((e) => MultiSelectItem<Area>(e, e.area)).toList();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: CustomTheme.lightTheme,
      home: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Complete your profile",
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
          ),
          backgroundColor: Color(0xFF8C1F85),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            width: ScreenUtil().setWidth(width),
            color: Color.fromARGB(255, 241, 237, 237),
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      const Text(
                        "*All the fields are mandatory !",
                        style: TextStyle(fontSize: 12, color: Colors.red),
                        textAlign: TextAlign.start,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      TextFormField(
                        controller: _name,
                        validator: (input) {
                          if (input!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Full Name",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: Colors.redAccent,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      TextFormField(
                        validator: (input) {
                          if (input!.isEmpty) {
                            return 'Enter phone number';
                          } else if (input.length < 10 || input.length > 10) {
                            return 'Enter your phone number without country code';
                          }
                          return null;
                        },
                        controller: _number,
                        onSaved: (input) {
                          _number = int.parse(input!) as TextEditingController;
                          FocusScope.of(context).nextFocus();
                        },
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Phone Number",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.redAccent,
                          ),
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        autofocus: false,
                        maxLength: 10,
                        keyboardType: TextInputType.phone,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      DropdownButtonFormField<String>(
                        menuMaxHeight: 200,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Gender",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 22),
                          prefixIcon: Icon(
                            Icons.person_pin_outlined,
                            color: Colors.redAccent,
                          ),
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        value: _gender.text,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 24,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (String? genValue) {
                          setState(() {
                            _gender.text = genValue!;
                          });
                        },
                        items: <String>['Male', 'Female']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      DropdownButtonFormField<String>(
                        hint: Text('region___'),
                        menuMaxHeight: 400,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        elevation: 10,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Region",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 22),
                          prefixIcon: Icon(
                            Icons.location_pin,
                            color: Colors.redAccent,
                          ),
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        value: _state.text,
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 24,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _state.text = newValue!;
                          });
                        },
                        items: RegionData.regions
                            .map<DropdownMenuItem<String>>((Region value) {
                          return DropdownMenuItem<String>(
                              value: value.region,
                              child: Text(
                                value.region,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                              ));
                        }).toList(),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      TextFormField(
                        controller: _date,
                        validator: (input) {
                          if (input!.isEmpty) {
                            return "Year of Call";
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap: //_pickYear(),
                            () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              final Size size = MediaQuery.of(context).size;
                              return AlertDialog(
                                title: Text(
                                  'Select a Year',
                                ),
                                // Changing default contentPadding to make the content looks better

                                contentPadding: const EdgeInsets.all(10),
                                content: SizedBox(
                                  // Giving some size to the dialog so the gridview know its bounds

                                  height: size.height / 3,
                                  width: size.width,
                                  //  Creating a grid view with 3 elements per line.
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    children: [
                                      // Generating a list of 90 years starting from 2022
                                      // Change it depending on your needs.
                                      ...List.generate(
                                        90,
                                        (index) => InkWell(
                                          onTap: () {
                                            // The action you want to happen when you select the year below,
                                            _date.text =
                                                (2022 - index).toString();

                                            // Quitting the dialog through navigator.
                                            Navigator.pop(context);
                                          },
                                          // This part is up to you, it's only ui elements
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Chip(
                                              label: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                child: Text(
                                                  // Showing the year text, it starts from 2022 and ends in 1900 (you can modify this as you like)
                                                  (2022 - index).toString(),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          hintText: "Year you were called to the bar",
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Year of Call",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          prefixIcon: Icon(
                            Icons.balance,
                            color: Colors.redAccent,
                          ),
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        autofocus: false,
                        autocorrect: false,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      MultiSelectDialogField(
                        items: _items,
                        title: Text("Select Practice Areas"),
                        selectedColor: Colors.grey,
                        buttonIcon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.black54,
                        ),
                        buttonText: Text(
                          "Practice Areas",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        searchable: true,
                        onConfirm: (List<Area> results) {
                          _selectedItems = results;
                        },
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 20)),
                      TextFormField(
                        controller: _chambers,
                        validator: (input) {
                          if (input!.isEmpty) {
                            return 'Please enter your legal department';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue)),
                          labelText: "Chamber/Legal Department",
                          labelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(
                            Icons.house,
                            color: Colors.redAccent,
                          ),
                          hintStyle: TextStyle(color: Colors.black),
                        ),
                        autofocus: false,
                        keyboardType: TextInputType.text,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.words,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 40),
                  child: ElevatedButton(
                    onPressed: () {
                      var _testArea = _selectedItems
                          .map((practiseArea) => practiseArea.area)
                          .toList();
                      final lawyer = Lawyer(
                          name: _name.text,
                          gender: _gender.text,
                          practicearea: _testArea,
                          date: _date.text,
                          state: _state.text,
                          number: _number.text,
                          chambers: _chambers.text);
                      updateUser(lawyer);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(
                          (0.025 * width), 5, (0.025 * width), 5),
                      elevation: 3,
                      primary: Color(0xFF8C1F85),
                    ),
                    child: const Text("Update",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future updateUser(Lawyer lawyer) async {
    final User? user = _firebaseAuth.currentUser;
    uid = user?.uid;

    DocumentReference<Map<String, dynamic>> docUser =
        FirebaseFirestore.instance.collection('Lawyers').doc(uid);
    print(docUser);
    print(uid);

    final json = lawyer.toJson();
    await docUser.update(
      json,
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LawPages()));
  }
}
