import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityHandler {
  final BuildContext context;
  late bool isDeviceConnected;
  bool isAlertSet = false;
  late StreamSubscription<ConnectivityResult> subscription;

  ConnectivityHandler(this.context);

  void setupConnectivityListener() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && !isAlertSet) {
          _showDialogBox();
          isAlertSet = true;
        }
      },
    );
  }

  void dispose() {
    subscription.cancel();
  }

  void _showDialogBox() {
    showDialogBox(context);
  }

  void showDialogBox(BuildContext context) {
    // Your dialog box logic goes here
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('No Internet Connection'),
          content: Text('Please check your internet connection and try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
