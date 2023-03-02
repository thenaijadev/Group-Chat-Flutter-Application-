import 'package:flutter/material.dart';
import '../Components/onboardingPage.dart';
import 'package:go_router/go_router.dart';
import "package:smooth_page_indicator/smooth_page_indicator.dart";

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isOnLastpage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          onPageChanged: (value) {
            setState(() {
              if (value == 2) {
                isOnLastpage = true;
              } else {
                isOnLastpage = false;
              }
            });
          },
          controller: _controller,
          children: const [
            OnboardingPage(
              lottie: "assets/lottie/chat-animation.json",
              title: "Seamless direct messaging.",
            ),
            OnboardingPage(
              lottie: "assets/lottie/chat_2.json",
              title: "Make plans, reach out to friends and family",
            ),
            OnboardingPage(
              lottie: "assets/lottie/chat.json",
              title: "Direct messaging at your finger tips",
            ),
          ],
        ),
        Container(
          alignment: const Alignment(0, 0.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              !isOnLastpage
                  ? GestureDetector(
                      onTap: () => {
                        _controller.animateTo(800,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.bounceInOut)
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
                        child: Text(
                          "skip",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : const Text(""),
              SmoothPageIndicator(
                onDotClicked: (index) => {
                  _controller.animateToPage(index,
                      duration: const Duration(
                        microseconds: 300,
                      ),
                      curve: Curves.bounceInOut)
                },
                controller: _controller, // PageController
                count: 3,
                effect: const ExpandingDotsEffect(
                  activeDotColor: Color.fromARGB(255, 98, 71, 230),
                ), // your preferred effect
              ),
              isOnLastpage
                  ? GestureDetector(
                      onTap: () => {context.go("/registration")},
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19.0),
                            color: const Color.fromARGB(255, 98, 71, 230),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: Text(
                              "Done",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),
                    )
                  : GestureDetector(
                      onTap: () => {
                        _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn)
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(19.0),
                            color: const Color.fromARGB(255, 98, 71, 230),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20),
                            child: Text(
                              "Next",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          )),
                    ),
            ],
          ),
        ),
      ]),
    );
  }
}
