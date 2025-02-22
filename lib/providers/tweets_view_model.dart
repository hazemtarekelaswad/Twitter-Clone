import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twitter/models/comment_model.dart';
import 'package:twitter/providers/comments_provider.dart';
import 'package:twitter/providers/timeline_provider.dart';
import 'package:twitter/services/tweets_service.dart';
import '../models/tweet_complete_model.dart';

class TweetsViewModel extends ChangeNotifier {
  dynamic addedDataToStream;
  int pageNumber=1;
  ///=StreamController streamController;

//this function fetch tweets from api call and then update the stream

  Future<void> fetchMyTweets(
      BuildContext context) async {
    addedDataToStream = await TweetsApi().fetchMyTweets();
    Provider.of<TimelineProvider>(context,listen: false).updateMyTimeline(
        addedDataToStream);
    notifyListeners();
  }

  Future<dynamic>fetchUserTweets(String userId) async {
    addedDataToStream = await TweetsApi().fetchUserTweets(userId);
    return addedDataToStream;
    notifyListeners();
  }
  Future<dynamic>fetchLikedUserTweets(String userId) async {
    addedDataToStream = await TweetsApi().fetchLikedUserTweets(userId);
    return addedDataToStream;
    notifyListeners();
  }
  Future<dynamic>fetchHomeUserRetweets(String userId) async {
    addedDataToStream = await TweetsApi().fetchHomeUserTweets(userId);
    return addedDataToStream;
    notifyListeners();
  }
  void updateRandomTweetsPageNumber()
  {
    pageNumber=pageNumber+1;
    notifyListeners();
  }
  Future<void> fetchRandomTweetsOfRandomUsers(BuildContext context, int page) async {
    addedDataToStream = await TweetsApi().fetchRandomTweetsOfRandomUsers(page);
    Provider.of<TimelineProvider>(context,listen: false).updateMyTimelineDuringPagination(addedDataToStream);
    updateRandomTweetsPageNumber();
    notifyListeners();
  }
  Future<dynamic> fetchTweetByTweetId(String tweetId) async
  {
    addedDataToStream =await TweetsApi().fetchTweetByTweetId(tweetId);
    return addedDataToStream;
    // Provider.of<CommentsProvider>(context,listen: false).updateTweetCommentList(addedDataToStream);
    // notifyListeners();
  }
  Future<dynamic> fetchNotQuotedRetweetByRetweetId(String tweetId,BuildContext context) async
  {
    addedDataToStream =await TweetsApi().fetchRetweet(tweetId);
    // Provider.of<TimelineProvider>(context,listen: false).updateMyTimeline(
    //     addedDataToStream);
    // print(addedDataToStream[0]);
    return addedDataToStream;
    // Provider.of<CommentsProvider>(context,listen: false).updateTweetCommentList(addedDataToStream);
    // notifyListeners();
  }
  Future<dynamic> fetchQuotedRetweetByRetweetId(String tweetId,BuildContext context) async
  {
    addedDataToStream =await TweetsApi().fetchQuotedRetweet(tweetId);
    // Provider.of<TimelineProvider>(context,listen: false).updateMyTimeline(
    //     addedDataToStream);
    // print(addedDataToStream[0]);
    return addedDataToStream;
    // Provider.of<CommentsProvider>(context,listen: false).updateTweetCommentList(addedDataToStream);
    // notifyListeners();
  }
  Future<void> fetchTweetByTweetIdForTweetComments(BuildContext context, String tweetId) async
  {
    addedDataToStream= await TweetsApi().fetchTweetByTweetId(tweetId);

    Provider.of<CommentsProvider>(context,listen: false).updateTweetCommentList(addedDataToStream);
    notifyListeners();
  }

  Future<void> addTweet(
      {required String text,
      required List<dynamic> images,
      required List<dynamic> videos,required BuildContext context}) async {
    String tweetId=await TweetsApi().addTweet(text: text, images: images, videos: videos);
    await getAddedTweet(context, tweetId);
    notifyListeners();
  }
  Future<void> addQuotedRetweet(
      {required String text,
        required List<dynamic> images,
        required List<dynamic> videos,required BuildContext context,required bool quoted,required String tweetIID}) async {
    String tweetId=await TweetsApi().addQuotedRetweet(text: text, images: images, videos: videos,quoted:quoted,tweetId: tweetIID );
    await getAddedQuotedRetweet(context, tweetId);
    notifyListeners();
  }
  Future<void> Retweet(
      {required BuildContext context,required bool quoted,required String tweetIID}) async {
    String tweetId=await TweetsApi().Retweet(quoted:quoted,tweetId: tweetIID );
    await getAddedRetweet(context, tweetId);
    notifyListeners();
  }
  Future<void>getAddedTweet(BuildContext context,String tweetId)async
  {
    //we need to know the tweet id of the tweet which got added recently
   addedDataToStream= await TweetsApi().fetchTweetByTweetId(tweetId);
   await Provider.of<TimelineProvider>(context,listen: false).addTweetToMyTimeline(addedDataToStream[0]);
     notifyListeners();
  }
  Future<void>getAddedQuotedRetweet(BuildContext context,String tweetId)async
  {
    //we need to know the tweet id of the tweet which got added recently
    addedDataToStream= await TweetsApi().fetchQuotedRetweet(tweetId);
    await Provider.of<TimelineProvider>(context,listen: false).addTweetToMyTimeline(addedDataToStream[0]);
    notifyListeners();
  }
  Future<void>getAddedRetweet(BuildContext context,String tweetId)async
  {
    //we need to know the tweet id of the tweet which got added recently
    addedDataToStream= await TweetsApi().fetchRetweet(tweetId);
    print(addedDataToStream);
    await Provider.of<TimelineProvider>(context,listen: false).addTweetToMyTimeline(addedDataToStream[0]);
    notifyListeners();
  }
  Future<void> addComment(
      {required String text,
        required List<dynamic> images,
        required List<dynamic> videos,required String tweetId,required BuildContext context}) async {
    await TweetsApi().addComment(text: text, images: images, videos: videos,tweetId:tweetId);
    addedDataToStream=await TweetsApi().fetchTweetByTweetId(tweetId);
    dynamic addedComment=await TweetsApi().fetchTweetByTweetId(addedDataToStream[0].comments.last);
    Provider.of<CommentsProvider>(context, listen: false).updateComment(addedComment[0]);
    print(addedDataToStream[0].comments.last);
    await Provider.of<TimelineProvider>(context,listen: false).notify();


    notifyListeners();
  }
  Future<void>  deleteTweet(BuildContext context,
      String tweetId,tweetIndex) async {

     TweetsApi().deleteTweet(tweetId: tweetId);
     Provider.of<TimelineProvider>(context,listen: false).removeTweetFromTimeline(tweetIndex);
     notifyListeners();
  }
  Future<void>likeUnlike(String tweetId,TweetMain tweet)async
  {
    await TweetsApi().likeUnlike(tweetId: tweetId,tweet: tweet);
    notifyListeners();
  }
}
