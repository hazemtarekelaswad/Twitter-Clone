import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:twitter/screens/settings_screen/settings_screen.dart';
import 'package:twitter/screens/timeline_screen/timeline_components/add_tweet_screen.dart';
import 'package:twitter/screens/timeline_screen/timeline_components/custom_page_route.dart';
import 'package:twitter/screens/timeline_screen/timeline_screen.dart';
import 'package:twitter/themes.dart';
import '../../constants.dart';
import '../../providers/notifications_provider.dart';
import '../timeline_screen/timeline_components/profile_picture.dart';
import '../timeline_screen/timeline_components/navigation_drawer.dart';
import 'package:twitter/screens/timeline_screen/timeline_components/timeline_bottom_bar.dart';

class NotificationsScreen extends StatefulWidget {
  static const routeName = '/notifications-screen';

  @override
  State<StatefulWidget> createState() {
    return NotificationsScreen_state();
  }
}

class NotificationsScreen_state extends State<NotificationsScreen> {
  final controller = ScrollController();

  fetchNotifications(BuildContext context) {
    final notificationsProvider =
        Provider.of<NotificationsProvider>(context, listen: false);

    notificationsProvider.fetch().then((res) {
      switch (res.statusCode) {
        case 200: // Success
          log('${res.body}');
          final response = jsonDecode(res.body);
          final jsonNotificationsList = response['notifications'];
          notificationsProvider.setNotificationsList(
              jsonNotificationsList, context);
          break;
        case 204: // User does not have notifications
          break;
        case 401: // Unauthorized
          break;
        case 404: // User id not found
          break;
        default: // Invalid status code

      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 1,
        child: Scaffold(
          drawer: NavigationDrawer(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                CustomPageRoute(
                  child: AddTweetScreen(
                      hintText: "What's happening?", tweetOrReply: "tweet"),
                  beginX: 0,
                  beginY: 1,
                ),
              );
            },
            backgroundColor: Colors.blue,
            child: const Icon(
              FontAwesomeIcons.plus,
              size: 20,
            ),
          ),
          body: SafeArea(
            child: NestedScrollView(
              controller: controller,
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                    floating: true,
                    pinned: true,
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    forceElevated: innerBoxIsScrolled,
                    shadowColor: Colors.white,
                    automaticallyImplyLeading: false,
                    title: TextButton(
                      onPressed: () {
                        controller.animateTo(0.0,
                            curve: Curves.easeIn,
                            duration: const Duration(seconds: 1));
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfilePicture(
                            profilePictureFunctionality: () {
                              Scaffold.of(context).openDrawer();
                            },
                            profilePictureImage:
                                Auth.profilePicUrl, // TODO: to be changed
                            profilePictureSize: 15,
                          ),
                          //twitter icon in the appbar
                          const Text(
                            'Notifications',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return SettingsScreen();
                                    },
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.settings,
                                color: Colors.grey,
                              )),
                          //sparkle icon in the appbar
                        ],
                      ),
                    )),
              ],
              body: Column(
                children: [
                  // construct the profile details widget here
                  // SizedBox(
                  //   height: 180,
                  //   child: Center(
                  //     child: Text(
                  //       'Profile Details Goes here',
                  //     ),
                  //   ),
                  // ),

                  // the tab bar with two items
                  SizedBox(
                    height: 50,
                    child: AppBar(
                      bottom: const TabBar(
                        labelColor: kOnPrimaryColor,
                        tabs: [
                          Tab(
                            text: 'All',
                          )
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: TabBarView(
                      children: [
                        // first tab bar view widget
                        Center(
                          child: Consumer<NotificationsProvider>(
                            builder: (context, val, child) =>
                                val.notificationsList.isEmpty
                                    ? const Text(
                                        'You don\'t have any notifications yet')
                                    : ListView.builder(
                                        itemCount: val.notificationsList.length,
                                        itemBuilder: (context, index) {
                                          return val.notificationsList[index];
                                        },
                                      ),
                          ),
                        ),

                        // second tab bar viiew widget
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: TimelineBottomBar(
            contextt: context,
            controller: controller,
            popTimeLine: true,
            popSearch: true,
            popNotifications: false,
          ),
        ));
  }
}
