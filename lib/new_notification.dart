import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:virtual_council/Lawyer/LawDashDesign.dart';
import 'package:virtual_council/room_notification.dart';
import 'package:virtual_council/utils/Video_Call.dart/Signaling.dart';
import 'package:intl/intl.dart';

class newnoti extends StatefulWidget {
  final String _noti;

  newnoti(this._noti) {}

  @override
  _newnotiState createState() => _newnotiState(_noti);
}

class _newnotiState extends State<newnoti> {
  final String __noti_type;

  _newnotiState(this.__noti_type) {}

  User? admin = FirebaseAuth.instance.currentUser;
  var adminData = FirebaseFirestore.instance.collection('Notification');
  var getroomID = FirebaseFirestore.instance.collection('IDroom');
  String? roomIDToJoin;
  String _lawyerName = "";
  String? _noti_type;

  dynamic _context = '';

  List<String> category = [];
  var loaded = false;
  bool switchColor = true;
  String userType = "";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // late double height;
  // late double width;

  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  DateTime selectedDate = DateTime.now();
  //DateTime timeStamp = DateTime.now();
  String timeStamp =
      DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10);
  var formatter = new DateFormat('hh:mm:ss a');
  int nott = 0;

  @override
  void initState() {
    // TODO: implement initState

    getType();

    // page_build();

    // get room number
    var a = FirebaseFirestore.instance
        .collection('IDroom')
        .where("lawyerUID", isEqualTo: admin!.uid)
        // .where("userType", isEqualTo: "Lawyer")
        .snapshots()
        .listen(notification_number);

    super.initState();
  }

  notification_number(QuerySnapshot<Map<String, dynamic>> event) {
    int field = event.docs.length;
    setState(() {
      nott = field;
    });
  }

  getType() async {
    String uid;
    User? user = await _firebaseAuth.currentUser;
    uid = user!.uid;

    String _userType;
    bool isLawyer = false;
    bool isClient = false;
    var check =
        await FirebaseFirestore.instance.collection("Lawyers").doc(uid).get();
    dynamic a = check.data()?.containsKey('emailID');
    a = a.toString() == "null" ? false : true;

    if (a == true) {
      isLawyer = true;
      userType = 'Lawyers';
      _noti_type = 'lawyerUID';
    } else {
      userType = 'Clients';
      isClient = true;
      _noti_type = 'clientUID';
    }

    if (a) {}
    // return _userType;
    var usersData;
    if (userType == "Lawyers") {
      usersData =
          await FirebaseFirestore.instance.collection("Lawyers").doc(uid).get();
    } else {
      usersData =
          await FirebaseFirestore.instance.collection("Clients").doc(uid).get();
    }

    _lawyerName = usersData!["name"];
  }

  @override
  Widget __build(BuildContext context) {
    _context = context;
    return CircularProgressIndicator();
  }

  Widget build(BuildContext context) {
    userType = __noti_type == 'clientUID' ? "Clients" : "Lawyer";

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // print('object');
    String uid = admin!.uid.toString();
    print(uid);
    return StreamBuilder<QuerySnapshot>(
        stream: __noti_type == "clientUID"
            ? adminData
                .where(__noti_type, isEqualTo: uid)
                .where("userType", isEqualTo: "Clients")
                .snapshots()
            : adminData
                .where(__noti_type, isEqualTo: uid)
                .where('userType', isEqualTo: 'Lawyer')

                // .where(field)
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
          print(nott);
          return Scaffold(
            appBar: AppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
              actions: [
                nott != 0
                    ? badges.Badge(
                        // badgeContent: noti_num(),
                        padding: EdgeInsets.all(6),
                        stackFit: StackFit.loose,
                        badgeContent: Text(nott.toString()),
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => roomNoti()));
                            },
                            icon: Icon(Icons.camera_front)),
                      )
                    : IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => roomNoti()));
                        },
                        icon: Icon(Icons.camera_front)),
                SizedBox(
                  width: 8,
                )
              ],
              title: Text(
                "Notifications",
                style:
                    TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
              ),
              backgroundColor: Color(0xFF8C1F85),
              centerTitle: true,
            ),
            body: snapshot.data!.docs.isEmpty
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Icon(
                        Icons.notifications_off,
                        size: 100,
                      ),
                      new Text(
                        "No Notices Right Now ! ",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      new ElevatedButton(
                        onPressed: goDash,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            child: Text(
                              "View Dashboard",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ))
                : ListView(
                    children: snapshot.data!.docs
                        // .where((element) => element.data().[_noti_type] == admin!.uid)
                        .map((DocumentSnapshot docsSnap) {
                      Map<String, dynamic> data =
                          docsSnap.data()! as Map<String, dynamic>;
                      // if (data[_noti_type] == admin!.uid.toString()) {
                      return
                          // data[_noti_type] == admin!.uid ?
                          userType == 'Clients'
                              ? cardsclient(
                                  data["lawyerName"], data["lawyerresponse"])
                              : callCardAndNotification(
                                  data,
                                  docsSnap,
                                  _lawyerName,
                                );
                    }).toList(),
                  ),
          );
        });
  }

  Widget callCardAndNotification(
    data,
    docsSnap,
    name,
  ) {
    return Column(
      children: [
        cardlaywer(
            data,
            docsSnap.id.toString(),
            data['clientName'].toString(),
            data['emailId'].toString(),
            data['number'].toString(),
            data['date'].toString(),
            data['contextCase'].toString()),
        // callNotification4lawyer(data, name),
      ],
    );
  }

  Widget cardlaywer(dynamic notification, String notification_id, String name,
      String email, String contact, String date, String contextcase) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 2,
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.black, width: 0.5),
            borderRadius: BorderRadius.circular(20)),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Icon(
                Icons.info_outline,
                color: Colors.amber,
                size: 25,
              ),
              Text(
                name + " is requesting an appointment with you on " + date,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              Text(
                "Email : " + email,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              Text(
                "Phone Number : " + contact,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Case : ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                contextcase,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 20,
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: switchColor ? Colors.blue : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Padding(
                        child: Text(
                          "Confirm",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        padding: EdgeInsets.all(14),
                      ),
                      onPressed: () {
                        //setDates();
                        sendResult(
                            notification, true, switchColor, notification_id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Accepted appointment respone sent to the client...'),
                          duration: Duration(seconds: 3),
                        ));
                      },
                    ),
                  ),
                  new SizedBox(
                    width: 20,
                  ),
                  new Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: switchColor ? Colors.blue : Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Padding(
                        child: Text(
                          "Decline",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        padding: EdgeInsets.all(14),
                      ),
                      onPressed: () {
                        sendResult(
                            notification, false, switchColor, notification_id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Declined appointment respone sent to the client...'),
                          duration: Duration(seconds: 3),
                        ));
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardsclient(String name, String reponse) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        elevation: 2,
        color: Colors.grey[200],
        shape: RoundedRectangleBorder(
            side: new BorderSide(color: Colors.black, width: 0.5),
            borderRadius: BorderRadius.circular(20)),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Icon(
                Icons.info_outline,
                color: Colors.amber,
                size: 25,
              ),
              Text(
                "Hi,",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "This is to inform you that the lawyer named " +
                    name +
                    " has " +
                    reponse +
                    " your appointment request.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

//stream builder get notification
  Widget callNotification4lawyer(data, String name) => StreamBuilder<Object>(
      stream: getroomID.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Map<String, dynamic> room = snapshot.data! as Map<String, dynamic>;
          roomIDToJoin = room['roomId'];
          print("Room id is ..........: ${room['roomId']}");
          return Text("Room id is ..........: ${room['roomId']}");
        }
        return Padding(
          padding: EdgeInsets.all(10),
          child: Card(
            elevation: 2,
            color: Colors.grey[200],
            shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(
                side: new BorderSide(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular(20)),
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.info_outline,
                    color: Colors.amber,
                    size: 25,
                  ),
                  Text(
                    data['clientName'] +
                        " is requesting a virtual meeting with you",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              primary: Colors.blue),
                          child: Padding(
                            child: Text(
                              "Join meeting",
                              style: TextStyle(color: Colors.white),
                            ),
                            padding: EdgeInsets.all(14),
                          ),
                          onPressed: () {
                            signaling.joinRoom(
                              roomIDToJoin!,
                              _remoteRenderer,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Loading'),
                              duration: Duration(seconds: 3),
                            ));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });

  void goDash() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LawPages()));
  }

//function to set start and end time
  // void setDates() {
  //   FlatButton.icon(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     color: Colors.blue,
  //     icon: Icon(Icons.calendar_today),
  //     label: Text(" Select start duration"),
  //     onPressed: () => _selectDate(context),
  //   );
  //   Text(formatter.format(selectedDate),
  //       style: TextStyle(
  //           color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500));
  //   FlatButton.icon(
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //     color: Colors.blue,
  //     icon: Icon(Icons.calendar_today),
  //     label: Text(" Select end duration"),
  //     onPressed: () => _selectDate(context),
  //   );
  //   Text(formatter.format(selectedDate),
  //       style: TextStyle(
  //           color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500));
  // }

  // Future _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: selectedDate,
  //       firstDate: DateTime(2015, 8),
  //       lastDate: DateTime(2101));
  //   if (picked != null && picked != selectedDate) {
  //     selectedDate = picked;
  //     return selectedDate;
  //   }
  //   ;
  // }

  //function for lawyer accepts client request
  void sendResult(var notificationData, bool result, bool switchColor,
      String notification_id) async {
    var res =
        await FirebaseFirestore.instance.collection("Notification").doc().set({
      "lawyerName": _lawyerName,
      "lawyerresponse": result ? "Accepted" : "Rejected",
      "lawyerUID": notificationData["lawyerUID"],
      "clientUID": notificationData["clientUID"],
      "userType": "Clients"
    });

    var delete = await FirebaseFirestore.instance
        .collection("Notification")
        .doc(notification_id)
        .delete();
    setState(() {
      switchColor = false;
    });
  }
}
