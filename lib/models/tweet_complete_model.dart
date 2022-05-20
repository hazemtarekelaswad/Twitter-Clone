import 'dart:ui';

import 'package:twitter/models/tweet_model.dart';
class TweetMain
{
  TweetMain({required this.tweet, this.comments, this.replies,required this.images,required this.videos, this.likers});
  Tweet tweet;
  List<dynamic>?comments;
  List<dynamic>?likers;
  List<List<dynamic>>?replies;
  List<dynamic>images;
  List<dynamic>videos;
  Color threeDotsColor=const Color(0xffAFD9F4);

  //tweet info getters------------------------------------
  //get tweet id
  String getTweetId()
  {
    return tweet.tweetId;
  }
  //get user id of user who made the tweet
  String getuserId()
  {
    return tweet.userId;
  }
  //get name of user who made the tweet
  String getname()
  {
    return tweet.name;
  }
  //get username of user who made the tweet
  String getusername()
  {
    return tweet.username;
  }
  //get profilePicUrl of user who made the tweet
  String getTweetprofilePicUrl()
  {
    return tweet.profilePicUrl;
  }
  //get text  tweet
  String getTweettext()
  {
    return tweet.text;
  }
  //get bio of user who made the tweet
  String? getTweetbio()
  {
    return tweet.bio;
  }
  //get followingCount of user who made the tweet
  int getfollowingCount()
  {
    return tweet.followingCount;
  }
  //get followersCount of user who made the tweet
  int getfollowersCount()
  {
    return tweet.followersCount;
  }
  //comments getters-------------------------------------
  int getCommentCount()
{
  return tweet.commentCount;
}
  int getRetweetCount()
  {
    return tweet.retweetCount;
  }
  int getLikesCount()
  {
    return tweet.likeCount;
  }
}