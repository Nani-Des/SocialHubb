import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:virtual_council/Lawyer/DetailScreen.dart';
import 'package:virtual_council/utils/trim_name.dart';

class SearchPage extends StatefulWidget {
  SearchPage(
      {Key? key, required this.practiceArea, this.region = "", this.name})
      : super(key: key) {
    // TODO: implement
  }
  String practiceArea;
  final String region;
  String? name;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  _SearchPageState() {
    // this.category = category;
    // this.region = region;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _usersStream;
    if (widget.name == null) {
      // al ready implemented code
      _usersStream = widget.practiceArea == ""
          ? FirebaseFirestore.instance
              .collection('Lawyers')
              .where('state', isEqualTo: widget.region)
              .snapshots()
          : FirebaseFirestore.instance
              .collection('Lawyers')
              // .where('casecategory', arrayContainsAny: [widget.practiceArea])
              .where('practicearea', arrayContains: widget.practiceArea)
              .where('state', isEqualTo: widget.region)
              .snapshots();
    } else {
      _usersStream = widget.practiceArea == ""
          ? FirebaseFirestore.instance
              .collection('Lawyers')
              .where('state', isEqualTo: widget.region)
              .where('name', isGreaterThanOrEqualTo: widget.name)
              // .where('name', isLessThanOrEqualTo: '${widget.name}')
              .snapshots()
          : FirebaseFirestore.instance
              .collection('Lawyers')
              .where('practicearea', arrayContainsAny: [widget.practiceArea])
              .where('state', isEqualTo: widget.region)
              .where('name', isGreaterThanOrEqualTo: widget.name)
              // .where('name', isLessThanOrEqualTo: '${widget.name}')
              .snapshots();
    }

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            )),
        title: Text(
          'Results found',
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
        ),
        backgroundColor: Color(0xFF8C1F85),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error.toString());
            print("jhgfdsa");
            return Text('Something went wrong');
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

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot docsSnap) {
              Map<String, dynamic> data =
                  docsSnap.data()! as Map<String, dynamic>;
              return Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Card(
                  shadowColor: Colors.grey,
                  elevation: 2,
                  borderOnForeground: true,
                  shape: RoundedRectangleBorder(
                    side: new BorderSide(
                        color: Colors.lightBlueAccent, width: 1.0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            padding: EdgeInsets.all(10),
                            child: CircleAvatar(
                              child: Text(
                                nameTrim(data['name']),
                                style: TextStyle(color: Colors.white),
                              ),
                              radius: 30,
                              backgroundColor: generateColors(),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data['name'],
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color: Color(0xFF8C1F85),
                                  ),
                                  Text(
                                    data['state'],
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF8C1F85)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[],
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  primary: Colors.blue,
                                ),
                                child: Padding(
                                  child: Text(
                                    "View Profile",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  padding: EdgeInsets.all(14),
                                ),
                                onPressed: () {
                                  // should be uid of selected profile not the current profile
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (ctx) => DetailScreen(
                                              docId: docsSnap.id)));
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

int winRatio(int cWon, int cFought) => ((cWon * 100) / cFought).round();

Color generateColors() {
  Color _randomColor =
      Colors.primaries[Random().nextInt(Colors.primaries.length)];

  return _randomColor;
}
