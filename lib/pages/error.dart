import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
              backgroundColor: Colors.white,
              radius: 80.0,
              backgroundImage: AssetImage('assets/lego/063-batman.png')),
          SizedBox(height: 30.0),
          Text('Something went wrong!',
              style: TextStyle(
                color: Colors.white,
                  fontSize: 22.0,
                  decoration: TextDecoration.none,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
