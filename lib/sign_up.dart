import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterauthbundle/auth_service/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutterauthbundle/email_auth/login_page.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = new GlobalKey<FormState>();
  String phoneNo, verificationId, smsCode;
  bool codeSent = false;

  //Google Sign In
  GoogleSignIn _googleSignIn = new GoogleSignIn();

  //Facebook Sign In
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Form(
            key: formKey,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration:
                          InputDecoration(hintText: 'Enter phone number'),
                      onChanged: (val) {
                        setState(() {
                          this.phoneNo = val;
                        });
                      },
                    )),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: SizedBox(
                      height: 50,
                      child: RaisedButton(
                          color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.phoneSquareAlt,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Verify Phone',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          onPressed: () {
                            verifyPhone(phoneNo);
                          }),
                    )),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: SizedBox(
                      height: 50,
                      child: RaisedButton(
                          color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.userCircle,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Sign in as Guest',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          onPressed: () {
                            FirebaseAuth.instance
                                .signInAnonymously()
                                .then((user) {
                              AuthService().handleAuth();
                            }).catchError((e) {
                              print(e);
                            });
                          }),
                    )),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: SizedBox(
                      height: 50,
                      child: RaisedButton(
                          color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Sign in Google',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          onPressed: () {
                            // Sign In Google
                            googleSignIn();
                          }),
                    )),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: SizedBox(
                      height: 50,
                      child: RaisedButton(
                          color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.facebook,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Sign in Facebook',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          onPressed: () {
                            // Sign In Facebook
                            _facebookSignIn();
                          }),
                    )),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 30.0, right: 30.0),
                    child: SizedBox(
                      height: 50,
                      child: RaisedButton(
                          color: Colors.blue,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Sign in Email & Password',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                          onPressed: () {
                            // Sign In Email and Password
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage()),
                            );
                          }),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> googleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      AuthService().handleAuth();
    }).catchError((e) {
      print(e);
    });
  }

  String _message = 'Log in/out by pressing the buttons below.';

  Future<Null> _facebookSignIn() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    AuthCredential credential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token);

    await FirebaseAuth.instance.signInWithCredential(credential).then((value) {
      AuthService().handleAuth();
    }).catchError((e) {
      print(e);
    });

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        _showMessage('''
         Logged in!
         
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      FirebaseAuth.instance.signInWithCredential(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
