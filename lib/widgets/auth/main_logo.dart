import 'dart:math';

import 'package:flutter/material.dart';

class MainLogo extends StatelessWidget {
  const MainLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10.0),
            child: SizedBox(
              height: 150,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Transform.rotate(
                angle: 25 * pi / 180,
                child: ClipRRect(
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 50.0, left: 10.0),
            child: Text(
              'Line',
              style: TextStyle(
                  color: Color(
                    0xffF26351,
                  ),
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
