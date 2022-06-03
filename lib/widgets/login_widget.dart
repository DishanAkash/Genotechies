
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:genotechies/Screen/Home/home.dart';
import 'package:genotechies/widgets/error.dart';
import 'package:genotechies/widgets/messege.dart';
import 'package:google_sign_in/google_sign_in.dart';

//final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

class LoginWidget extends StatefulWidget {
  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  bool _isObscure = true;
  late String email;
  late String password;
  final FirebaseAuth auth = FirebaseAuth.instance;


  final FCM pushNotification =FCM();


  @override
  void initState(){
    super.initState();
    pushNotification.requestPermission();
    pushNotification.loadFCM();
    pushNotification.listenFCM();
    FirebaseMessaging.instance.subscribeToTopic("Login");
  }



  void login() async{
      try {

        await auth.signInWithEmailAndPassword(email: email, password: password);

        final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email, password: password);
        // ignore: unnecessary_null_comparison
        if (user != null) {

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const HomeScreen()));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login Success!')));
          // }
        }
      } on FirebaseAuthException catch (e) {

        String error = e.toString();
        String error1 =
        ExceptionManagement.loginExceptions(
            context: context, error: error);
        FlutterToastr.show(error1, context,
            duration: FlutterToastr.lengthShort,
            position: FlutterToastr.bottom);


       }
  }



  Future <void> googleSignIn()async{
    final googlesigninIn = GoogleSignIn();
    final googleAccount = await googlesigninIn.signIn();
    if(googleAccount != null){
      final googleAuth = await googleAccount.authentication;
      if(googleAuth.idToken != null && googleAuth.accessToken != null){
        try {

         await auth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken),
          );
          if (FirebaseAuth.instance.currentUser != null) {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        }on FirebaseAuthException catch(error){
          print (error.message);
          
        }
      }
    }
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login(

    );

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    final userData= await FacebookAuth.instance.getUserData();



    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

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
                    'Welcome Back',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 80,
              ),
              TextFormField(
                validator: (value) => value!.isEmpty ? 'Field cannot be empty':null,
                onChanged: (value){
                  email=value;
                },
                decoration: const InputDecoration(

                    label: Text('Email'), icon: Icon(Icons.alternate_email)),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) => value!.isEmpty ? 'Field cannot be empty':null,
                onChanged: (value){
                  password=value;
                },
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
              Container(
                margin: const EdgeInsets.only(left: 36, top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        login();
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 25),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          primary: Colors.black),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    Row(
                      children: [
                        const Text(
                          'Or',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey,
                          child: IconButton(
                            onPressed: (){
                              googleSignIn();
                            },
                            icon: const ImageIcon(
                                AssetImage('assets/google.png')),
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 10.0,),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey,
                          child: IconButton(
                            onPressed: ()async{
                              await signInWithFacebook();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    // ignore: prefer_const_constructors
                                      builder: (context) => HomeScreen()));
                            },
                            icon: const ImageIcon(
                                AssetImage('assets/facebook.png')),
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
