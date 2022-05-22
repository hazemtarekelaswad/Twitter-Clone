import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:twitter/models/tweet_complete_model.dart';
import 'package:twitter/models/tweet_model.dart';
import 'package:twitter/models/comment_model.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/image_model.dart';
import '../models/likers_model.dart';
import '../models/reply_model.dart';
import '../models/video_model.dart';

class TweetsApi {
  Future<List<TweetMain>?> fetchMyTweets() async {
    final Uri uri = Uri.parse('$backendUrl/tweets/all/me');
    http.Response response = await http.get(uri, headers: {
      "x-access-token":
          "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOiI2MjY1NTFmNDRkNTc4NmY0MzdjYmIyNWIiLCJhZG1pbiI6ZmFsc2UsImV4cCI6MTY4MjM0MzQ5MX0.8xbJXtfITqlxM1YwdaRV1kr1qXRtvQJ3glhjxNdOPD4"
    });
    String data = response.body;
    var de = jsonDecode(data);
    var jsonData = jsonDecode(data)["tweets"];

    List<dynamic> tweetsList = [];

    //see if comments in this
    tweetsList = jsonData.map((e) => Tweet.fromJson(e)).toList(); //[2],[3]
    //----------------------------------------------------------------------
    List<TweetMain> tweetsMain = [];
    List<dynamic> comments = [];
    List<dynamic> likers = [];
    List<dynamic> images = [];
    List<dynamic> videos = [];
    //--------------------------------------------------------------------------
    for (int i = 0; i < tweetsList.length; i++) {
      images = [];
      comments = [];
      likers = [];
      videos = [];
      if (tweetsList[i].comments.length > 0) {
        comments = tweetsList[i].comments.toList();
      }
      if (tweetsList[i].likerIds.length > 0) {
        likers = tweetsList[i].likerIds
          ..map((e) => Likers.fromJson(e)).toList();
      }
      if (tweetsList[i].images.length ==1) {
        images = tweetsList[i].images.map((e) => Imagei.fromJson(e)).toList();
      }
      if (tweetsList[i].videos.length > 0) {
        videos = tweetsList[i].videos.map((e) => Video.fromJson(e)).toList();
      }
      TweetMain tweetIMain = TweetMain(
          tweet: tweetsList[i],
          comments: comments,
          likers: likers,
          videos: videos,
          images: images);
      tweetsMain.add(tweetIMain);
    }
    return tweetsMain;
  }

  Future<List<TweetMain>?> fetchUserTweets(String userId) async {
    final Uri uri = Uri.parse('$backendUrl/tweets/all?Id=$userId');
    http.Response response = await http.get(uri, headers: {
      "x-access-token":
          "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOiI2MjY1NTFmNDRkNTc4NmY0MzdjYmIyNWIiLCJhZG1pbiI6ZmFsc2UsImV4cCI6MTY4MjM0MzQ5MX0.8xbJXtfITqlxM1YwdaRV1kr1qXRtvQJ3glhjxNdOPD4"
    });
    String data = response.body;
    var jsonData = jsonDecode(data)["tweets"];
    List<dynamic> tweetsList = [];

    //see if comments in this
    tweetsList = jsonData.map((e) => Tweet.fromJson(e)).toList(); //[2],[3]
    //----------------------------------------------------------------------
    List<TweetMain> tweetsMain = [];
    List<dynamic> comments = [];
    List<dynamic> likers = [];
    List<dynamic> images = [];
    List<dynamic> videos = [];
    //--------------------------------------------------------------------------
    for (int i = 0; i < tweetsList.length; i++) {
      images = [];
      comments = [];
      likers = [];
      videos = [];
      if (tweetsList[i].comments.length > 0) {
        comments = tweetsList[i].comments.toList();
      }
      if (tweetsList[i].likerIds.length > 0) {
        likers = tweetsList[i].likerIds
          ..map((e) => Likers.fromJson(e)).toList();
      }
      if (tweetsList[i].images.length > 0) {
        images = tweetsList[i].images.map((e) => Imagei.fromJson(e)).toList();
      }
      if (tweetsList[i].videos.length > 0) {
        videos = tweetsList[i].videos.map((e) => Video.fromJson(e)).toList();
      }
      TweetMain tweetIMain = TweetMain(
          tweet: tweetsList[i],
          comments: comments,
          likers: likers,
          videos: videos,
          images: images);
      tweetsMain.add(tweetIMain);
    }
    return tweetsMain;
  }

  Future<List<TweetMain>?> fetchRandomTweetsOfRandomUsers(int page) async {
    final queryParameters = {
      'page': page,
    };
    // final Uri uri = Uri.parse('$backendUrl/tweets/random?page=:page');
    final uri = Uri.parse('$backendUrl/tweets/random?page=$page');
    // final uri = Uri.http(
    //     Http().getBackendBaseUrl(), '/tweets/random', queryParameters);
    http.Response response = await http.get(
      uri,
      headers: {
        "x-access-token":
            "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOiI2MjY1NTFmNDRkNTc4NmY0MzdjYmIyNWIiLCJhZG1pbiI6ZmFsc2UsImV4cCI6MTY4MjM0MzQ5MX0.8xbJXtfITqlxM1YwdaRV1kr1qXRtvQJ3glhjxNdOPD4"
      },
    );
    String data = response.body;
    var de = jsonDecode(data);
    print(de);
    if (jsonDecode(data)["404"] != "tweets are unavailable") {
      var jsonData = jsonDecode(data)["tweets"];
      List<dynamic> tweetsList = [];
      //see if comments in this
      tweetsList = jsonData.map((e) => Tweet.fromJson(e)).toList(); //[2],[3]
      //----------------------------------------------------------------------
      List<TweetMain> tweetsMain = [];
      List<dynamic> comments = [];
      List<dynamic> likers = [];
      List<dynamic> images = [];
      List<dynamic> videos = [];
      //--------------------------------------------------------------------------
      for (int i = 0; i < tweetsList.length; i++) {
        images = [];
        comments = [];
        likers = [];
        videos = [];
        if (tweetsList[i].comments.length > 0) {
          comments = tweetsList[i].comments.toList();
        }
        if (tweetsList[i].likerIds.length > 0) {
          likers = tweetsList[i].likerIds
            ..map((e) => Likers.fromJson(e)).toList();
        }
        if (tweetsList[i].images.length > 0) {
          images = tweetsList[i].images.map((e) => Imagei.fromJson(e)).toList();
        }
        if (tweetsList[i].videos.length > 0) {
          videos = tweetsList[i].videos.map((e) => Video.fromJson(e)).toList();
        }
        TweetMain tweetIMain = TweetMain(
            tweet: tweetsList[i],
            comments: comments,
            likers: likers,
            videos: videos,
            images: images);
        tweetsMain.add(tweetIMain);
      }
      return tweetsMain;
    }
    return null;
  }


  Future<List<TweetMain>?> fetchTweetByTweetId(String tweetId) async {
    final Uri uri = Uri.parse('$backendUrl/tweets/tweet_id?Id=$tweetId');
    http.Response response = await http.get(uri, headers: {
      "x-access-token":
          "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOiI2MjY1NTFmNDRkNTc4NmY0MzdjYmIyNWIiLCJhZG1pbiI6ZmFsc2UsImV4cCI6MTY4MjM0MzQ5MX0.8xbJXtfITqlxM1YwdaRV1kr1qXRtvQJ3glhjxNdOPD4"
    });
    String data = response.body;
    var jsonData = jsonDecode(data)["tweet"];
    List<dynamic> d = [];
    d.add(jsonData);
    List<dynamic> tweetsList = [];

    //see if comments in this

    tweetsList = d.map((e) => Tweet.fromJson(e)).toList(); //[2],[3]
    //----------------------------------------------------------------------
    List<TweetMain> tweetsMain = [];
    List<dynamic> comments = [];
    List<dynamic> likers = [];
    List<dynamic> images = [];
    List<dynamic> videos = [];
    //--------------------------------------------------------------------------

    for (int i = 0; i < tweetsList.length; i++) {
      images = [];
      comments = [];
      likers = [];
      videos = [];
      if (tweetsList[i].comments.length > 0) {
        comments = tweetsList[i].comments.toList();
      }
      if (tweetsList[i].likerIds.length > 0) {
        likers = tweetsList[i].likerIds
          ..map((e) => Likers.fromJson(e)).toList();
      }
      if (tweetsList[i].images.length > 0) {
        images = tweetsList[i].images.map((e) => Imagei.fromJson(e)).toList();
      }
      if (tweetsList[i].videos.length > 0) {
        videos = tweetsList[i].videos.map((e) => Video.fromJson(e)).toList();
      }
      TweetMain tweetIMain = TweetMain(
          tweet: tweetsList[i],
          comments: comments,
          likers: likers,
          videos: videos,
          images: images);
      tweetsMain.add(tweetIMain);
    }
    return tweetsMain;
  }

  //add tweet is done using mock server for now as testing in backend stop

  Future<void> addTweet(
      {required String text,
      required List<dynamic> images,
      required List<dynamic> videos}) async {
    var headers = {
      'x-access-token':
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOiI2MjY1NTFmNDRkNTc4NmY0MzdjYmIyNWIiLCJhZG1pbiI6ZmFsc2UsImV4cCI6MTY4MjM0MzQ5MX0.8xbJXtfITqlxM1YwdaRV1kr1qXRtvQJ3glhjxNdOPD4',
      'follow_redirects': 'true',
      'Content-Type': 'application/json'
    };
    var request =
        http.Request('POST', Uri.parse('http://45.79.245.94:5000/tweets'));
    request.body =
        json.encode({"text": text, "images": images, "videos": videos});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<TweetMain> getAddedTweet() async {
    dynamic myTweets = await fetchMyTweets();
    return myTweets.last;
  }

  Future<void> deleteTweet({required String tweetId}) async {
    var headers = {
      'x-access-token':
          'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJfaWQiOiI2MjY1NTFmNDRkNTc4NmY0MzdjYmIyNWIiLCJhZG1pbiI6ZmFsc2UsImV4cCI6MTY4MjM0MzQ5MX0.8xbJXtfITqlxM1YwdaRV1kr1qXRtvQJ3glhjxNdOPD4'
    };
    var request = http.Request(
        'DELETE', Uri.parse('http://45.79.245.94:5000/tweets?Id=$tweetId'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future<void> addLike({required String tweetId}) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('http://192.168.1.8:8000/users/likes'));
    request.body = json.encode({
      "tweet_id": tweetId, //random id for tweet created
      "user_id": Auth.userId,
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    print(response.toString());
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

    // SEND NOTIFICATION
    sendLikeNotification();
  }

  Future<void> sendLikeNotification() async {
    var response = await http.post(
      Uri.parse('${Http().getBaseUrl()}/users/notifications'),
      headers: {
        'Content-Type': 'application/json',
        'x-access-token': Auth.token
      },
      body: jsonEncode({
        "user_id": Auth.userId,
        "notification_type": "string", //! to be changed
      }),
    );

    if (response.statusCode == 200) {
      log('Like Notification SENT');
    } else {
      log('Like Notification Unauthorized');
    }
  }
}
