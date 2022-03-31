import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:twitter/constants.dart';
import 'timeline_components/profile_picture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore_for_file: prefer_const_constructors
class Timeline extends StatelessWidget {
  static const routeName = 'timeline-screen';
  List<String> test = [
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'hello',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
    'a7a',
  ];
    final controller=ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //here i make twitter own app bar which appears and disappears depending on user scrolling
      body: SafeArea(
        child: NestedScrollView(
          controller: controller,
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              //floating is true to make twitter app bar to appear when scroll up,
              floating: true,
              snap: false,
              centerTitle: true,
              backgroundColor: Colors.white,
              forceElevated: innerBoxIsScrolled,
              shadowColor: Colors.white,
              title: TextButton(
                onPressed: ()
                {
                  //this makes when i press on the bar it goes to the first tweet in timeline
                  controller.animateTo(0.0, curve: Curves.easeIn, duration: Duration(seconds: 1));
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //profile picture in timeline appbar
                    ProfilePicture(
                      profilePictureFunctionality: ()
                          {

                          },
                      profilePicturePath: myProfilePicturePath,
                      profilePictureSize: timelineProfilePicSize,
                    ),
                    //twitter icon in the appbar
                    SvgPicture.asset(
                      kLogoPath,
                      width: 20,
                      height: 20,
                      color: Colors.lightBlue,
                    ),
                    //sparkle icon in the appbar
                    GestureDetector(
                      onTap: ()
                      {

                      },
                      child: FaIcon(
                        Icons.star_outline_sharp,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
          body: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 18),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(test[index]),
              );
            },
            itemCount: test.length,
          ),
        ),
      ),
    );
  }
}


