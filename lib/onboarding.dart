import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';
import 'package:passwordless_auth_flutter/registration.dart';

class OnboardingUI extends StatelessWidget {
  OnboardingUI({Key? key}) : super(key: key);
  
  final onBoardingPages = [
    PageModel(
      widget: Container(
        color: Colors.blue[700],
        child: Column(
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 45.0),
              child: Image.asset(
                'assets/images/woman-on-phone.png',
              )),
          Container(
              width: double.infinity,
              child: Text('Mobile Authentication, Reimagined.', textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30), )),
        ],
      ),
      ),
    ),
       PageModel(
      widget: Container(
        color: Colors.purpleAccent[700],
        child: Column(
        children: [
          Container(
              padding: EdgeInsets.only(bottom: 45.0),
              child: Image.asset(
                'assets/images/man-on-phone.png',
              )),
          Container(
              width: double.infinity,
              child: Text('Invisible. Effortless. Feels like magic!', textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30), )),
        ],
      ),
      )
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Onboarding(
          proceedButtonStyle: ProceedButtonStyle(
                proceedButtonRoute: (context) {
                  return Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Registration(),
                    ),
                    (route) => false,
                  );
                },
            ),
          isSkippable: true,
          pages: onBoardingPages,
          indicator: Indicator(
          indicatorDesign: IndicatorDesign.line(
            lineDesign: LineDesign(
              lineType: DesignType.line_uniform,
            ),)
      ),
    )));
  }
}
