
import 'package:flutter/material.dart';
import 'package:genotechies/widgets/login_widget.dart';
import 'package:genotechies/widgets/singup_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 250,
                      child: const TabBar(
                        labelColor: Colors.black,
                        indicatorColor: Colors.red,
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        tabs: [
                          Tab(
                            text: 'Login',
                          ),
                          Tab(
                            text: 'Signup',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(children: [LoginWidget(), SignupWidget()]),
                )
              ],
            ),
          ),
        ));
  }
}
