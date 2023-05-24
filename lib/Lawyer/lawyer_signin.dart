import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:virtual_council/Lawyer/LawDashDesign.dart';
import 'package:virtual_council/Lawyer/LawSignIn.dart';
import 'LawOTSign.dart';

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
                return LawPages();
              } else {
                return LawSignIn();
              }
            }),
      );
}

class LawyerSignInScreen extends StatefulWidget {
  const LawyerSignInScreen({Key? key}) : super(key: key);

  @override
  State<LawyerSignInScreen> createState() => _LawyerSignInScreenState();
}

class _LawyerSignInScreenState extends State<LawyerSignInScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  Future fireSignIn() async {
    final isValid = formKey.currentState!.validate();
    FirebaseAuth loginINS = FirebaseAuth.instance;
    if (!isValid) return;
    try {
      await loginINS
          .signInWithEmailAndPassword(
              email: emailTEC.text.trim(), password: passwordTEC.text.trim())
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

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => FutureSignIn()),
        (route) => false);
  }

  @override
  void dispose() {
    emailTEC.dispose();
    passwordTEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Form(
      key: formKey,
      child: Column(
        children: [
          InputField(
              title: 'E-mail',
              location: false,
              isEmail: true,
              controller: emailTEC),
          InputField(
              title: 'Password',
              location: false,
              isEmail: false,
              controller: passwordTEC),
          SizedBox(
            height: 26,
          ),
          InkWell(
            onTap: fireSignIn,
            child: Container(
              height: 45,
              width: width / 3,
              decoration: BoxDecoration(
                  color: HexColor('8C1F85'),
                  borderRadius: BorderRadius.circular(5)),
              child: Center(
                child: Text(
                  'Sign in',
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'DM-Sans',
                      fontWeight: FontWeight.w600,
                      color: HexColor('ffffff')),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class InputField extends StatelessWidget {
  final String title;
  final String? hint;
  final bool location, isEmail;
  final TextEditingController controller;

  const InputField({
    Key? key,
    required this.title,
    this.hint,
    required this.location,
    required this.isEmail,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Text(
          title,
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyText2?.color,
              fontFamily: 'Gilroy-SemiBold',
              fontWeight: FontWeight.w600,
              fontSize: 14),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 48,
          decoration: BoxDecoration(
              border: Border.all(color: HexColor('e0e0e0')),
              borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    // width: width >= 411 ? 150 : 90,
                    child: TextFormField(
                      cursorColor: const Color.fromRGBO(79, 79, 79, 1),
                      // keyboardType: isNumber ? TextInputType.number : null,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Gilroy-Medium',
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).textTheme.bodyText2?.color,
                          letterSpacing: -0.1),
                      cursorHeight: 18,
                      autofocus: false,
                      obscureText: this.title == 'Password' ? true : false,
                      decoration: InputDecoration(
                          hintText: hint ?? hint, border: InputBorder.none),
                      controller: controller,
                      validator: isEmail
                          ? (value) {
                              if (value!.isEmpty ||
                                  !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                      .hasMatch(value)) {
                                return "Enter valid mail";
                              } else {
                                return null;
                              }
                            }
                          : (value) {
                              if (value != null && value.length < 6) {
                                return "Password shouldn't be less than 6 characters";
                              } else {
                                return null;
                              }
                            },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
