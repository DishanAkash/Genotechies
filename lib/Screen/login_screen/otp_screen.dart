import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:genotechies/Screen/Home/home.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OtpScreen extends StatefulWidget {
  final String otp;
  final String email;
  final String password;

  OtpScreen(this.otp, this.email, this.password);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<ScaffoldState> _scaffolkey = GlobalKey<ScaffoldState>();
  EmailAuth emailAuth = EmailAuth(sessionName: "Sample session");
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFoucus = FocusNode();
  final BoxDecoration pinPutdecoration = BoxDecoration(
      color: const Color.fromRGBO(255, 255, 255, 1),
      borderRadius: BorderRadius.circular(10.0),
      border: Border.all(
        color: const Color.fromRGBO(255, 0, 0, 1),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolkey,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Verification',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Enter your OTP code number",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 28,
                    ),
                    PinPut(
                      fieldsCount: 6,
                      textStyle:
                          const TextStyle(fontSize: 25.0, color: Colors.black),
                      eachFieldWidth: 40.0,
                      eachFieldHeight: 55.0,
                      focusNode: _pinPutFoucus,
                      controller: _pinPutController,
                      submittedFieldDecoration: pinPutdecoration,
                      selectedFieldDecoration: pinPutdecoration,
                      followingFieldDecoration: pinPutdecoration,
                      pinAnimationType: PinAnimationType.fade,
                      onSubmit: (pin) async {

                        bool result = emailAuth.validateOtp(
                            recipientMail: widget.email, userOtp: pin);
                        if (result) {

                            try {
                              final newUser = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                  email: widget.email, password: widget.password);

                              if (newUser != null) {
                                  Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                  builder: (context) => const HomeScreen()),
                                  (route) => false);
                              }
                            } on FirebaseAuthException catch (error) {

                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
                            }
                          } else {
                          FocusScope.of(context).unfocus();
                          _scaffolkey.currentState!.showSnackBar(const SnackBar(
                            content: Text("invalid OTP"),
                          ));
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
