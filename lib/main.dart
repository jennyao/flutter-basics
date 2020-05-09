// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//Written Dart code.
//Used hot reload for a faster development cycle.
//Implemented a stateful widget, adding interactivity to your app.
//Created a route and added logic for moving between the home route and the new route.
//Learned about changing the look of your app's UI using themes.
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Basics',
      theme: ThemeData(
        primaryColor: Colors.amber,
        backgroundColor: Colors.black54,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => LoginScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) => MapScreen(),
      },
    );
  }
}

class LoginScreen extends StatelessWidget {

  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      obscureText: true,    //this makes it hidden as a password text field should behave
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButton = Material(
      elevation: 5.0,                                 //this adds a shadow to the button
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          Navigator.pushNamed(context, '/second');
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    //final GoogleSignInButton = Material(
    //  onPressed: () {/* ... */ },
    //  splashColor: Colors.white,
    //  //setting splashColor to Colors.transparent will remove button ripple effect
    //  //reference: https://pub.dev/packages/flutter_auth_buttons
    //);

    return Scaffold(  //Scaffold widget contains all widgets together by referencing them in here
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButton,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  //Location location;
  Future<LocationData> _locationData;

  @override
  void initState() {
    super.initState();
    _locationData = initializeLocation();
  }

  GoogleMapController mapController;

  Future<LocationData> initializeLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null; //TODO: Handle user refusal
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null; //TODO: Handle user refusal
      }
    }

    return await location.getLocation();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Map Screen"),
      ),
      body: FutureBuilder<LocationData>(
        future: _locationData,
        builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
          if (snapshot.hasData) {
            return GoogleMap(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(
                target: LatLng(snapshot.data.latitude, snapshot.data.longitude),
                zoom: 11.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error resolving user location data: ${snapshot.error}');
          } else {
            return Text('Loading...');
          }
        },
      ),
    );
  }
}