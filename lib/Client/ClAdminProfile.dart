import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:virtual_council/Client/ClCompleteProfile.dart';
import 'package:virtual_council/utils/trim_name.dart';

class ClProfile extends StatefulWidget {
  @override
  _ClProfileState createState() => _ClProfileState();
}

class _ClProfileState extends State<ClProfile> {
  User? admin = FirebaseAuth.instance.currentUser;
  var adminData = FirebaseFirestore.instance.collection('Clients');

  List<String> category = [];
  var loaded = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder<DocumentSnapshot>(
        future: adminData.doc(admin?.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitRipple(
                color: Colors.blue,
                size: 70,
              ),
            );
          }
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
              appBar: AppBar(
                leading: InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Text(
                  "My profile",
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: Colors.white),
                ),
                backgroundColor: Color(0xFF8C1F85),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        10, (0.05 * height), 10, (0.015 * height)),
                    child: Container(
                        height: height,
                        child: Column(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                        blurRadius: 8)
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)),
                              padding: EdgeInsets.all(20),
                              alignment: Alignment.center,
                              height: 280,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: <Widget>[
                                  new CircleAvatar(
                                    child: Text(
                                      nameTrim(data['name']),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    radius: 70,
                                    backgroundColor: generateColors(),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  new Text(
                                    data['name'],
                                    style: TextStyle(fontSize: 28),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: new Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        spreadRadius: 1,
                                        blurRadius: 2)
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Email: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                            data['emailID'] == null
                                                ? " "
                                                : data['emailID'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    new SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Date of Birth: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(data['date'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    new SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Phone Number : ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(data['number'],
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    new SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "Location : ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              data['state'],
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.fromLTRB(
                                          (0.025 * width),
                                          5,
                                          (0.025 * width),
                                          5),
                                      elevation: 3,
                                      primary: Color(0xFF8C1F85)),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClCompleteProfile()));
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: Text(
                                      "Update",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  )))
                        ]))),
              ));
        });
  }

  Color generateColors() {
    Color _randomColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];

    return _randomColor;
  }
}
