import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:virtual_council/utils/dataSource.dart';

class LawDashBoardScreen extends StatelessWidget {
  User? user = FirebaseAuth.instance.currentUser;
  List<Meeting> events = [];
  late Meeting event;
  @override
  Widget build(BuildContext context) {
    CollectionReference getLawyer =
        FirebaseFirestore.instance.collection('Lawyers');
    CollectionReference getApt =
        FirebaseFirestore.instance.collection('Appointments');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Appointments",
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
        backgroundColor: Color(0xFF8C1F85),
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<DocumentSnapshot>(
            //Fetching data from the documentId specified of the student
            future: getLawyer.doc(user!.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              //Error Handling conditions
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Document does not exist");
              }

              //Data is output to the user
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Text(
                              " Welcome, ",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(
                              " ${data['name']}",
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.07,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return Text("loading");
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Upcoming Appointments",
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              //Fetching data from the documentId specified of the student
              stream:
                  getApt.where("lawyerUID", isEqualTo: user!.uid).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                //Error Handling conditions
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                //Data is output to the user
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData) {
                  final eventDocument = snapshot.data!.docs;

                  events.clear();
                  for (var e in eventDocument) {
                    // final uid = e.get("uid");
                    final name = e.get("clientName");
                    final from = e.get("aptStartDate");
                    final to = e.get("aptEndDate");
                    // final comment = e.get("comment");
                    // final backgroundColor = e.get("backgroundColor");
                    // final isAllDay = e.get("isAllDay");

                    event = Meeting(
                      // startTime: DateFormat('hh:mm:ss a').parse(from),
                      // endTime: DateFormat('hh:mm:ss a').parse(to),
                      startTime: DateFormat('dd-MM-yyyy').parse(from),
                      endTime: DateFormat('dd-MM-yyyy').parse(to),
                      name: name,
                    );
                    events.add(event);
                  }
                } else {
                  Text("No Appointments");
                }
                return SfCalendar(
                    view: CalendarView.month,
                    firstDayOfWeek: 6,
                    todayHighlightColor: Colors.red,
                    showNavigationArrow: true,
                    monthViewSettings: MonthViewSettings(
                        appointmentDisplayMode:
                            MonthAppointmentDisplayMode.appointment,
                        showAgenda: true),
                    dataSource: MeetingDataSource(events));
              },
            ),
          )
        ],
      ),
    );
  }
}
