//View lawyer Profile Screen
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:virtual_council/Client/bookAppointment.dart';
import 'package:virtual_council/core_chat/ChatScreen.dart';
import 'package:virtual_council/utils/Video_Call.dart/call.dart';
import '../utils/trim_name.dart';

class DetailScreen extends StatefulWidget {
  User? usid = FirebaseAuth.instance.currentUser;
  final String docId;

  DetailScreen({required this.docId});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  User? usid = FirebaseAuth.instance.currentUser;
  final formatCurrency = new NumberFormat.simpleCurrency();

  List<String> category = [];
  var loaded = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final _userStream = FirebaseFirestore.instance
        .collection('Lawyers')
        .doc(widget.docId)
        .get();

    return FutureBuilder<DocumentSnapshot>(
      future: _userStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            color: Colors.white,
            child: Center(
              child: SpinKitRipple(
                color: Colors.blue,
                size: 70,
              ),
            ),
          );
        }

        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                "Lawyer Profile",
                style:
                    TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
              ),
              backgroundColor: Color(0xFF8C1F85),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    10, (0.05 * height), 10, (0.1 * height)),
                child: Column(
                  children: <Widget>[
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
                        height: 300,
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
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                new Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        primary: Colors.blue),
                                    child: Padding(
                                      child: Text(
                                        "Book",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(14),
                                    ),
                                    onPressed: bookAppoint,
                                  ),
                                ),
                                new SizedBox(
                                  width: 20,
                                ),
                                new Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        primary: Colors.blue),
                                    child: Padding(
                                      child: Text(
                                        "Message",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(14),
                                    ),
                                    onPressed: () {
                                      toChat(
                                          lawyerDocId: widget.docId,
                                          lawyerName: data['name'],
                                          lawyerEmail: data['emailID'],
                                          userId: usid!.uid);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10),
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
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
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
                                    "Location: ",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                              new SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Year called to the Bar: ",
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
                                    "Phone Number:",
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
                                  Text("Practice Areas:",
                                      style: TextStyle(
                                        fontSize: 15,
                                      )),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          25, 10, 0, 10),
                                      child: Text(
                                        data['practicearea']
                                            .toString()
                                            .replaceAll("[", "")
                                            .toString()
                                            .replaceAll("]", "")
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.blueAccent),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Chambers/ \n Legal Department: ",
                                    maxLines: 3,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        width: 120.0,
                                        height: 60,
                                        child: Text(
                                          data['chambers'],
                                          maxLines: 3,
                                          overflow: TextOverflow.visible,
                                          //softWrap: false,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "Fees charged: ",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                          "Fees charged depends on \n context of case ",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 26,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }

  bookAppoint() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => bookAppointment(widget.docId))));
  }

  Color generateColors() {
    Color _randomColor =
        Colors.primaries[Random().nextInt(Colors.primaries.length)];

    return _randomColor;
  }

  void toCall({required String lawyerDocId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Call(
                  lawyerDocId: lawyerDocId,
                )));
  }

  void toChat(
      {required String lawyerDocId,
      required String userId,
      required String lawyerName,
      required String lawyerEmail}) async {
    final userData = await FirebaseFirestore.instance
        .collection('Clients')
        .where('emailID', isEqualTo: usid!.email)
        .get();
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc('$lawyerDocId$userId')
        .set({
      'clientName': userData.docs.first.data()['name'],
      'clientEmail': usid!.email,
      'clientId': userId,
      'lawyerId': lawyerDocId,
      'lawyerName': lawyerName,
      'lawyerEmail': lawyerEmail,
    });
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatScreen(
                  lawyerID: lawyerDocId,
                  userID: userId,
                  isLawyer: false,
                )));
  }
}
