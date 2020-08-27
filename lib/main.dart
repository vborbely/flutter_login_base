import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_base/services/auth_services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

AuthServices authServices;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  authServices = AuthServices();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Authentication'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: authServices.authStream,
        builder: (context, snapshot) {
          final user = snapshot.data;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              (user != null) ? _profileWidget(user) : _googleLoginButton(),
              SizedBox(
                height: 20,
              ),
              (user != null)
                  ? _logoutButton(
                      onPressed: () async => await authServices.logoutWithGoogle(),
                    )
                  : Container()
            ],
          );
        },
      ),
    );
  }

  Widget _logoutButton({Function onPressed}) {
    return Center(
      child: RaisedButton(
        key: GlobalKey(),
        color: Colors.redAccent,
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: onPressed,
        child: Text(
          "LogOut",
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }

  Column _profileWidget(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipOval(
          child: Image.network(user.photoURL, scale: 1.0),
        ),
        Text(
          user.displayName,
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  RaisedButton _googleLoginButton() {
    return RaisedButton.icon(
      key: GlobalKey(),
      color: Colors.orange,
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        authServices.loginWithGoogle();
      },
      icon: Icon(FontAwesomeIcons.google),
      label: Text(
        "Login",
        style: TextStyle(fontSize: 25),
      ),
    );
  }
}
