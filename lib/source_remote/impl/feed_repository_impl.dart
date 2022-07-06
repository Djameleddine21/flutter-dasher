import 'package:flutter_dasher/common/model/tweet.dart';
import 'package:flutter_dasher/domain/repository/feed_repository.dart';
import 'package:intl/intl.dart';
import 'package:twitter_api_v2/twitter_api_v2.dart';

class FeedRepositoryImpl implements FeedRepository {
  FeedRepositoryImpl(this.twitterApi);

  final TwitterApi twitterApi;

  @override
  Future<List<Tweet>> fetchFeedTimeline() async {
    final response = await twitterApi.tweetsService.lookupHomeTimeline(
      userId: '219787739',
      tweetFields: [
        TweetField.publicMetrics,
        TweetField.createdAt,
      ],
      userFields: [
        UserField.createdAt,
        UserField.profileImageUrl,
      ],
      expansions: [
        TweetExpansion.authorId,
      ],
    );

    return response.data.map((tweet) {
      final UserData? user = response.includes?.users?.singleWhere((user) => user.id == tweet.authorId);

      return Tweet(
        tweet.id,
        tweet.text,
        user!.profileImageUrl,
        user.name,
        user.username,
        tweet.publicMetrics!.likeCount,
        tweet.publicMetrics!.retweetCount,
        tweet.publicMetrics!.replyCount,
        DateFormat.MMMd().format(tweet.createdAt!),
      );
    }).toList();
  }
}
