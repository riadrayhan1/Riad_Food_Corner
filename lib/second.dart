import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebselogin5/third.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
class SecondClass extends StatelessWidget {

  const SecondClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
               // colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
              // image: AssetImage("images/loginn.jpg"),
                image: NetworkImage(
                    "https://png.pngtree.com/thumb_back/fh260/back_our/20190621/ourmid/pngtree-black-meat-western-food-banner-background-image_194600.jpg"),
                fit: BoxFit.contain,

                //colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.9), BlendMode.dstATop),
              ),
          ),
          child: Column(
            children: [

             Container(
                margin: EdgeInsets.only(top: 340),
               child:RaisedButton.icon( elevation: 4.0,
                   icon: Image.asset('images/image_upload.png' ,width: 20,height: 20,) ,
                   color: Theme.of(context).backgroundColor,
                   onPressed: () => signInWithGoogle(),
                   label: Text("Login with Google",style: TextStyle(
                       color: Colors.white, fontSize: 16.0))
               ),
               /* child: TextButton(

                  onPressed: ()=>signInWithGoogle(),
                  child: Text("Google login", style: TextStyle( backgroundColor: Colors.deepOrange, fontSize: 20,fontWeight: FontWeight.bold,color: Colors.cyanAccent),),
                ),*/
              ),
              Container(
                width: double.infinity,
               margin: EdgeInsets.only(top: 65),
               child: RaisedButton.icon( elevation: 4.0,
                   icon: Image.asset('images/skip.jpg' ,width: 30,height: 30,) ,
                   color: Colors.lightBlueAccent,
                   onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ThirdClass(),));
                   },
                   label: Text("Skip or Next",style: TextStyle(
                       color: Colors.white, fontSize: 16.0))
               ),
               /* child: TextButton(
                  onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (context) => ThirdClass(),)),
                  child: Text("Skip or Next...",style: TextStyle(backgroundColor: Colors.green, fontSize: 20,fontWeight: FontWeight.bold),),
                ),*/
              ),
            ],
          ),
        ),
    );
  }
}
Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
  final GoogleSignInAuthentication googleAuth = await googleuser!.authentication;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final
  OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken
  );
  Fluttertoast.showToast(msg: "Account created successfully...",
      toastLength: Toast.LENGTH_LONG,backgroundColor: Colors.deepPurple,fontSize: 20);
  return await FirebaseAuth.instance.signInWithCredential(credential);

}