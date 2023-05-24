import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:virtual_council/Client/ClDashDesign.dart';
import 'package:virtual_council/Client/ClOTSignIn.dart';
import 'package:virtual_council/CustomTheme.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong!'));
              } else if (snapshot.hasData) {
                return ClPages(); //ClHomePage();
              } else {
                return ClSignIn();
              }
            }),
      );
}

class ClSignIn extends StatefulWidget {
  @override
  _ClSignInState createState() => _ClSignInState();
}

class _ClSignInState extends State<ClSignIn> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return MaterialApp(
        theme: CustomTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: SafeArea(
              child: Container(
            width: ScreenUtil().setWidth(width),
            height: ScreenUtil().setHeight(height),
            color: const Color(0xFF8C1F85),
            padding: const EdgeInsets.only(
              bottom: 100,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: ScreenUtil().setWidth(width),
                    height: ScreenUtil().setHeight(0.2 * height),
                    color: const Color(0xffd9d9d9),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'E-mail',
                            prefixIcon: Icon(Icons.mail_outline),
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            errorStyle: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            )),
                        controller: emailController,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                  .hasMatch(value)) {
                            return "Enter valid mail";
                          } else {
                            return null;
                          }
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.key),
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            errorStyle: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            )),
                        controller: passwordController,
                        validator: (value) {
                          if (value != null && value.length < 6) {
                            return "Password shouldn't be less than 6 characters";
                          } else {
                            return null;
                          }
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: ElevatedButton(
                        onPressed: fireSignIn,
                        style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(
                                (0.025 * width), 5, (0.025 * width), 5),
                            elevation: 3,
                            primary: Color(0xffd9d9d9)),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                          child: Text(
                            "Sign In",
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
            ),
          )),
        ));
  }

  Future fireSignIn() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim())
          .catchError((onError) {
        Navigator.pop(context);
        String errMsg = onError.toString();
        Alert(
          context: context,
          type: AlertType.error,
          style: const AlertStyle(
            isCloseButton: false,
            isOverlayTapDismiss: false,
          ),
          title: "ERROR",
          desc: errMsg,
          buttons: [
            DialogButton(
              color: Color(0xFF8C1F85),
              onPressed: () => Navigator.pop(context),
              width: 0.2 * MediaQuery.of(context).size.width,
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show();
      });
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ClFutureSignIn()));
  }
}
