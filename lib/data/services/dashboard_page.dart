import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:flutter_svg/svg.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  @override
  Widget build(BuildContext context) {
    // Figma Flutter Generator DashboardWidget - FRAME

    return Container(
      width: 414,
      height: 896,
      decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 1)),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 127,
            left: 0,
            child: Container(
              width: 414,
              height: 127,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.25),
                    offset: Offset(0, -5),
                    blurRadius: 20,
                  ),
                ],
                color: Color.fromRGBO(255, 215, 0, 1),
              ),
            ),
          ),
          Positioned(
            top: -51.585693359375,
            left: 77,
            child: Transform.rotate(
              angle: 7.684234386045833 * (math.pi / 180),
              child: Container(
                width: 160.1513214111328,
                height: 160.1513214111328,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(90),
                    topRight: Radius.circular(90),
                    bottomLeft: Radius.circular(90),
                    bottomRight: Radius.circular(90),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment(-0.8526691198348999, -0.6526016592979431),
                    end: Alignment(0.6526016592979431, -0.8526691198348999),
                    colors: [
                      Color.fromRGBO(255, 251, 25, 1),
                      Color.fromRGBO(248, 225, 95, 1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -79.23291015625,
            left: -23.8095703125,
            child: Transform.rotate(
              angle: -10.53576790048246 * (math.pi / 180),
              child: Container(
                width: 193.72999572753906,
                height: 193.72999572753906,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(112),
                    topRight: Radius.circular(112),
                    bottomLeft: Radius.circular(112),
                    bottomRight: Radius.circular(112),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment(0.3666907548904419, 1.0594208240509033),
                    end: Alignment(-1.0594208240509033, 0.3666907548904419),
                    colors: [
                      Color.fromRGBO(255, 251, 24, 1),
                      Color.fromRGBO(248, 225, 96, 1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -346.119140625,
            left: 69,
            child: Transform.rotate(
              angle: 8.2140865343321 * (math.pi / 180),
              child: Container(
                width: 160.1513214111328,
                height: 160.1513214111328,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(90),
                    topRight: Radius.circular(90),
                    bottomLeft: Radius.circular(90),
                    bottomRight: Radius.circular(90),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment(0.052619531750679016, 1.2849620580673218),
                    end: Alignment(-1.2849620580673218, 0.052619531750679016),
                    colors: [
                      Color.fromRGBO(255, 221, 122, 1),
                      Color.fromRGBO(255, 229, 92, 1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -338.3212890625,
            left: -56,
            child: Transform.rotate(
              angle: 8.2140865343321 * (math.pi / 180),
              child: Container(
                width: 193.72999572753906,
                height: 193.72999572753906,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(112),
                    topRight: Radius.circular(112),
                    bottomLeft: Radius.circular(112),
                    bottomRight: Radius.circular(112),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment(0.3666907548904419, 1.0594208240509033),
                    end: Alignment(-1.0594208240509033, 0.3666907548904419),
                    colors: [
                      Color.fromRGBO(255, 221, 122, 1),
                      Color.fromRGBO(255, 229, 92, 1),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            left: 16,
            child: SizedBox(
              width: 382,
              height: 14,

              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: SizedBox(
                      width: 33,
                      height: 14,

                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 0,
                            left: 0,
                            child: SizedBox(
                              width: 33,
                              height: 14,

                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Text(
                                      '9:00',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: Color.fromRGBO(0, 0, 0, 1),
                                        fontFamily: 'Product Sans',
                                        fontSize: 15,
                                        letterSpacing:
                                            0 /*percentages not used in flutter. defaulting to zero*/,
                                        fontWeight: FontWeight.normal,
                                        height: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 3,
                    left: 333,
                    child: SizedBox(
                      width: 49,
                      height: 11,

                      child: Stack(
                        children: <Widget>[
                          Positioned(top: 0, left: 0, child: Offstage()),
                          Positioned(
                            top: 0,
                            left: 15,
                            child: SizedBox(
                              width: 14,
                              height: 11,

                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 3.0224609375,
                                    left: 2.057389259338379,
                                    child: SvgPicture.asset(
                                      'assets/images/vector.svg',
                                      semanticsLabel: 'vector',
                                    ),
                                  ),
                                  Positioned(
                                    top: 6.0009765625,
                                    left: 4.083105564117432,
                                    child: SvgPicture.asset(
                                      'assets/images/vector.svg',
                                      semanticsLabel: 'vector',
                                    ),
                                  ),
                                  Positioned(
                                    top: 8.924072265625,
                                    left: 6.001611232757568,
                                    child: SvgPicture.asset(
                                      'assets/images/vector.svg',
                                      semanticsLabel: 'vector',
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: SvgPicture.asset(
                                      'assets/images/vector.svg',
                                      semanticsLabel: 'vector',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(top: 2, left: 33, child: Offstage()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 69,
            left: 378,
            child: Container(
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Notification1.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 384,
            left: 14,
            child: Text(
              'Latest Listed',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(30, 41, 59, 1),
                fontFamily: 'Work Sans',
                fontSize: 20,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 155,
            left: 14,
            child: Text(
              'Booking Requests',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(30, 41, 59, 1),
                fontFamily: 'Work Sans',
                fontSize: 20,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 391,
            left: 333,
            child: Text(
              'View All',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Work Sans',
                fontSize: 12,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1.1666666666666667,
              ),
            ),
          ),
          Positioned(
            top: 161,
            left: 333,
            child: Text(
              'View All',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Work Sans',
                fontSize: 12,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1.1666666666666667,
              ),
            ),
          ),
          Positioned(
            top: 391,
            left: 384,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: Color.fromRGBO(30, 41, 59, 1),
                borderRadius: BorderRadius.all(Radius.elliptical(14, 14)),
              ),
            ),
          ),
          Positioned(
            top: 390,
            left: 383,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Rightarrow.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 160,
            left: 383,
            child: SizedBox(
              width: 16,
              height: 16,

              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 1,
                    left: 1,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(30, 41, 59, 1),
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(14, 14),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Rightarrow.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 424,
            left: 16,
            child: Container(
              width: 382,
              height: 131,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.20000000298023224),
                    offset: Offset(0, 1),
                    blurRadius: 4,
                  ),
                ],
                color: Color.fromRGBO(255, 255, 214, 0.18000000715255737),
                border: Border.all(
                  color: Color.fromRGBO(255, 215, 0, 1),
                  width: 0.5,
                ),
              ),
            ),
          ),
          Positioned(
            top: 523,
            left: 327,
            child: SizedBox(
              width: 57,
              height: 19,

              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 57,
                      height: 19,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(1.836734652519226),
                          topRight: Radius.circular(1.836734652519226),
                          bottomLeft: Radius.circular(1.836734652519226),
                          bottomRight: Radius.circular(1.836734652519226),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment(-2.509491139335296e-7, 1),
                          end: Alignment(
                            -13.838399887084961,
                            -2.0620871055143652e-7,
                          ),
                          colors: [
                            Color.fromRGBO(255, 215, 0, 1),
                            Color.fromRGBO(255, 193, 7, 1),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5.000244140625,
                    left: 6,
                    child: SizedBox(
                      width: 46.00072479248047,
                      height: 9.60279655456543,

                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 0.000054232048569247127,
                            left: 1.8189894035458565e-12,
                            child: Text(
                              'Check Out',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color.fromRGBO(30, 41, 59, 1),
                                fontFamily: 'Mulish',
                                fontSize: 8,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 2.821916341781616,
                            left: 40.12085723876953,
                            child: SizedBox(
                              width: 5.879631519317627,
                              height: 5.879631519317627,

                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 0.36737194657325745,
                                    left: 0.3662829101085663,
                                    child: Container(
                                      width: 5.144676685333252,
                                      height: 5.144676685333252,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(30, 41, 59, 1),
                                        borderRadius: BorderRadius.all(
                                          Radius.elliptical(
                                            5.144676685333252,
                                            5.144676685333252,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -0.00010504218516871333,
                                    left: -0.00023710401728749275,
                                    child: Container(
                                      width: 5.879631519317627,
                                      height: 5.879631519317627,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/images/Rightarrow.png',
                                          ),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 572,
            left: 16,
            child: Container(
              width: 382,
              height: 131,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.20000000298023224),
                    offset: Offset(0, 1),
                    blurRadius: 4,
                  ),
                ],
                color: Color.fromRGBO(255, 255, 214, 0.18000000715255737),
                border: Border.all(
                  color: Color.fromRGBO(255, 215, 0, 1),
                  width: 0.5,
                ),
              ),
            ),
          ),
          Positioned(
            top: 673,
            left: 232,
            child: SizedBox(
              width: 59,
              height: 10.555536270141602,

              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 1.8189894035458565e-12,
                    left: 0.00015419407282024622,
                    child: Offstage(),
                  ),
                  Positioned(
                    top: -1.8189894035458565e-12,
                    left: 12.111329078674316,
                    child: Offstage(),
                  ),
                  Positioned(
                    top: -1.8189894035458565e-12,
                    left: 24.222658157348633,
                    child: Offstage(),
                  ),
                  Positioned(
                    top: -1.8189894035458565e-12,
                    left: 36.333251953125,
                    child: Offstage(),
                  ),
                  Positioned(
                    top: -1.8189894035458565e-12,
                    left: 48.44446563720703,
                    child: Offstage(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 671,
            left: 327,
            child: SizedBox(
              width: 57,
              height: 19,

              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: 57,
                      height: 19,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(1.836734652519226),
                          topRight: Radius.circular(1.836734652519226),
                          bottomLeft: Radius.circular(1.836734652519226),
                          bottomRight: Radius.circular(1.836734652519226),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment(-2.509491139335296e-7, 1),
                          end: Alignment(
                            -13.838399887084961,
                            -2.0620871055143652e-7,
                          ),
                          colors: [
                            Color.fromRGBO(255, 215, 0, 1),
                            Color.fromRGBO(255, 193, 7, 1),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5.000244140625,
                    left: 6,
                    child: SizedBox(
                      width: 46.00072479248047,
                      height: 9.60279655456543,

                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: 0.000054232048569247127,
                            left: 1.8189894035458565e-12,
                            child: Text(
                              'Check Out',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Color.fromRGBO(30, 41, 59, 1),
                                fontFamily: 'Mulish',
                                fontSize: 8,
                                letterSpacing:
                                    0 /*percentages not used in flutter. defaulting to zero*/,
                                fontWeight: FontWeight.normal,
                                height: 1,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 2.821916341781616,
                            left: 40.12085723876953,
                            child: SizedBox(
                              width: 5.879631519317627,
                              height: 5.879631519317627,

                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 0.36737194657325745,
                                    left: 0.3662829101085663,
                                    child: Container(
                                      width: 5.144676685333252,
                                      height: 5.144676685333252,
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(30, 41, 59, 1),
                                        borderRadius: BorderRadius.all(
                                          Radius.elliptical(
                                            5.144676685333252,
                                            5.144676685333252,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -0.00010504218516871333,
                                    left: -0.00023710401728749275,
                                    child: Container(
                                      width: 5.879631519317627,
                                      height: 5.879631519317627,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/images/Rightarrow.png',
                                          ),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 593,
            left: 300,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Verified2.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 471,
            left: 158,
            child: Text(
              'Basement Slot 5, L-324-',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(30, 41, 59, 1),
                fontFamily: 'Work Sans',
                fontSize: 14,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 619,
            left: 158,
            child: Text(
              'Plot No. 12, Green Avenue, L-158-',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(30, 41, 59, 1),
                fontFamily: 'Work Sans',
                fontSize: 14,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 523,
            left: 145,
            child: Text(
              'For Sale',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(30, 41, 59, 1),
                fontFamily: 'Work Sans',
                fontSize: 12,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 671,
            left: 144,
            child: Text(
              'For Rent, Sale',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(30, 41, 59, 1),
                fontFamily: 'Work Sans',
                fontSize: 12,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 498,
            left: 144,
            child: Text(
              'Suitable for Normal Car',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Work Sans',
                fontSize: 14,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 646,
            left: 144,
            child: Text(
              'Suitable for SEDAN',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Work Sans',
                fontSize: 14,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 473,
            left: 145,
            child: Container(
              width: 11,
              height: 12,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Email.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 621,
            left: 145,
            child: Container(
              width: 11,
              height: 12,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Email.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 439,
            left: 144,
            child: Text(
              'C4-1007, Royal',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Work Sans',
                fontSize: 20,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 589,
            left: 143,
            child: Text(
              'D5-9005, Green',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Work Sans',
                fontSize: 20,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 439,
            left: 336,
            child: Text(
              '₹500',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(30, 41, 59, 1),
                fontFamily: 'Work Sans',
                fontSize: 20,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 587,
            left: 336,
            child: Text(
              '₹200',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(30, 41, 59, 1),
                fontFamily: 'Work Sans',
                fontSize: 20,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 439,
            left: 32,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/Rectangle320.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 587,
            left: 32,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/Rectangle322.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 732,
            left: 15,
            child: Text(
              'Start Today',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Mulish',
                fontSize: 25,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 770,
            left: 15,
            child: Text(
              '- Every space has value, make yours Count.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(140, 140, 140, 1),
                fontFamily: 'Work Sans',
                fontSize: 14,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(top: 825.8408203125, left: -0.25, child: Offstage()),
          Positioned(
            top: 832,
            left: 50,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Email.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 832,
            left: 345,
            child: Container(
              width: 20,
              height: 24,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Email.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 861,
            left: 148,
            child: Text(
              'List Parking Spot',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Work Sans',
                fontSize: 14,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 861,
            left: 42,
            child: Text(
              'Home',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Work Sans',
                fontSize: 14,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 861,
            left: 332,
            child: Text(
              'Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Work Sans',
                fontSize: 14,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 808,
            left: 189,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 215, 0, 1),
                borderRadius: BorderRadius.all(Radius.elliptical(36, 36)),
              ),
            ),
          ),
          Positioned(
            top: 818,
            left: 199,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Plus1.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 739,
            left: 161,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Growthchart1.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 314,
            left: 16,
            child: Container(
              width: 92,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                gradient: LinearGradient(
                  begin: Alignment(-5.018970341552631e-7, 2),
                  end: Alignment(-27.676799774169922, -4.1241742110287305e-7),
                  colors: [
                    Color.fromRGBO(30, 41, 59, 1),
                    Color.fromRGBO(17, 24, 39, 1),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 326,
            left: 28,
            child: Container(
              width: 19,
              height: 19,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Panel1.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 328,
            left: 51,
            child: Text(
              'Filters',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(251, 252, 247, 1),
                fontFamily: 'Mulish',
                fontSize: 16,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 0.875,
              ),
            ),
          ),
          Positioned(
            top: 314,
            left: 121,
            child: Container(
              width: 84,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                color: Color.fromRGBO(255, 255, 214, 0.18000000715255737),
                border: Border.all(
                  color: Color.fromRGBO(255, 215, 0, 1),
                  width: 0.5,
                ),
              ),
            ),
          ),
          Positioned(
            top: 314,
            left: 218,
            child: Container(
              width: 84,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                color: Color.fromRGBO(255, 255, 214, 0.18000000715255737),
                border: Border.all(
                  color: Color.fromRGBO(255, 215, 0, 1),
                  width: 0.5,
                ),
              ),
            ),
          ),
          Positioned(
            top: 329,
            left: 224,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Panel5.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 328,
            left: 238,
            child: Text(
              'Distance',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Mulish',
                fontSize: 14,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 314,
            left: 314,
            child: Container(
              width: 84,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                color: Color.fromRGBO(255, 255, 214, 0.18000000715255737),
                border: Border.all(
                  color: Color.fromRGBO(255, 215, 0, 1),
                  width: 0.5,
                ),
              ),
            ),
          ),
          Positioned(
            top: 329,
            left: 139,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Panel2.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 329,
            left: 321,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Panel4.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 328,
            left: 153,
            child: Text(
              'Price',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Mulish',
                fontSize: 14,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 328,
            left: 334,
            child: Text(
              'Location',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Mulish',
                fontSize: 14,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 442,
            left: 290,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Verified1.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 53,
            left: 14,
            child: Text(
              'Hey Adam,',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Mulish',
                fontSize: 25,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 90,
            left: 16,
            child: SizedBox(
              width: 186.625,
              height: 18,

              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 17,
                    child: Text(
                      'Mg Road, Street 129',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromRGBO(30, 41, 59, 1),
                        fontFamily: 'Work Sans',
                        fontSize: 15.749999046325684,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2.25,
                    left: 0,
                    child: Container(
                      width: 12.26249885559082,
                      height: 13.625,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Email.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 3.375,
                    left: 175.375,
                    child: Container(
                      width: 11.25,
                      height: 11.25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Email.png'),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 190,
            left: 16,
            child: Container(
              width: 169,
              height: 92.31092071533203,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.201680183410645),
                  topRight: Radius.circular(14.201680183410645),
                  bottomLeft: Radius.circular(14.201680183410645),
                  bottomRight: Radius.circular(14.201680183410645),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.20000000298023224),
                    offset: Offset(0, 1.4201680421829224),
                    blurRadius: 5.6806721687316895,
                  ),
                ],
                color: Color.fromRGBO(255, 255, 214, 1),
                border: Border.all(
                  color: Color.fromRGBO(255, 215, 0, 1),
                  width: 1,
                ),
              ),
            ),
          ),
          Positioned(
            top: 190,
            left: 197,
            child: Container(
              width: 169,
              height: 92.31092071533203,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.201680183410645),
                  topRight: Radius.circular(14.201680183410645),
                  bottomLeft: Radius.circular(14.201680183410645),
                  bottomRight: Radius.circular(14.201680183410645),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.20000000298023224),
                    offset: Offset(0, 1.4201680421829224),
                    blurRadius: 5.6806721687316895,
                  ),
                ],
                color: Color.fromRGBO(255, 255, 214, 0.18000000715255737),
                border: Border.all(
                  color: Color.fromRGBO(255, 215, 0, 1),
                  width: 0.7100840210914612,
                ),
              ),
            ),
          ),
          Positioned(
            top: 190,
            left: 378,
            child: Container(
              width: 20,
              height: 92,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.201680183410645),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(14.201680183410645),
                  bottomRight: Radius.circular(0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.20000000298023224),
                    offset: Offset(0, 1.4201680421829224),
                    blurRadius: 5.6806721687316895,
                  ),
                ],
                color: Color.fromRGBO(255, 255, 214, 0.18000000715255737),
                border: Border.all(
                  color: Color.fromRGBO(255, 215, 0, 1),
                  width: 0.7100840210914612,
                ),
              ),
            ),
          ),
          Positioned(
            top: 258.5888671875,
            left: 160.8564453125,
            child: Container(
              width: 11.361344337463379,
              height: 11.361344337463379,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Rightarrow.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 258.5888671875,
            left: 341.8564453125,
            child: Container(
              width: 11.361344337463379,
              height: 11.361344337463379,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Rightarrow.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 239.7056427001953,
            left: 27.361610412597656,
            child: Container(
              width: 10.0831937789917,
              height: 11.203548431396484,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Email.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 239.7060546875,
            left: 208.361328125,
            child: Container(
              width: 10.0831937789917,
              height: 11.203548431396484,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Email.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 239.7060546875,
            left: 389.361328125,
            child: Container(
              width: 10.0831937789917,
              height: 11.203548431396484,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Email.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 205.6220703125,
            left: 68.966796875,
            child: Text(
              'Arav',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Mulish',
                fontSize: 19.882352828979492,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 205.6220703125,
            left: 249.966796875,
            child: Text(
              'Muskan',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Mulish',
                fontSize: 19.882352828979492,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            ),
          ),
          Positioned(
            top: 235.44541931152344,
            left: 41.56336975097656,
            child: Text(
              'Green Road, Street2',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Mulish',
                fontSize: 11.361344337463379,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1.7500000209850677,
              ),
            ),
          ),
          Positioned(
            top: 235.4453125,
            left: 223.5634765625,
            child: Text(
              'Street 9, park lane',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 1),
                fontFamily: 'Mulish',
                fontSize: 11.361344337463379,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 1.7500000209850677,
              ),
            ),
          ),
          Positioned(
            top: 255.32748413085938,
            left: 27.361610412597656,
            child: Text(
              '20 July, 2025',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 0.7799999713897705),
                fontFamily: 'Work Sans',
                fontSize: 8.521008491516113,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 2.1538459472239553,
              ),
            ),
          ),
          Positioned(
            top: 255.3271484375,
            left: 208,
            child: Text(
              '15 Aug, 2025',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 0.7799999713897705),
                fontFamily: 'Work Sans',
                fontSize: 8.521008491516113,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 2.1538459472239553,
              ),
            ),
          ),
          Positioned(
            top: 255.3271484375,
            left: 389.361328125,
            child: Text(
              '20 ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 0.7799999713897705),
                fontFamily: 'Work Sans',
                fontSize: 8.521008491516113,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 2.1538459472239553,
              ),
            ),
          ),
          Positioned(
            top: 255.32748413085938,
            left: 85.5887222290039,
            child: Text(
              'to',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 0.7799999713897705),
                fontFamily: 'Work Sans',
                fontSize: 8.521008491516113,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 2.1538459472239553,
              ),
            ),
          ),
          Positioned(
            top: 255.3271484375,
            left: 264.2275390625,
            child: Text(
              'to',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 0.7799999713897705),
                fontFamily: 'Work Sans',
                fontSize: 8.521008491516113,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 2.1538459472239553,
              ),
            ),
          ),
          Positioned(
            top: 255.32748413085938,
            left: 98.36939239501953,
            child: Text(
              '20 July, 2026',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 0.7799999713897705),
                fontFamily: 'Work Sans',
                fontSize: 8.521008491516113,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 2.1538459472239553,
              ),
            ),
          ),
          Positioned(
            top: 255,
            left: 277.638671875,
            child: Text(
              '30 Aug, 2027',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(17, 24, 39, 0.7799999713897705),
                fontFamily: 'Work Sans',
                fontSize: 8.521008491516113,
                letterSpacing:
                    0 /*percentages not used in flutter. defaulting to zero*/,
                fontWeight: FontWeight.normal,
                height: 2.1538459472239553,
              ),
            ),
          ),
          Positioned(
            top: 198.52145385742188,
            left: 27.361610412597656,
            child: Container(
              width: 32.66386413574219,
              height: 32.66386413574219,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(61.06722640991211),
                  topRight: Radius.circular(61.06722640991211),
                  bottomLeft: Radius.circular(61.06722640991211),
                  bottomRight: Radius.circular(61.06722640991211),
                ),
                border: Border.all(
                  color: Color.fromRGBO(17, 24, 39, 1),
                  width: 0.42605045437812805,
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/Frame5.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Stack(children: <Widget>[
          
        ]
      ),
            ),
          ),
          Positioned(
            top: 198.521484375,
            left: 208.361328125,
            child: Container(
              width: 32.66386413574219,
              height: 32.66386413574219,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(61.06722640991211),
                  topRight: Radius.circular(61.06722640991211),
                  bottomLeft: Radius.circular(61.06722640991211),
                  bottomRight: Radius.circular(61.06722640991211),
                ),
                color: Color.fromRGBO(254, 215, 14, 1),
                border: Border.all(
                  color: Color.fromRGBO(17, 24, 39, 1),
                  width: 0.42605045437812805,
                ),
              ),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 26.478515625,
                    left: 5.638671875,
                    child: Container(
                      width: 22,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(248, 188, 40, 1),
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(22, 3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 222.6634979248047,
            left: 50.08332824707031,
            child: SizedBox(
              width: 9.941176414489746,
              height: 9.941176414489746,

              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -0.00007742972229607403,
                    left: 0.00007526681292802095,
                    child: SizedBox(
                      width: 9.941176414489746,
                      height: 9.941176414489746,

                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: -0.00007742972229607403,
                            left: 0.00007526682747993618,
                            child: Container(
                              width: 9.912516593933105,
                              height: 9.912516593933105,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 252, 247, 1),
                                borderRadius: BorderRadius.all(
                                  Radius.elliptical(
                                    9.912516593933105,
                                    9.912516593933105,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -0.00007742972229607403,
                            left: 0.00007526682747993618,
                            child: Container(
                              width: 9.941176414489746,
                              height: 9.941176414489746,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/Verified1.png',
                                  ),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 222.663818359375,
            left: 412.083984375,
            child: SizedBox(
              width: 9.941176414489746,
              height: 9.941176414489746,

              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -0.00007742972229607403,
                    left: -0.00016887379752006382,
                    child: SizedBox(
                      width: 9.941176414489746,
                      height: 9.941176414489746,

                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: -0.00007742972229607403,
                            left: -0.00016887379752006382,
                            child: Container(
                              width: 9.912516593933105,
                              height: 9.912516593933105,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 252, 247, 1),
                                borderRadius: BorderRadius.all(
                                  Radius.elliptical(
                                    9.912516593933105,
                                    9.912516593933105,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -0.00007742972229607403,
                            left: -0.00016887379752006382,
                            child: Container(
                              width: 9.941176414489746,
                              height: 9.941176414489746,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/Verified1.png',
                                  ),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 198.521484375,
            left: 389.361328125,
            child: Container(
              width: 32.66386413574219,
              height: 32.66386413574219,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(61.06722640991211),
                  topRight: Radius.circular(61.06722640991211),
                  bottomLeft: Radius.circular(61.06722640991211),
                  bottomRight: Radius.circular(61.06722640991211),
                ),
                border: Border.all(
                  color: Color.fromRGBO(17, 24, 39, 1),
                  width: 0.42605045437812805,
                ),
                image: DecorationImage(
                  image: AssetImage('assets/images/Frame7.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Stack(children: <Widget>[
          
        ]
      ),
            ),
          ),
          Positioned(
            top: 151,
            left: 398,
            child: Container(
              width: 16,
              height: 146,
              decoration: BoxDecoration(
                color: Color.fromRGBO(251, 252, 247, 1),
              ),
            ),
          ),
          Positioned(
            top: 201,
            left: 210,
            child: Container(
              width: 30,
              height: 25,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/8b97e42139d24295854fd194e06a99fcremovebgpreview1.png',
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: 222.663818359375,
            left: 231.083984375,
            child: SizedBox(
              width: 9.941176414489746,
              height: 9.941176414489746,

              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -0.00007742972229607403,
                    left: -0.00016887379752006382,
                    child: SizedBox(
                      width: 9.941176414489746,
                      height: 9.941176414489746,

                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            top: -0.00007742972229607403,
                            left: -0.00016887379752006382,
                            child: Container(
                              width: 9.912516593933105,
                              height: 9.912516593933105,
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(251, 252, 247, 1),
                                borderRadius: BorderRadius.all(
                                  Radius.elliptical(
                                    9.912516593933105,
                                    9.912516593933105,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: -0.00007742972229607403,
                            left: -0.00016887379752006382,
                            child: Container(
                              width: 9.941176414489746,
                              height: 9.941176414489746,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/Verified1.png',
                                  ),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 525,
            left: 198,
            child: SizedBox(
              width: 59,
              height: 10.555536270141602,

              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 1.8189894035458565e-12,
                    left: 0.00015419407282024622,
                    child: Offstage(),
                  ),
                  Positioned(
                    top: -1.8189894035458565e-12,
                    left: 12.111329078674316,
                    child: Offstage(),
                  ),
                  Positioned(
                    top: -1.8189894035458565e-12,
                    left: 24.222658157348633,
                    child: Offstage(),
                  ),
                  Positioned(
                    top: -1.8189894035458565e-12,
                    left: 36.333251953125,
                    child: Offstage(),
                  ),
                  Positioned(
                    top: -1.8189894035458565e-12,
                    left: 48.44446563720703,
                    child: Offstage(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
