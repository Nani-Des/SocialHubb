import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:virtual_council/Client/client_signin.dart';
import 'package:virtual_council/Lawyer/lawyer_signin.dart';
import 'Client/ClEasySignUP.dart';
import 'Lawyer/LawEasySignUP.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String FontsStr = 'DM-Sans';
  bool clientSignIn = false;
  bool lawyerSignIn = false;
  void clearFirebaseInstance() {
    FirebaseAuth inst = FirebaseAuth.instance;
    inst.signOut();
  }

  @override
  void initState() {
    clearFirebaseInstance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double AppBarContainerHeight = height * 0.11;

    return ScreenUtilInit(
      builder: (context, child) {
        return Scaffold(
          body: ListView(children: [
            Container(
              color: Theme.of(context).backgroundColor,
              width: width,
              height: height,
              child: Stack(
                children: [
                  //container containing the image
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      width: width,
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          // color: const Color(0xFF8C1F85).withOpacity(0.75),
                          color: Colors.white,
                          border:
                              Border.all(color: HexColor('8C1F85'), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.07),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 0.5), // changes position of shadow
                            ),
                          ]),
                      child: Center(
                        child: Container(
                            margin: EdgeInsets.only(bottom: 90),
                            child: Image.asset(
                              'images/lawyerlogo.png',
                              scale: 2.5,
                            )),
                      ),
                    ),
                  ),
                  //container with the login section
                  Positioned(
                    top: 220,
                    left: 16,
                    right: 16,
                    child: Container(
                      width: 328,
                      height: 400,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 0.5), // changes position of shadow
                            ),
                          ]),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              constraints:
                                  BoxConstraints(maxWidth: width / 1.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Welcome to Virtual Council',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: FontsStr,
                                        fontWeight: FontWeight.w800,
                                        color: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            ?.color,
                                        letterSpacing: -0.1),
                                  ),
                                  Text(
                                    !clientSignIn && !lawyerSignIn
                                        ? 'The lawyer client bridge'
                                        : (clientSignIn
                                            ? 'Login as client'
                                            : 'Login as lawyer'),
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: FontsStr,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .textTheme
                                            .subtitle1
                                            ?.color
                                            ?.withOpacity(0.75),
                                        letterSpacing: -0.1),
                                  ),
                                ],
                              ),
                            ),
                            if (!clientSignIn && !lawyerSignIn) ...[
                              SizedBox(
                                height: 30,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          lawyerSignIn = false;

                                          clientSignIn = true;
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 296,
                                      height: 48,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: const Color(0xFF8C1F85),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.07),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  0.5), // changes position of shadow
                                            ),
                                          ]),
                                      child: Center(
                                        child: Text(
                                          'Client sign in',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: FontsStr,
                                              fontWeight: FontWeight.w600,
                                              color: HexColor('ffffff')),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          clientSignIn = false;

                                          lawyerSignIn = true;
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: 296,
                                      height: 48,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.white,
                                          border: Border.all(
                                              color: const Color(0xFF8C1F85)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.07),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: Offset(0,
                                                  0.5), // changes position of shadow
                                            ),
                                          ]),
                                      child: Center(
                                        child: Text(
                                          'Lawyer sign in',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: FontsStr,
                                              fontWeight: FontWeight.w600,
                                              color: HexColor('4f4f4f')),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Container(
                                        height: 1,
                                        color: HexColor('4f4f4f'),
                                      )),
                                      Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            'or',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: FontsStr,
                                                fontWeight: FontWeight.w400,
                                                color: HexColor('131313'),
                                                letterSpacing: -0.1),
                                          )),
                                      Expanded(
                                          child: Container(
                                        height: 1,
                                        color: HexColor('4f4f4f'),
                                      )),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    child: TextButton(
                                      onPressed: () {
                                        //open sign up screen
                                        Alert(
                                          context: context,
                                          type: AlertType.none,
                                          title: "GET AN ACCOUNT",
                                          style: AlertStyle(
                                              titleStyle: TextStyle(
                                                  fontWeight: FontWeight.w800),
                                              descStyle: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 18)),
                                          desc:
                                              "How would you like to register?",
                                          buttons: [
                                            DialogButton(
                                              onPressed: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ClEasySignUp())),
                                              color: Color(0xFF8C1F85),
                                              child: const Text(
                                                "CLIENT",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: 'DM-Sans'),
                                              ),
                                            ),
                                            DialogButton(
                                              onPressed: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LawEasySignUp())),
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Color(0xFF8C1F85)),
                                              child: Text(
                                                "LAWYER",
                                                style: TextStyle(
                                                    color: Color(0xFF8C1F85),
                                                    fontSize: 16,
                                                    fontFamily: 'DM-Sans',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ).show();
                                      },
                                      child: Text(
                                        'Don\'t have an account? Sign up',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.blueAccent),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                            if (clientSignIn) ...[
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        if (mounted) {
                                          setState(() {
                                            clientSignIn = false;
                                            lawyerSignIn = false;
                                          });
                                        }
                                      },
                                      child: Icon(Icons.close_rounded)),
                                ],
                              ),
                              ClientSignInScreen(),
                            ],
                            if (lawyerSignIn) ...[
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        if (mounted) {
                                          setState(() {
                                            clientSignIn = false;
                                            lawyerSignIn = false;
                                          });
                                        }
                                      },
                                      child: Icon(Icons.close_rounded)),
                                ],
                              ),
                              LawyerSignInScreen(),
                            ]
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        );
      },
      designSize: (Size(width, height)),
    );
  }
}
