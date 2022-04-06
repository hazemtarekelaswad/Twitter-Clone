import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:twitter/constants.dart';
import 'package:twitter/dummy/tweets_list.dart';
import 'package:twitter/dummy/users_data.dart';
import 'package:twitter/models/tweet_card_data.dart';
import 'package:twitter/screens/timeline_screen/timeline_components/timeline_bottom_bar.dart';
import 'package:twitter/screens/timeline_screen/timeline_components/tweet_card.dart';
import '../../widgets/custom_page_route.dart';
import '../add_tweet_screen/add_tweet_screen.dart';
import 'timeline_components/profile_picture.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'timeline_components/navigation_drawer.dart';
import 'package:twitter/models/tweet_card_data.dart';

// ignore_for_file: prefer_const_constructors
class TimelineScreen extends StatelessWidget {
  static const routeName = '/timeline-screen';
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            CustomPageRoute
            (child:ChangeNotifierProvider(
              create: (context)=>TweetsList(),
                child: AddTweetScreen()),beginX: 0,beginY: 1),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(
          FontAwesomeIcons.plus,
          size: 20,
        ),
      ),
      drawer:
          NavigationDrawer(), //to open profile content when user press the profile picture in the timeline appbar
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
              automaticallyImplyLeading: false,
              title: TextButton(
                onPressed: () {
                  //this makes when i press on the bar it goes to the first tweet in timeline
                  controller.animateTo(0.0,
                      curve: Curves.easeIn, duration: Duration(seconds: 1));
                },
                style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //profile picture in timeline appbar
                    ProfilePicture(
                      profilePictureFunctionality: () {
                        Scaffold.of(context).openDrawer();
                      },
                      profilePictureImage: UsersData.getMyData().profilePicture,
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
                      onTap: () {},
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
          //--------------------------------------------------------------------
          //tweets list viewer
          body: Scrollbar(
            radius: Radius.circular(30),
            isAlwaysShown: true,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                print(TweetsList.getTweetsList().length.toString());
                return TweetCard(index: index);
              },
              itemCount:TweetsList.getTweetsNumbers(),
            ),
          ),
        ),
      ),
      //------------------------------------------------------------------------
      //bottom appbar where each icon has its own function
      bottomNavigationBar: TimelineBottomBar(controller: controller),
    );
  }
}
