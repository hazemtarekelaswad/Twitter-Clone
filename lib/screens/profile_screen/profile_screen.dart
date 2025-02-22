import 'dart:developer';

import 'package:custom_nested_scroll_view/custom_nested_scroll_view.dart';
import 'package:provider/provider.dart';
import 'package:twitter/models/small_user_model.dart';
import 'package:twitter/screens/search_screen/SearchScreen.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter/constants.dart';
import 'package:twitter/dummy/users_data.dart';
import 'package:twitter/screens/timeline_screen/timeline_screen.dart';
import '../../models/user_model.dart';
import '../../providers/timeline_provider.dart';
import '../../providers/tweets_view_model.dart';
import '../../providers/user_provider.dart';
import '../../themes.dart';
import '../timeline_screen/timeline_components/profile_picture.dart';
import 'package:twitter/screens/profile_screen/edit_profile_screen.dart';
import 'package:twitter/screens/timeline_screen/timeline_components/timeline_bottom_bar.dart';

import '../timeline_screen/timeline_components/tweet_card.dart';

// hazemId: 62686629137ec6c6db13b245
// mohamedId: 626551f44d5786f437cbb25b
// gilany: 626894b7137ec6c6db13b24a

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';
  // String userId = '626551f44d5786f437cbb25b';
  String userId;
  ProfileScreen({required this.userId});

  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  var top = 0.0;
  dynamic videoPlayerController;

  double getOffset() {
    double o;
    if (_scrollController.hasClients) {
      o = _scrollController.offset;
    } else {
      o = 0.0;
    }
    return o;
  }

  late Future<User> user;
  late ScrollController _scrollController;

  late TabController _tabController =
      TabController(initialIndex: 0, length: 4, vsync: this);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    _scrollController = ScrollController();
    user = Provider.of<UserProvider>(context, listen: false)
        .fetchUserByUserId(widget.userId);

    _scrollController.addListener(() {
      setState(() {});
    });
  }

  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      bottomNavigationBar: TimelineBottomBar(
        controller: controller,
        popTimeLine: true,
        popSearch: true,
        popNotifications: true,
        contextt: context,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue,
        child: const Icon(
          FontAwesomeIcons.plus,
          size: 20,
        ),
      ),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
          future: user,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data == null) return const CircularLoader();
            return SafeArea(
              child: Stack(
                children: [
                  DefaultTabController(
                    length: 4,
                    child: CustomNestedScrollView(
                        physics: const BouncingScrollPhysics(),
                        overscrollType: CustomOverscroll.outer,
                        controller: _scrollController,
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            SliverAppBar(
                              stretch: true,
                              elevation: 0,
                              expandedHeight: 120,
                              collapsedHeight: 80,
                              backgroundColor: Colors.black,
                              leading: Container(
                                height: 90,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return TimelineScreen(
                                            firstTime: false,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder(),
                                    maximumSize: const Size(30, 30),
                                    minimumSize: const Size(30, 30),

                                    padding: const EdgeInsets.all(0),
                                    primary: Colors.black
                                        .withOpacity(0.5), // <-- Button color
                                    onPrimary: Colors.blue, // <-- Splash color
                                  ),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              actions: [
                                Container(
                                  height: 90,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return SearchScreen();
                                          },
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      maximumSize: const Size(30, 30),
                                      minimumSize: const Size(30, 30),

                                      padding: const EdgeInsets.all(0),
                                      primary: Colors.black
                                          .withOpacity(0.5), // <-- Button color
                                      onPrimary:
                                          Colors.blue, // <-- Splash color
                                    ),
                                    child: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                              pinned: true,
                              flexibleSpace: LayoutBuilder(
                                builder: (context, constraints) {
                                  top = constraints.biggest.height;
                                  return FlexibleSpaceBar(
                                    stretchModes: const [
                                      StretchMode.blurBackground,
                                      StretchMode.zoomBackground,
                                    ],
                                    centerTitle: true,
                                    title: AnimatedOpacity(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        opacity: top <= 100 ? 1.0 : 0.0,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              snapshot.data.name,
                                              style: header_titleName,
                                            ),
                                            Text(
                                              snapshot.data.tweetCount
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: AppColor.white),
                                            ),
                                          ],
                                        )),
                                    background: Stack(
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          child: Image.network(
                                            snapshot.data.coverPicUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Container(
                                transform: Matrix4.translationValues(0, -20, 0),
                                width: double.infinity,
                                color: Colors.green[600],
                                child: Container(
                                  color: Colors.white,
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Transform(
                                            transform: Matrix4.identity()
                                              ..scale(
                                                  getOffset() < 35 ? 0.0 : 0.7),
                                            alignment: Alignment.bottomCenter,
                                            child: CircleAvatar(
                                              radius: 45,
                                              backgroundColor: AppColor.white,
                                              child: CircleAvatar(
                                                radius: 40,
                                                child: ProfilePicture(
                                                  profilePictureFunctionality:
                                                      () {
                                                    Scaffold.of(context)
                                                        .openDrawer();
                                                  },
                                                  profilePictureImage: snapshot
                                                      .data.profilePicUrl,
                                                  profilePictureSize: 40,
                                                ),
                                              ),
                                            ),
                                          ),
                                          //! Follow BUTTON
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  EditProfileScreen.routeName);
                                            },
                                            child: Container(
                                              width: 100,
                                              height: 35,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                              decoration: BoxDecoration(
                                                color: TwitterColor.white,
                                                border: Border.all(
                                                    color: Colors.black87
                                                        .withAlpha(180),
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.black87
                                                        .withAlpha(180),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        snapshot.data.name,
                                        style: bio_titleName,
                                      ),
                                      Text(
                                        '@${snapshot.data.username ?? 'No username to show'}',
                                        style: bio_UserName,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        snapshot.data.bio ?? 'No bio to show',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const WidgetSpan(
                                              child: Icon(
                                                Icons.location_on_outlined,
                                                size: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            TextSpan(
                                              text: snapshot.data.location ==
                                                          null ||
                                                      snapshot.data.location ==
                                                          ''
                                                  ? 'No location to show'
                                                  : snapshot.data.location,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const WidgetSpan(
                                              child: Icon(
                                                Icons
                                                    .sports_basketball_outlined,
                                                size: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  ' Born ${snapshot.data.dateOfBirth}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            const WidgetSpan(
                                              child: Icon(
                                                Icons.calendar_month_outlined,
                                                size: 14,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            TextSpan(
                                              text:
                                                  " Joined ${snapshot.data.creationDate}",
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                snapshot.data.followingCount
                                                    .toString(),
                                                style: boldName,
                                              ),
                                              followingString,
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                snapshot.data.followersCount
                                                    .toString(),
                                                style: boldName,
                                              ),
                                              followersString,
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _SliverAppBarDelegate(
                                minHeight: 50,
                                maxHeight: 50,
                                child: Container(
                                  color: Colors.white,
                                  child: AppBar(
                                    bottom: TabBar(
                                      indicator: const UnderlineTabIndicator(
                                        borderSide: BorderSide(
                                            width: 4.0, color: Colors.blue),
                                      ),
                                      controller: _tabController,
                                      isScrollable: true,
                                      labelColor: Colors.black,
                                      unselectedLabelColor: Colors.black54,
                                      indicatorWeight: 2,
                                      indicatorColor: Colors.blue,
                                      tabs: const [
                                        Tab(
                                          text: 'Tweets',
                                        ),
                                        Tab(
                                          text: 'Tweets & replies',
                                        ),
                                        Tab(
                                          text: 'Media',
                                        ),
                                        Tab(
                                          text: 'Likes',
                                        ),
                                      ],
                                    ),
                                    shape: const Border(
                                      bottom: BorderSide(
                                          color: Colors.black12, width: 1),
                                    ),
                                    backgroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                ),
                              ),
                            ),
                          ];
                        },
                        body:
                        Container(
                          child: TabBarView(
                            controller: _tabController,
                            children:  [
                              ListView.custom(

                                physics: const BouncingScrollPhysics(),
                                childrenDelegate:SliverChildBuilderDelegate ((context, index) {
                                  print(Provider.of<TimelineProvider>(context).timelineList.length);
                                  if(index==Provider.of<TimelineProvider>(context,listen: false).timelineList.length-1)
                                  {
                                    Provider.of<TweetsViewModel>(context, listen: false).fetchRandomTweetsOfRandomUsers(context,Provider.of<TweetsViewModel>(context).pageNumber);
                                    return Center(child: Container(width:20,height:20,child: CircularProgressIndicator(color: Colors.grey,strokeWidth:2,)));
                                  }
                                  return TweetCard(
                                    realUserId: "",
                                    userId: "",
                                    shiftTweets: false,
                                    tweetPage:false,
                                    index: index,
                                    tweet: Provider.of<TimelineProvider>(context).timelineList[index],
                                    videoPlayerController: videoPlayerController,
                                  );

                                },
                                    childCount: Provider.of<TimelineProvider>(context).timelineList.length,
                                    findChildIndexCallback: (Key key) {
                                      final ValueKey  valueKey = key as ValueKey ;
                                      final String data = valueKey.value;
                                      return Provider.of<TimelineProvider>(context).timelineList.indexOf(data);
                                    }
                                ),
                              ),
                              ListView.custom(

                                physics: const BouncingScrollPhysics(),
                                childrenDelegate:SliverChildBuilderDelegate ((context, index) {
                                  print(Provider.of<TimelineProvider>(context).timelineList.length);
                                  if(index==Provider.of<TimelineProvider>(context,listen: false).timelineList.length-1)
                                  {
                                    Provider.of<TweetsViewModel>(context, listen: false).fetchRandomTweetsOfRandomUsers(context,Provider.of<TweetsViewModel>(context).pageNumber);
                                    return Center(child: Container(width:20,height:20,child: CircularProgressIndicator(color: Colors.grey,strokeWidth:2,)));
                                  }
                                  return TweetCard(
                                    realUserId: "",
                                    userId: "",
                                    shiftTweets: false,
                                    tweetPage:false,
                                    index: index,
                                    tweet: Provider.of<TimelineProvider>(context).timelineList[index],
                                    videoPlayerController: videoPlayerController,
                                  );

                                },
                                    childCount: Provider.of<TimelineProvider>(context).timelineList.length,
                                    findChildIndexCallback: (Key key) {
                                      final ValueKey  valueKey = key as ValueKey ;
                                      final String data = valueKey.value;
                                      return Provider.of<TimelineProvider>(context).timelineList.indexOf(data);
                                    }
                                ),
                              ),
                              ListView.custom(

                                physics: const BouncingScrollPhysics(),
                                childrenDelegate:SliverChildBuilderDelegate ((context, index) {
                                  print(Provider.of<TimelineProvider>(context).timelineList.length);
                                  if(index==Provider.of<TimelineProvider>(context,listen: false).timelineList.length-1)
                                  {
                                    Provider.of<TweetsViewModel>(context, listen: false).fetchRandomTweetsOfRandomUsers(context,Provider.of<TweetsViewModel>(context).pageNumber);
                                    return Center(child: Container(width:20,height:20,child: CircularProgressIndicator(color: Colors.grey,strokeWidth:2,)));
                                  }
                                  return TweetCard(
                                    realUserId: "",
                                    userId: "",
                                    shiftTweets: false,
                                    tweetPage:false,
                                    index: index,
                                    tweet: Provider.of<TimelineProvider>(context).timelineList[index],
                                    videoPlayerController: videoPlayerController,
                                  );

                                },
                                    childCount: Provider.of<TimelineProvider>(context).timelineList.length,
                                    findChildIndexCallback: (Key key) {
                                      final ValueKey  valueKey = key as ValueKey ;
                                      final String data = valueKey.value;
                                      return Provider.of<TimelineProvider>(context).timelineList.indexOf(data);
                                    }
                                ),
                              ),
                              ListView.custom(

                                physics: const BouncingScrollPhysics(),
                                childrenDelegate:SliverChildBuilderDelegate ((context, index) {
                                  print(Provider.of<TimelineProvider>(context).timelineList.length);
                                  if(index==Provider.of<TimelineProvider>(context,listen: false).timelineList.length-1)
                                  {
                                    Provider.of<TweetsViewModel>(context, listen: false).fetchRandomTweetsOfRandomUsers(context,Provider.of<TweetsViewModel>(context).pageNumber);
                                    return Center(child: Container(width:20,height:20,child: CircularProgressIndicator(color: Colors.grey,strokeWidth:2,)));
                                  }
                                  return TweetCard(
                                    realUserId: "",
                                    userId: "",
                                    shiftTweets: false,
                                    tweetPage:false,
                                    index: index,
                                    tweet: Provider.of<TimelineProvider>(context).timelineList[index],
                                    videoPlayerController: videoPlayerController,
                                  );

                                },
                                    childCount: Provider.of<TimelineProvider>(context).timelineList.length,
                                    findChildIndexCallback: (Key key) {
                                      final ValueKey  valueKey = key as ValueKey ;
                                      final String data = valueKey.value;
                                      return Provider.of<TimelineProvider>(context).timelineList.indexOf(data);
                                    }
                                ),
                              ),

                        ],
                        ),
                        ),
                        ),
                  ),
                  buildPic(snapshot as AsyncSnapshot<User>),
                  /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Container(
                  height: 90,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: ElevatedButton(
                    onPressed: () {Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context){ return TimelineScreen(); },
                      ),
                    );
                    },
                    child: Icon(Icons.arrow_back, color: Colors.white,size: 20,),
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      maximumSize: Size(30, 30),
                      minimumSize: Size(30, 30),
    
                      padding: EdgeInsets.all(0),
                      primary: Colors.black.withOpacity(0.5), // <-- Button color
                      onPrimary: Colors.blue, // <-- Splash color
                    ),
                  ),
                ),
                  Container(
                    height: 90,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: ElevatedButton(
                      onPressed: () {Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context){ return TimelineScreen(); },
                        ),
                      );
                      },
                      child: Icon(Icons.search, color: Colors.white,size: 20,),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        maximumSize: Size(30, 30),
                        minimumSize: Size(30, 30),
    
                        padding: EdgeInsets.all(0),
                        primary: Colors.black.withOpacity(0.5), // <-- Button color
                        onPrimary: Colors.blue, // <-- Splash color
                      ),
                    ),
                  ),],
              ),*/
                ],
              ),
            );
          }),
    );
  }

  Widget buildPic(AsyncSnapshot<User> snapshot) {
    const double defaultMargin = 120;
    const double defaultStart = 100;
    const double defaultEnd = defaultStart / 2;

    double top = defaultMargin;
    double scale = 1.0;
    double Picscale = 1.0;
    double offset = 0;

    if (_scrollController.hasClients) {
      offset = _scrollController.offset;
      top -= offset;

      if (offset < defaultMargin - defaultStart) {
        scale = 1.0;
        Picscale = 1.0;
      } else if (offset < defaultStart - defaultEnd) {
        scale = (defaultMargin - defaultEnd - offset) / defaultEnd;
        Picscale = offset > 35
            ? Picscale = 0.0
            : (defaultMargin - defaultEnd - offset) / defaultEnd;
      } else {
        scale = 0.0;
        Picscale = 0.0;
      }
    }

    return Positioned(
      top: top - 20,
      left: 20,
      child: Transform(
        transform: Matrix4.identity()..scale(Picscale),
        alignment: Alignment.bottomCenter,
        child: CircleAvatar(
          radius: 45,
          backgroundColor: AppColor.white,
          child: CircleAvatar(
            radius: 40,
            child: ProfilePicture(
              profilePictureFunctionality: () {
                Scaffold.of(context).openDrawer();
              },
              profilePictureImage: snapshot.data!.profilePicUrl ??
                  "https://pbs.twimg.com/media/EEI178KWsAEC79p.jpg",
              profilePictureSize: 40,
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
