import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:genotechies/Screen/login_screen/login_screen.dart';
import 'package:genotechies/widgets/messege.dart';
import 'package:google_sign_in/google_sign_in.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double rating = 4.8;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FCM pushNotification = FCM();
  @override
  void initState(){
    super.initState();
    pushNotification.sendPushMessage(
      'You have Successfully logged into the system',
      'Welcome to the Genotechies(pvt) Ltd.',
    );
  }


  @override
  Widget build(BuildContext context) {

        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user == null) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginScreen()),
                    (route) => false);
          }
        });
    // final GoogleSignIn googleSignIn = new GoogleSignIn();
    //     if(FirebaseAuth.instance.currentUser==null || googleSignIn.currentUser==null){
    //           Navigator.pushAndRemoveUntil(
    //               context,
    //               MaterialPageRoute(
    //                   builder: (context) => const LoginScreen()),
    //                   (route) => false);
    //     }

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: const Color(0xffff86f8),
        leading: GestureDetector(
          onTap: (){
            FirebaseAuth.instance.signOut();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logout Success!')));
           // googleSignIn.signOut();
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.red,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.shopping_cart_outlined),
            ),
          )
        ],
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  height: 400,
                  clipBehavior: Clip.hardEdge,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(160),
                      )),
                  child: Image.network(
                    'https://www.igp.com/blog/wp-content/uploads/2022/02/Plan-the-Perfect-Surprise-With-These-Delicious-Birthday-Cakes.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Straberry Frosted Sprinkles',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Price INR: 265',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          RatingBarIndicator(
                            rating: rating,
                            itemBuilder: (context, index) =>
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 30.0,
                            direction: Axis.horizontal,
                          ),
                          Text(
                            'Rating: ${rating.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FloatingActionButton.small(
                                  heroTag: "btn2",
                                  onPressed: () {
                                    if (rating < 4.9) {
                                      setState(() {
                                        rating += 0.1;
                                      });
                                    }
                                  },
                                  child: const Icon(Icons.add_circle_outline),
                                ),
                                Text(rating.toStringAsFixed(2),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                FloatingActionButton.small(
                                  heroTag: "btn1",
                                  onPressed: () {
                                    if (rating > 0.10) {
                                      setState(() {
                                        rating -= 0.1;
                                      });
                                    }
                                  },
                                  child: const Icon(
                                      Icons.remove_circle_outline),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 60,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                primary: Colors.red),
                            child: const Text(
                              "Add To Cart",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}

////////////////////////

