import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:twitter/providers/stream_controller_provider.dart';
import 'package:twitter/screens/notifications_screen/NotificationsScreen.dart';
import 'package:twitter/screens/search_screen/SearchScreen.dart';
import 'package:twitter/screens/timeline_screen/timeline_screen.dart';

import 'custom_page_route.dart';
class TimelineBottomBar extends StatelessWidget {
  const TimelineBottomBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: BottomAppBar(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
          [
            //home icon which on short press goes upward to the the screen beginning and on long press open bottom sheet making you able to create new account
            GestureDetector(
              onTap: ()
              {
                controller.animateTo(0.0,
                    curve: Curves.easeIn, duration: const Duration(milliseconds: 200));
                Provider.of<StreamControllerProvider>(context).disposed();
              },
              onLongPress: ()
              {
                showModalBottomSheet(
                  context: context,
                  builder:(context)=>
                      Container(
                        height: 50,
                      ),
                );
              },
              child: IconButton(onPressed: (){
                Provider.of<StreamControllerProvider>(context,listen: false).disposed();
                Navigator.of(context).push(
                    CustomPageRoute
                      (child:TimelineScreen(),beginX: 0,beginY: 1),
                );
              },
                icon: Icon(FontAwesomeIcons.house,
              ),),
            ),
            IconButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context){ return SearchScreen(); },
                ),
              );
            }, icon: Icon(Icons.search, size: 30,
            ),),
            const Icon(
              FontAwesomeIcons.microphone,
            ),
            IconButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context){ return NotificationsScreen(); },
                ),
              );
            }, icon: Icon(FontAwesomeIcons.bell,
            ),),
            const Icon(
              Icons.mail_outline_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
