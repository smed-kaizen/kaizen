import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Kaizen',
              style: TextStyle(
                color: Color.fromRGBO(228, 92, 67, 1),
                shadows: [Shadow(
                  color: Colors.black,
                  blurRadius: 20
                )],
                fontFamily: "YujiBoku",
                fontSize: 60,
                fontWeight: FontWeight.normal,
                letterSpacing: -3
              ),
            ),
            SpinKitChasingDots(
              color: Color.fromRGBO(253, 247, 213, 0.3),
              duration: Duration(milliseconds: 1200),
              size: 30,
            )
          ],
        )
      ),
    );
  }
}
