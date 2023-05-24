import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:virtual_council/Client/ClSignIn.dart';
import 'package:virtual_council/CustomTheme.dart';
import '../sign_in.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Something went wrong!'));
              } else if (snapshot.hasData) {
                return ClSignIn();
              } else {
                return ClEasySignUp();
              }
            }),
      );
}

class ClEasySignUp extends StatefulWidget {
  const ClEasySignUp({Key? key}) : super(key: key);

  @override
  _ClEasySignUpState createState() => _ClEasySignUpState();
}

class _ClEasySignUpState extends State<ClEasySignUp> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();

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
          backgroundColor: Colors.white,
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
              'Sign up',
              style:
                  TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
            ),
            backgroundColor: Color(0xFF8C1F85),
            centerTitle: true,
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 50),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Client Account',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          'Sign Up To Get Started !',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        // email
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Container(
                                  height: 60,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      left: 30.0,
                                      right: 30.0,
                                      top: 5.0,
                                      bottom: 5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(60)),
                                  child: TextFormField(
                                      controller: emailController,
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                                .hasMatch(value)) {
                                          return "Enter valid mail";
                                        } else {
                                          return null;
                                        }
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                          labelText: 'E-mail',
                                          prefixIcon: Icon(
                                            Icons.email_outlined,
                                          ),
                                          border: InputBorder.none)),
                                ),
                              ),

                              SizedBox(
                                height: 10,
                              ),
                              //password,
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Container(
                                  height: 60,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      left: 30.0,
                                      right: 30.0,
                                      top: 5.0,
                                      bottom: 5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(60)),
                                  child: TextFormField(
                                      controller: passwordController,
                                      validator: (value) {
                                        if (value != null && value.length < 6) {
                                          return "Password shouldn't be less than 6 characters";
                                        } else {
                                          return null;
                                        }
                                      },
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                          labelText: "Enter password",
                                          prefixIcon: Icon(Icons.lock,
                                              color: Colors.grey),
                                          border: InputBorder.none)),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              //password,
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                child: Container(
                                  height: 60,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(
                                      left: 30.0,
                                      right: 30.0,
                                      top: 5.0,
                                      bottom: 5.0),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(60)),
                                  child: TextFormField(
                                      controller: password2Controller,
                                      validator: (value) {
                                        if (passwordController.text !=
                                            password2Controller.text) {
                                          return "Passwords do not match";
                                        } else {
                                          return null;
                                        }
                                      },
                                      obscureText: true,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      decoration: InputDecoration(
                                          errorStyle: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                          labelText: "Confirm password",
                                          prefixIcon: Icon(Icons.lock,
                                              color: Colors.grey),
                                          border: InputBorder.none)),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Sign up button
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Container(
                            width: 200,
                            height: 50,
                            child: MaterialButton(
                              onPressed: fireSignUp,
                              child: Text(
                                'SIGN UP',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              color: Color(0xFF8C1F85),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60)),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 0,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (_) => LoginScreen()),
                                  (route) => false);
                            },
                            //open login screen
                            child: Text(
                              'Already Have An Account? Log In',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future fireSignUp() async {
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
          .createUserWithEmailAndPassword(
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
    setUserEmail();

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  setUserEmail() async {
    User? user = _firebaseAuth.currentUser;
    CollectionReference docUser =
        FirebaseFirestore.instance.collection('Clients');

    await docUser
        .doc(user?.uid)
        .set({"emailID": emailController.text}, SetOptions(merge: true));
  }
}
