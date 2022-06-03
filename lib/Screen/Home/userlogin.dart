
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

import '../../widgets/error.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  bool _isObscure = true;
  bool _isObscure2 = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pswrdController = TextEditingController();
  final TextEditingController _cpswrdController = TextEditingController();
  EmailAuth emailAuth = EmailAuth(sessionName: "Sample session");
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    'Hello Guest',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 80,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    label: Text('User name'), icon: Icon(Icons.alternate_email)),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _pswrdController,
                obscureText: _isObscure,
                decoration: InputDecoration(
                    label: const Text('Password'),
                    icon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        })),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _cpswrdController,
                obscureText: _isObscure2,
                decoration: InputDecoration(
                    label: const Text('Confirm Password'),
                    icon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        icon: Icon(_isObscure2
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure2 = !_isObscure2;
                          });
                        })),
              ),
              Container(
                margin: const EdgeInsets.only(left: 36, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(

                      onPressed: () {

                        try{
                          if(_pswrdController.text == _cpswrdController.text){

                          }
                          else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Password Not Matched!')));

                          }
                        }catch (e){
                          String error = e.toString();
                          String error1 =
                          ExceptionManagement.loginExceptions(
                              context: context, error: error);
                          FlutterToastr.show(error1, context,
                              duration: FlutterToastr.lengthShort,
                              position: FlutterToastr.bottom);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 25),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          primary: Colors.black),
                      child: const Text(
                        "SignUp",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
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
