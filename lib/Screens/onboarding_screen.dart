import "package:flutter/material.dart";

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  int _pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                      controller: _pageController,
                      itemCount: demoData.length,
                      onPageChanged: (index) {
                        setState(() {
                          _pageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) => OnboardContent(
                          image: demoData[index].image,
                          title: demoData[index].title,
                          description: demoData[index].description)),
                ),
                Row(
                  children: [
                    ...List.generate(
                        demoData.length,
                        (index) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: DotIndicator(
                                isActive: index == _pageIndex,
                              ),
                            )),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor:
                                  Color.fromARGB(255, 144, 124, 255)),
                          onPressed: () {
                            Navigator.pushNamed(context, "/registration");
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(fontSize: 10.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({super.key, this.isActive = false});
  final isActive;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: isActive ? 12 : 4,
      width: 4,
      decoration: BoxDecoration(
          color: isActive ? Color.fromARGB(255, 24, 58, 246) : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}

class OnBoard {
  final String image, title, description;
  OnBoard(
      {required this.image, required this.title, required this.description});
}

final List<OnBoard> demoData = [
  OnBoard(
      image: "assets/images/image1.png",
      title: "Find the item you have been looking for.",
      description:
          "Add any item you want to add to your cart or save it to your wishlist."),
  OnBoard(
      image: "assets/images/image2.png",
      title: "Find the item you have been looking for.",
      description:
          "Add any item you want to add to your cart or save it to your wishlist."),
  OnBoard(
      image: "assets/images/image3.png",
      title: "Find the item you have been looking for.",
      description:
          "Add any item you want to add to your cart or save it to your wishlist."),
  OnBoard(
      image: "assets/images/image4.png",
      title: "Find the item you have been looking for.",
      description:
          "Add any item you want to add to your cart or save it to your wishlist.")
];

class OnboardContent extends StatelessWidget {
  const OnboardContent(
      {super.key,
      required this.image,
      required this.title,
      required this.description});
  final String image, title, description;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          height: 150,
        ),
        Image.asset(
          image,
          height: 250.0,
        ),
        const SizedBox(height: 50),
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.w500, fontSize: 28.0),
        ),
        const SizedBox(
          height: 50,
        ),
        Text(
          description,
          textAlign: TextAlign.center,
        ),
        const Spacer()
      ],
    );
  }
}
