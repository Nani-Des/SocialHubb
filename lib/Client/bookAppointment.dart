import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:virtual_council/Client/ClDashDesign.dart';

class bookAppointment extends StatefulWidget {
  final String docId;
  bookAppointment(this.docId);
  @override
  _bookAppointmentState createState() => _bookAppointmentState();
}

Future _showDialog(BuildContext context, String error) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Icon(
            Icons.warning,
            color: Colors.redAccent,
            size: 40,
          ),
          content: Text(
            error,
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            Center(
              child: new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  primary: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Ok'),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        );
      });
}

Future _appointmentDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Icon(
            Icons.done_outline,
            color: Colors.green,
            size: 40,
          ),
          content: Text(
            "Appointment request has been sent to the Lawyer wait for his/her response.",
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          contentPadding: EdgeInsets.all(10.0),
          actions: <Widget>[
            Center(
              child: new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  primary: Colors.blue,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Ok'),
                ),
                onPressed: () {
                  //_formKey.currentState.reset();
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => ClPages())));
                },
              ),
            ),
          ],
        );
      });
}

class _bookAppointmentState extends State<bookAppointment> {
  User? cluser = FirebaseAuth.instance.currentUser;
  late String _contextCase;
  final focus = FocusNode();
  DateTime selectedDate = DateTime.now();
  String displayDate = "";
  String timeStamp =
      DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10);
  var formatter = new DateFormat('dd-MM-yyyy');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String name, number, email;

  @override
  Widget build(BuildContext context) {
    var clients = FirebaseFirestore.instance.collection('Clients');
    return FutureBuilder<DocumentSnapshot>(
      //Fetching data from the documentId specified of the student
      future: clients.doc(cluser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //Error Handling conditions
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          name = data['name'];
          email = data['emailID'];
          number = data['number'];
          return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                "Book Appointment",
                style:
                    TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
              ),
              backgroundColor: Color(0xFF8C1F85),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    new Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            new Text(
                              "*All the fields are mandatory !",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                              textAlign: TextAlign.start,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              validator: (input) {
                                if (input!.isEmpty) {
                                  return 'Please Specify the type of case of yours';
                                }
                              },
                              onSaved: (input) {
                                _contextCase = input!;
                              },
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue)),
                                labelText: "Context of Case",
                                labelStyle: TextStyle(color: Colors.black),
                                hintStyle: TextStyle(color: Colors.black),
                              ),
                              autofocus: false,
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.text,
                              maxLines: 4,
                              autocorrect: false,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            new Text("Select appointment date",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  icon: Icon(Icons.calendar_today),
                                  label: Text(
                                    " Select Date",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () => _selectDate(context),
                                ),
                                Text(formatter.format(selectedDate),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                            new SizedBox(
                              height: 40,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        primary: Colors.blue,
                                        padding: EdgeInsets.all(8)),
                                    child: Padding(
                                      child: Text(
                                        "Request Appointment",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      padding: EdgeInsets.all(14),
                                    ),
                                    onPressed: requestAppointment,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ),
          );
        }
        return Container(
          color: Colors.white,
          child: Center(
            child: SpinKitRipple(
              color: Colors.blue,
              size: 70,
            ),
          ),
        );
      },
    );
  }

  void requestAppointment() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        var dataObject = {
          "clientName": name,
          "emailId": email,
          "number": number,
          "contextCase": _contextCase,
          "date": formatter.format(selectedDate),
          "postedDate": timeStamp,
          "userType": "Lawyer",
          "lawyerUID": widget.docId.toString(),
          "clientUID": (await FirebaseAuth.instance.currentUser!.uid),
        };
        await FirebaseFirestore.instance
            .collection("Notification")
            .doc()
            .set(dataObject);
        print(
            "The lawyer uid is ${widget.docId.toString()} and the client uid is ${FirebaseAuth.instance.currentUser!.uid}");

        _appointmentDialog(context);
      } catch (e) {
        _showDialog(context, e.toString());
      }
    } else {
      print("validator Error");
    }
    print("request Appointment");
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      return selectedDate;
    }
    ;
  }
}
