
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:like_button/like_button.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:twitter_clone/constants/assets_constants.dart';

import 'package:twitter_clone/features/auth/controller/auth_controller.dart';
import 'package:twitter_clone/features/tweet/view/twitter_reply_view.dart';
import 'package:twitter_clone/features/tweet/widgets/hashtag_text.dart';
import 'package:twitter_clone/features/tweet/widgets/tweet_icon_button.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/theme/pallete.dart';

import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../../core/enums/tweet_type_enum.dart';
import '../../user_profile/view/user_profile_view.dart';
import '../controller/tweet_controller.dart';
import 'carousel_image.dart';

class TweetCard extends ConsumerWidget {

  final Tweet tweet;

  const TweetCard({
    super.key,
    required this.tweet,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final currentUser = ref.watch(currentUserDetailsProvider).value;

    return currentUser == null ? const SizedBox() : ref.watch(userDetailsProvider(tweet.uid)).when(
      data: (user) {
        return InkWell(
          onTap: () {
            Navigator.push(context, TwitterReplyScreen.route(tweet));
          },
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, UserProfileView.route(user));
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(user.profilePic),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(tweet.retweetedBy.isNotEmpty)
                          Row(
                            children: [
                              SvgPicture.asset(
                                AssetsConstants.retweetIcon,
                                color: Pallete.greyColor,
                                height: 18,
                              ),
                              const SizedBox(width: 2,),
                              Text(
                                '${tweet.retweetedBy} Retweeted',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Pallete.greyColor,
                                ),
                              ),
                            ],
                          ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '@${user.name} · ${timeago.format(
                                tweet.tweetedAt,
                                locale: 'en_short',
                              )}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Pallete.greyColor,
                              ),
                            ),
                          ],
                        ),
                        if(tweet.repliedTo.isNotEmpty)
                          ref.watch(getTweetByIdProvider(tweet.repliedTo)).when(
                            data: (repliedToTweet) {

                              final replyingToUser = ref.watch(userDetailsProvider(repliedToTweet.uid)).value;

                              return Container(
                                margin: const EdgeInsets.only(
                                  top: 5,
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Replying to ',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Pallete.greyColor,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '@${replyingToUser?.name}',
                                        style: const TextStyle(
                                          color: Pallete.blueColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            error: (error, st) => ErrorText(error: error.toString()),
                            loading: () => const SizedBox(),
                          ),
                        const SizedBox(height: 5),
                        HashtagText(text: tweet.text),
                        const SizedBox(height: 10),
                        if(tweet.tweetType == TweetType.image)
                          CarouselImage(imageLinks: tweet.imageLinks),
                        if(tweet.link.isNotEmpty) ... [
                          const SizedBox(height: 5),
                          AnyLinkPreview(
                            link: 'https://${tweet.link}',
                            displayDirection: UIDirection.uiDirectionHorizontal,
                          ),
                        ],
                        Container(
                          margin: const EdgeInsets.only(
                            top: 10,
                            right: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TweetIconButton(
                                pathName: AssetsConstants.commentIcon,
                                text: tweet.commentIds.length.toString(),
                                onTap: () {},
                              ),
                              TweetIconButton(
                                pathName: AssetsConstants.retweetIcon,
                                text: tweet.reshareCount.toString(),
                                onTap: () {
                                  ref.read(tweetControllerProvider.notifier).reshareTweet(
                                    tweet,
                                    currentUser,
                                    context,
                                  );
                                },
                              ),
                              LikeButton(
                                onTap: (isLiked) async {
                                  ref.read(tweetControllerProvider.notifier).likeTweet(
                                    tweet, currentUser
                                  );
                                  return !isLiked;
                                },
                                size: 23,
                                isLiked: tweet.likes.contains(currentUser.uid),
                                likeBuilder: (bool isLiked) {
                                  return isLiked ? SvgPicture.asset(
                                    AssetsConstants.likeFilledIcon,
                                    color: Pallete.redColor,
                                  ) : SvgPicture.asset(
                                    AssetsConstants.likeOutlinedIcon,
                                    color: Pallete.greyColor,
                                  );
                                },
                                likeCount: tweet.likes.length,
                                countBuilder: (likeCount, isLiked, text) {
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Text(
                                      text,
                                      style: TextStyle(
                                        color: isLiked ? Pallete.redColor : Pallete.whiteColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              TweetIconButton(
                                pathName: AssetsConstants.viewsIcon,
                                text: (tweet.commentIds.length + tweet.likes.length + tweet.reshareCount).toString(),
                                onTap: () {},
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.share_outlined,
                                  color: Pallete.greyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 1),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Pallete.greyColor,
                height: 3,
              ),
            ],
          ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
