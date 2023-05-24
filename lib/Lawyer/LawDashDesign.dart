import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:virtual_council/Lawyer/LawDashBoard.dart';
import 'package:virtual_council/Lawyer/LawyerAdminProfile.dart';
import 'package:virtual_council/core_chat/chatHomePage.dart';
import 'package:virtual_council/new_notification.dart';
import 'package:badges/badges.dart' as badges;
import 'package:virtual_council/utils/lawyer.dart';

class LawPages extends StatefulWidget {
  static final String id = 'profile_page';
  @override
  _LawPagesState createState() => _LawPagesState();
}

class _LawPagesState extends State<LawPages> {
  final _pageController = PageController();
  User? user = FirebaseAuth.instance.currentUser;
  dynamic _lawyer;
  int nott = 0;

  int index = 0;

  @override
  void initState() {
    super.initState();

    noti_num();

    var a = FirebaseFirestore.instance
        .collection('Notification')
        .where("lawyerUID", isEqualTo: user!.uid)
        .where("userType", isEqualTo: "Lawyer")
        .snapshots()
        .listen(notification_number);

    FirebaseFirestore.instance
        .collection("Lawyers")
        .doc(user!.uid)
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      _lawyer = Lawyer.fromJson(snapshot.data()!);
    });
  }

  notification_number(QuerySnapshot<Map<String, dynamic>> event) {
    int field = event.docs.length;
    setState(() {
      nott = field;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
          controller: _pageController,
          children: <Widget>[
            LawDashBoardScreen(),
            ChatHomePage(),
            newnoti('lawyerUID'),
            LawProfile(),
          ],
          onPageChanged: (index) {
            setState(() {
              _pageController.jumpToPage(index);
            });
          }),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50.h,
        backgroundColor: Color(0xFF8C1F85),
        animationDuration: Duration(milliseconds: 10),
        onTap: (index) {
          setState(() {
            _pageController.jumpToPage(index);
          });
        },
        letIndexChange: (index) => true,
        items: [
          Icon(Icons.home, size: 30.h),
          Icon(Icons.chat, size: 30.h),
          // Icon(Icons.notifications, size: 30.h),
          nott != 0
              ? badges.Badge(
                  // badgeContent: noti_num(),
                  badgeContent: Text(nott.toString()),
                  child: Icon(Icons.notifications, size: 30.h),
                )
              : Icon(Icons.notifications, size: 30.h),
          //Icon(Icons.map, size: 30.h),
          Icon(Icons.account_circle, size: 30.h),
        ],
      ),
    );
  }

  noti_num() {
    DocumentReference reference =
        FirebaseFirestore.instance.collection('Notification').doc(user!.uid);
    reference.snapshots().listen((querySnapshot) {
      int field = reference.snapshots().length as int;
      setState(() {
        field;
        nott = reference.snapshots().length as int;
      });
    });
  }
}
