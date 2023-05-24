import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_council/Client/ClDashDesign.dart';
import 'package:virtual_council/CustomTheme.dart';
import 'package:intl/intl.dart';
import 'package:virtual_council/utils/client.dart';

class ClCompleteProfile extends StatefulWidget {
  const ClCompleteProfile({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ClCompleteProfile();
  }
}

class _ClCompleteProfile extends State<ClCompleteProfile> {
  TextEditingController fName = TextEditingController();
  TextEditingController lName = TextEditingController();
  TextEditingController _date = TextEditingController();
  TextEditingController loca = TextEditingController();
  TextEditingController PhNumber = TextEditingController();
  FirebaseAuth fireAuth = FirebaseAuth.instance;

  @override
  void initState() {
    _date.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
        theme: CustomTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            title: Text(
              "Complete Profile",
              style:
                  TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
            ),
            backgroundColor: Color(0xFF8C1F85),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
              child: Container(
            width: ScreenUtil().setWidth(width),
            height: ScreenUtil().setHeight(height),
            color: Colors.grey[350],
            padding: const EdgeInsets.only(
              bottom: 100,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'First Name',
                        prefixIcon: Icon(Icons.person_outline),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      controller: fName,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return "Enter valid name";
                        } else {
                          return null;
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Last Name',
                        prefixIcon: Icon(Icons.person),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      controller: lName,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                          return "Enter valid name";
                        } else {
                          return null;
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Date of Birth',
                      prefixIcon: Icon(Icons.key),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    controller: _date,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1910),
                          lastDate: DateTime(2050));

                      if (pickedDate != null) {
                        setState(() {
                          _date.text =
                              DateFormat('dd-MM-yyyy').format(pickedDate);
                        });
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Location',
                        prefixIcon: Icon(Icons.person_outline),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      controller: loca,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field cannot be empty";
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone),
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      controller: PhNumber,
                      validator: (value) {
                        if (value!.isEmpty ||
                            !RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}{-\s\./0-9]+$')
                                .hasMatch(value)) {
                          return "Enter valid phone number";
                        } else {
                          return null;
                        }
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: ElevatedButton(
                      onPressed: () {
                        final client = Client(
                          name: fName.text + " " + lName.text,
                          state: loca.text,
                          date: _date.text,
                          number: PhNumber.text,
                        );
                        update(client);
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(
                              (0.025 * width), 5, (0.025 * width), 5),
                          elevation: 3,
                          primary: Color(0xffd9d9d9)),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: Text(
                          "SUBMIT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF8C1F85),
                            fontSize: 20,
                          ),
                        ),
                      )),
                )
              ],
            ),
          )),
        ));
  }

  Future update(Client client) async {
    final User? user = fireAuth.currentUser;
    final id = user?.uid;

    DocumentReference<Map<String, dynamic>> doccUser =
        FirebaseFirestore.instance.collection('Clients').doc(id);

    final json = client.toJson();
    await doccUser.update(
      json,
    );
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ClPages()));
  }
}
